from dataclasses import dataclass
from functools import partial
from typing import Callable, Optional

import diskcache as dc
import matplotlib.pyplot as plt
import pandas as pd

from pytesis.datasets import plot_dataset
from pytesis.fermat import fermat_dist
from pytesis.intervals import (
    DEFAULT_CORES,
    IntervalResult,
    bootstrap_function_interval,
    hausd_interval,
    make_grid,
    plot_result,
)
from pytesis.power import distance_power, function_power
from pytesis.utils import get_func_name, kde_grid

CACHE_NAME = "cache_runs"


@dataclass
class Intervals:
    X: pd.DataFrame
    euclidean: IntervalResult
    fermat: IntervalResult
    kde: IntervalResult


@dataclass
class Results:
    intervals: Intervals
    powers: pd.DataFrame


def plot_all_intervals(intervals: Intervals, degrees: Optional[list[int]] = None):
    fig = plt.figure(figsize=(14, 10))
    d = intervals.X.shape[1]
    if d == 2:
        ax1 = fig.add_subplot(2, 2, 1)
    elif d == 3:
        ax1 = fig.add_subplot(2, 2, 1, projection="3d")
    else:
        raise ValueError("Only 2D and 3D datasets are supported")
    ax2 = fig.add_subplot(2, 2, 2)
    ax3 = fig.add_subplot(2, 2, 3)
    ax4 = fig.add_subplot(2, 2, 4)
    plot_dataset(intervals.X, ax=ax1)
    plot_result(intervals.euclidean, ax=ax2, title="Euclideo", degrees=degrees)
    plot_result(intervals.fermat, ax=ax3, title="Fermat", degrees=degrees)
    plot_result(intervals.kde, ax=ax4, title="Densidad", degrees=degrees)
    fig.show()


def run_all_intervals(
    X,
    h: float = 0.3,
    robust_quantile: float | None = None,
    B: int = 300,
    grid_n: int = 100,
    log: bool = True,
    plot: bool = True,
    cache_prefix: str | None = None,
    force_run: bool = False,
    ncores: int = DEFAULT_CORES,
    plot_kwargs: dict = {},
) -> Intervals:
    cache_key = f"{cache_prefix}_{h}_{B}_{grid_n}_{robust_quantile}_only_intervals"
    cache = dc.Cache(CACHE_NAME)
    if log:
        print("Starting run...")
    if cache_key in cache and not force_run:
        if log:
            print("Intervals found in cache")
        intervals = cache[cache_key]
    else:
        result_euclid = hausd_interval(X, B=B, robust_quantile=robust_quantile, ncores=ncores)
        if log:
            print("Finished running euclidean")
        result_kde = bootstrap_function_interval(
            X, B=B, value_function=partial(kde_grid, h=h), grid_n=grid_n, ncores=ncores
        )
        if log:
            print("Finished running KDE")
        fermat_matrix = fermat_dist(X, alpha=2)
        if log:
            print("Computed fermat distance matrix")
        result_fermat = hausd_interval(
            fermat_matrix, B=B, pairwise_dist=True, robust_quantile=robust_quantile, ncores=ncores
        )
        if log:
            print("Finished running Fermat")
        intervals = Intervals(X=X, euclidean=result_euclid, fermat=result_fermat, kde=result_kde)
        cache[cache_key] = intervals
    if plot:
        plot_all_intervals(intervals, **plot_kwargs)  # type: ignore
    return intervals  # type: ignore


def run_all(
    dataset_factory: Callable,
    h: float = 0.3,
    robust_quantile: float | None = None,
    B_power: int = 30,
    B_interval: int = 300,
    grid_n: int = 100,
    ncores: int = 3,
    log: bool = True,
    plot: bool = True,
    cache_key: str | None = None,
) -> Results:
    func_name = get_func_name(dataset_factory)
    cache_prefix = cache_key or f"{func_name}_{h}_{B_power}_{B_interval}_{grid_n}"
    # NOTE: robust_quantile was added after, so don't interfiere with previous stored caches
    if not cache_key and robust_quantile is not None:
        cache_prefix += f"_{robust_quantile}"
    cache = dc.Cache(CACHE_NAME)

    X = dataset_factory()

    intervals_key = f"{cache_prefix}_intervals"
    if log:
        print("Starting computing intervals")
        print("Intervals found in cache: ", intervals_key in cache)
    if intervals_key not in cache:
        intervals = run_all_intervals(
            X,
            h=h,
            B=B_interval,
            grid_n=grid_n,
            plot=False,
            log=log,
            robust_quantile=robust_quantile,
        )
        cache[intervals_key] = intervals
    intervals: Intervals = cache[intervals_key]  # type: ignore
    # TODO: X was added to intervals after most of the caches where created. If you decide to
    # redo the caches, this wont be needed
    if not hasattr(intervals, "X"):
        intervals.X = X
    # END TODO
    if plot:
        plot_all_intervals(intervals)

    euclid_power_key = f"{cache_prefix}_euclid_power"
    fermat_power_key = f"{cache_prefix}_fermat_power"
    kde_power_key = f"{cache_prefix}_kde_power"
    if log:
        print("Starting power analysis")
        print("Euclid in cache: ", euclid_power_key in cache)
        print("Fermat in cache: ", fermat_power_key in cache)
        print("KDE in cache: ", kde_power_key in cache)

    if euclid_power_key not in cache:
        power_euclid = distance_power(
            dataset_factory,
            band=intervals.euclidean.band,
            dist_function=None,
            B=B_power,
            ncores=ncores,
        )
        cache[euclid_power_key] = power_euclid
        if log:
            print("Finished euclid power analysis")
    power_euclid = cache[euclid_power_key]

    if fermat_power_key not in cache:
        power_fermat = distance_power(
            dataset_factory,
            band=intervals.fermat.band,
            dist_function=fermat_dist,
            B=B_power,
            ncores=ncores,
        )
        cache[fermat_power_key] = power_fermat
        if log:
            print("Finished fermat power analysis")
    power_fermat = cache[fermat_power_key]

    if kde_power_key not in cache:
        dimensions, positions = make_grid(X, grid_n=grid_n)
        power_kde = function_power(
            dataset_factory,
            band=intervals.kde.band,
            value_function=partial(kde_grid, h=h),
            positions=positions,
            dimensions=dimensions,
            B=B_power,
            ncores=ncores,
        )
        cache[kde_power_key] = power_kde
        if log:
            print("Finished kde power analysis")
    power_kde = cache[kde_power_key]

    power_results = pd.concat(
        [power_euclid.table, power_fermat.table, power_kde.table],
        keys=["Euclídeo", "Fermat", "KDE"],
    )
    power_results.columns = ["Agujeros", "# Detecciones", "% Detecciones"]
    power_results["% Detecciones"] = power_results["% Detecciones"] * 100
    power_results.index = power_results.index.get_level_values(0)
    power_results.set_index(keys="Agujeros", append=True, inplace=True)
    power_results = power_results.reindex(
        pd.MultiIndex.from_product([power_results.index.levels[0], power_results.index.levels[1]]),
        fill_value=0,
    )
    cache.close()
    return Results(intervals=intervals, powers=power_results)
