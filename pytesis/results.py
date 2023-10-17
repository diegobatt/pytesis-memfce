from dataclasses import dataclass
from functools import partial
from typing import Callable

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
from pytesis.utils import kde_grid


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
) -> Results:
    print("Starting computing intervals")
    X = dataset_factory()
    intervals = run_all_intervals(X, h=h, B=B_interval, grid_n=grid_n)

    print("Starting power analysis")
    power_euclid = distance_power(
        dataset_factory,
        band=intervals.euclidean.band,
        dist_function=None,
        B=B_power,
        ncores=ncores,
    )
    print("Finished euclid power analysis")
    power_fermat = distance_power(
        dataset_factory,
        band=intervals.fermat.band,
        dist_function=fermat_dist,
        B=B_power,
        ncores=ncores,
    )
    print("Finished fermat power analysis")
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
    print("Finished kde power analysis")

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
    return Results(intervals=intervals, powers=power_results)
