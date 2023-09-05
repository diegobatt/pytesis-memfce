import logging
import multiprocessing as mp
from dataclasses import dataclass
from functools import partial
from multiprocessing import Pool
from typing import Callable

import gudhi as gd
import numpy as np
from numpy.typing import NDArray
from sklearn.neighbors import KDTree, KernelDensity

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("intervals")


DEFAULT_CORES = mp.cpu_count()


BirthDeaths = list[tuple[float, float]]
Dgm = list[tuple[int, tuple[float, float]]]
Xtype = NDArray[np.float64]


@dataclass
class IntervalResult:
    dgm: Dgm
    width: float

    @property
    def band(self):
        return np.sqrt(2) * self.width


def get_birth_death(dgm: Dgm) -> BirthDeaths:
    return np.array([x[1] for x in dgm])


def kde_value_f(X, positions, h=0.3):
    kde = KernelDensity(kernel="gaussian", bandwidth=h).fit(X)
    return -kde.score_samples(X=positions)


def hausd_distance(X, m, pairwise_dist):
    n = np.size(X, 0)
    m = m or int(4 * n / np.log(n))
    idxs = np.random.choice(n, m)
    idxs_complement = [item for item in np.arange(n) if item not in idxs]
    if pairwise_dist:
        return np.max([np.min(X[idxs, j]) for j in idxs_complement])
    tree = KDTree(X[idxs, ], leaf_size=2)
    dist, _ = tree.query(X[idxs_complement, ], k=1)
    hdist = max(dist)
    return hdist[0]


def _parallel_hausd_distance(X, m, pairwise_dist, ix):
    logger.info("Iteration: %s", ix)
    return hausd_distance(X, m, pairwise_dist)


def hausd_interval(
    X, alpha=0.05, m=None, B=1000, pairwise_dist=False, ncores=None
) -> IntervalResult:
    n = np.size(X, 0)
    m = m or int(n / np.log(n))

    parallel_distance = partial(_parallel_hausd_distance, X, m, pairwise_dist)
    with Pool(ncores or 1) as p:
        dist_vec = p.map(parallel_distance, np.arange(B))
    p.close()

    rips_complex = gd.RipsComplex(distance_matrix=X) if pairwise_dist else gd.RipsComplex(points=X)
    dgm = rips_complex.create_simplex_tree(max_dimension=2).persistence()
    width = 2 * np.quantile(dist_vec, 1 - alpha)

    return IntervalResult(width=width, dgm=dgm)


def _parallel_dgm_distance(
    X: Xtype, base_dgm: BirthDeaths, n: int, dist_function: Callable | None, ix
):
    logger.info("Iteration: %s", ix)
    idxs = np.random.choice(n, n)
    bootstrap_X = X[idxs, :]
    if dist_function:
        complex_kwargs = {"distance_matrix": dist_function(bootstrap_X)}
    else:
        complex_kwargs = {"points": bootstrap_X}
    bootstrap_dgm = (
        gd.RipsComplex(**complex_kwargs).create_simplex_tree(max_dimension=2).persistence()
    )
    return gd.bottleneck_distance(base_dgm, get_birth_death(bootstrap_dgm))


def bootstrap_distance_interval(
    X, alpha=0.05, dist_function=None, B=100, ncores=DEFAULT_CORES
) -> IntervalResult:
    n = np.size(X, 0)
    if dist_function:
        complex_kwargs = {"distance_matrix": dist_function(X)}
    else:
        complex_kwargs = {"points": X}
    dgm = gd.RipsComplex(**complex_kwargs).create_simplex_tree(max_dimension=2).persistence()
    dgm_birth_deaths = get_birth_death(dgm)
    parallel_distance = partial(_parallel_dgm_distance, X, dgm_birth_deaths, n, dist_function)
    logger.info("Finished pre-processing!")
    with Pool(ncores or 1) as p:
        dist_vec = p.map(parallel_distance, np.arange(B))
    p.close()

    width = np.quantile(dist_vec, 1 - alpha)
    return IntervalResult(width=width, dgm=dgm)


def _parallel_function_dgm_distance(
    X: Xtype,
    base_dgm: BirthDeaths,
    n: int,
    value_function: Callable,
    positions: np.ndarray,
    nx: int,
    ny: int,
    ix,
):
    logger.info("Iteration: %s", ix)
    idxs = np.random.choice(n, n)
    bootstrap_X = X[idxs, :]
    bootstrap_f_values = value_function(bootstrap_X, positions)
    bootstrap_dgm = gd.CubicalComplex(
        dimensions=[nx, ny], top_dimensional_cells=bootstrap_f_values
    ).persistence()
    return gd.bottleneck_distance(base_dgm, get_birth_death(bootstrap_dgm))


def bootstrap_function_interval(
    X,
    alpha=0.05,
    B=100,
    ncores=DEFAULT_CORES,
    value_function=None,
    grid_n=100,
) -> IntervalResult:
    n = np.size(X, 0)
    col_mins = np.min(X, axis=0)
    col_maxs = np.max(X, axis=0)
    col_mins *= (1 - 2 * 0.3 * np.sign(col_mins))
    col_maxs *= (1 + 2 * 0.3 * np.sign(col_maxs))
    step = np.max(col_maxs - col_mins) / grid_n
    xval = np.arange(col_mins[0], col_maxs[0], step)
    yval = np.arange(col_mins[1], col_maxs[1], step)
    nx = len(xval)
    ny = len(yval)
    positions = np.array([[u, v] for u in xval for v in yval])
    f_values = value_function(X, positions)
    dgm = gd.CubicalComplex(dimensions=[nx, ny], top_dimensional_cells=f_values).persistence()
    dgm_birth_deaths = get_birth_death(dgm)
    parallel_distance = partial(
        _parallel_function_dgm_distance, X, dgm_birth_deaths, n, value_function, positions, nx, ny
    )

    logger.info("Finished pre-processing!")
    with Pool(ncores or 1) as p:
        dist_vec = p.map(parallel_distance, np.arange(B))
    p.close()
    width = np.quantile(dist_vec, 1 - alpha)
    return IntervalResult(width=width, dgm=dgm)
