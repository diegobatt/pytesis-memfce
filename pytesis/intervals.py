import logging
import multiprocessing as mp
from dataclasses import dataclass
from functools import partial
from multiprocessing import Pool
from typing import Callable, Optional

import gudhi as gd
import numpy as np

from pytesis.tda import (
    BirthDeaths,
    Dgm,
    Xtype,
    build_distance_diagram,
    build_function_diagram,
    get_birth_death,
    hausd_distance,
    make_grid,
)

# logging.basicConfig(level=logging.INFO)
LOGGER = logging.getLogger("intervals")
DEFAULT_CORES = mp.cpu_count()


@dataclass
class IntervalResult:
    dgm: Dgm
    distances: list[np.float64]
    width: np.float64

    @property
    def band(self):
        return np.sqrt(2) * self.width


def plot_result(
    result: IntervalResult,
    title="Diagrama de Persistencia",
    ax=None,
    degrees: Optional[list[int]] = None,
):
    dgm = result.dgm
    if degrees is not None:
        dgm = [(p, (b, d)) for p, (b, d) in dgm if p in degrees]
    ax = gd.plot_persistence_diagram(dgm, axes=ax)
    max_lim = max(ax.get_xlim()[1], ax.get_ylim()[1])
    min_lim = min(ax.get_xlim()[0], ax.get_ylim()[0])
    base_line = np.array([min_lim, max_lim])
    ax.plot(base_line, base_line + result.band)
    ax.fill_between(x=base_line, y1=base_line, y2=base_line + result.band, alpha=0.3)
    ax.set_xlabel("Nacimiento")
    ax.set_ylabel("Muerte")
    ax.set_title(title)
    return ax


def _parallel_hausd_distance(X, m, pairwise_dist, ix, robust_quantile: float | None = None):
    LOGGER.info("Iteration: %s", ix)
    return hausd_distance(X, m, pairwise_dist, robust_quantile=robust_quantile)


def hausd_interval(
    X,
    alpha=0.05,
    m=None,
    B=1000,
    pairwise_dist=False,
    robust_quantile: float | None = None,
    ncores=None,
) -> IntervalResult:
    n = np.size(X, 0)
    m = m or int(n / np.log(n))

    parallel_distance = partial(
        _parallel_hausd_distance, X, m, pairwise_dist, robust_quantile=robust_quantile
    )
    with Pool(ncores or 1) as p:
        dist_vec = p.map(parallel_distance, np.arange(B))
    p.close()

    dgm = build_distance_diagram(X, pairwise_dist=pairwise_dist)
    width = 2 * np.quantile(dist_vec, 1 - alpha)

    return IntervalResult(width=width, dgm=dgm, distances=dist_vec)


def _parallel_distance_dgm(
    X: Xtype, base_dgm: BirthDeaths, n: int, dist_function: Callable | None, ix
):
    LOGGER.info("Iteration: %s", ix)
    idxs = np.random.choice(n, n)
    bootstrap_X = X[idxs, :]
    bootstrap_dgm = build_distance_diagram(bootstrap_X, dist_function)
    return gd.bottleneck_distance(base_dgm, get_birth_death(bootstrap_dgm))


def bootstrap_distance_interval(
    X, alpha=0.05, dist_function=None, B=100, ncores=DEFAULT_CORES
) -> IntervalResult:
    n = np.size(X, 0)
    dgm = build_distance_diagram(X, dist_function)
    dgm_birth_deaths = get_birth_death(dgm)
    parallel_distance = partial(_parallel_distance_dgm, X, dgm_birth_deaths, n, dist_function)
    LOGGER.info("Finished pre-processing!")
    with Pool(ncores or 1) as p:
        dist_vec = p.map(parallel_distance, np.arange(B))
    p.close()

    width = np.quantile(dist_vec, 1 - alpha)
    return IntervalResult(width=width, dgm=dgm, distances=dist_vec)


def _parallel_function_dgm(
    X: Xtype,
    base_dgm: BirthDeaths,
    n: int,
    value_function: Callable,
    positions: np.ndarray,
    dimensions: tuple[int, ...],
    ix,
):
    LOGGER.info("Iteration: %s", ix)
    idxs = np.random.choice(n, n)
    bootstrap_X = X[idxs, :]
    bootstrap_dgm = build_function_diagram(
        bootstrap_X, value_function, dimensions=dimensions, positions=positions
    )
    return gd.bottleneck_distance(base_dgm, get_birth_death(bootstrap_dgm))


def bootstrap_function_interval(
    X,
    value_function: Callable,
    alpha=0.05,
    B=100,
    ncores=DEFAULT_CORES,
    grid_n=100,
) -> IntervalResult:
    n = np.size(X, 0)
    dimensions, positions = make_grid(X, grid_n)
    dgm = build_function_diagram(
        X, value_function, dimensions=dimensions, positions=positions, grid_n=grid_n
    )
    dgm_birth_deaths = get_birth_death(dgm)
    parallel_distance = partial(
        _parallel_function_dgm, X, dgm_birth_deaths, n, value_function, positions, dimensions
    )

    LOGGER.info("Finished pre-processing!")
    with Pool(ncores or 1) as p:
        dist_vec = p.map(parallel_distance, np.arange(B))
    p.close()
    width = np.quantile(dist_vec, 1 - alpha)
    return IntervalResult(width=width, dgm=dgm, distances=dist_vec)
