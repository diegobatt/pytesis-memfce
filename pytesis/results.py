from dataclasses import dataclass
from functools import partial
from typing import Callable

import diskcache as dc
import matplotlib.pyplot as plt
import pandas as pd

from pytesis.datasets import plot_dataset
from pytesis.fermat import fermat_dist
from pytesis.intervals import (
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
    euclidean: IntervalResult
    fermat: IntervalResult
    kde: IntervalResult


@dataclass
class Results:
    intervals: Intervals
    powers: pd.DataFrame


def run_all_intervals(
    X,
    h: float = 0.3,
    B: int = 300,
    grid_n: int = 100,
    plot: bool = True,
) -> Intervals:
    print("Starting run...")
    result_euclid = hausd_interval(X, B=B)
    print("Finished running euclidean")
    result_kde = bootstrap_function_interval(
        X, B=B, value_function=partial(kde_grid, h=h), grid_n=grid_n
    )
    print("Finished running KDE")
    fermat_matrix = fermat_dist(X, alpha=2)
    print("Computed fermat distance matrix")
    result_fermat = hausd_interval(fermat_matrix, B=B, pairwise_dist=True)
    print("Finished running Fermat")
    if plot:
        fig, axs = plt.subplots(nrows=2, ncols=2, figsize=(14, 10))
        plot_dataset(X, ax=axs[0, 0])
        plot_result(result_euclid, ax=axs[0, 1], title="Euclideo")
        plot_result(result_fermat, ax=axs[1, 0], title="Fermat")
        plot_result(result_kde, ax=axs[1, 1], title="Densidad")
        fig.show()
    return Intervals(euclidean=result_euclid, fermat=result_fermat, kde=result_kde)


def run_all(
    dataset_factory: Callable,
    h: float = 0.3,
    B_power: int = 30,
    B_interval: int = 300,
    grid_n: int = 100,
    ncores: int = 3,
    log: bool = True,
    cache_key: str | None = None,
) -> Results:
    func_name = get_func_name(dataset_factory)
    cache_prefix = cache_key or f"{func_name}_{h}_{B_power}_{B_interval}_{grid_n}"
    cache = dc.Cache(CACHE_NAME)

    if log:
        print("Starting computing intervals")
        print("Intervals found in cache: ", "intervals" in cache)
    X = dataset_factory()

    intervals_key = f"{cache_prefix}_intervals"
    if intervals_key not in cache:
        intervals = run_all_intervals(X, h=h, B=B_interval, grid_n=grid_n)
        cache[intervals_key] = intervals
    intervals: Intervals = cache[intervals_key]  # type: ignore

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
    power_results.index = power_results.index.get_level_values(0)
    power_results.set_index(keys="Agujeros", append=True, inplace=True)
    power_results = power_results.reindex(
        pd.MultiIndex.from_product([power_results.index.levels[0], power_results.index.levels[1]]),
        fill_value=0,
    )
    cache.close()
    return Results(intervals=intervals, powers=power_results)
