from functools import partial
from typing import Callable, TypeAlias

import gudhi as gd
import numpy as np
from numpy.typing import NDArray
from sklearn.neighbors import KDTree

BirthDeaths = list[tuple[float, float]]
Dgm = list[tuple[int, tuple[float, float]]]
Xtype: TypeAlias = NDArray[np.float64]


def get_birth_death(dgm: Dgm) -> BirthDeaths:
    return np.array([x[1] for x in dgm])


def hausd_distance(
    X: Xtype, m: int, pairwise_dist: bool, robust_quantile: float | None = None
) -> np.float64:
    n = np.size(X, 0)
    m = m or int(4 * n / np.log(n))
    max_func: Callable = np.max
    if robust_quantile is not None:
        max_func = partial(np.quantile, q=robust_quantile, method="closest_observation")
    idxs = np.random.choice(n, m, replace=False)
    idxs_complement = [item for item in np.arange(n) if item not in idxs]
    if pairwise_dist:
        return max_func([np.min(X[idxs, j]) for j in idxs_complement])
    tree = KDTree(X[idxs], leaf_size=2)
    dist, _ = tree.query(X[idxs_complement], k=1)
    hdist = max_func(np.squeeze(dist))
    return hdist


def make_grid(X: Xtype, grid_n: int) -> tuple[tuple[int, ...], Xtype]:
    d = X.shape[1]
    col_mins = np.min(X, axis=0)
    col_maxs = np.max(X, axis=0)
    col_mins *= 1 - 2 * 0.3 * np.sign(col_mins)
    col_maxs *= 1 + 2 * 0.3 * np.sign(col_maxs)
    dim_vals = np.empty(shape=(d, grid_n))
    for i in range(d):
        dim_vals[i] = np.linspace(col_mins[i], col_maxs[i], num=grid_n)
    # xval = np.linspace(col_mins[0], col_maxs[0], num=grid_n)
    # yval = np.linspace(col_mins[1], col_maxs[1], num=grid_n)
    positions = np.array(np.meshgrid(*dim_vals)).T.reshape(-1, d)
    # positions = np.array([[u, v] for u in xval for v in yval])
    dimensions = tuple(len(dim_vals[i]) for i in range(d))
    # nx = len(xval)
    # ny = len(yval)
    # dimensions = (nx, ny)
    return dimensions, positions


def build_distance_diagram(
    X: Xtype, dist_function: Callable | None = None, pairwise_dist: bool = False
) -> Dgm:
    assert not (pairwise_dist and (dist_function is not None))
    if pairwise_dist:
        complex_kwargs = {"distance_matrix": X}
    elif dist_function:
        complex_kwargs = {"distance_matrix": dist_function(X)}
    else:
        complex_kwargs = {"points": X}
    return gd.RipsComplex(**complex_kwargs).create_simplex_tree(max_dimension=2).persistence()


def build_function_diagram(
    X: Xtype,
    value_function: Callable,
    dimensions: tuple[int, ...] | None = None,
    positions: Xtype | None = None,
    grid_n: int = 100,
) -> Dgm:
    assert not ((dimensions is None) ^ (positions is None))
    if positions is None:
        assert grid_n is not None
        dimensions, positions = make_grid(X, grid_n)
    f_values = value_function(X, positions)
    return gd.CubicalComplex(dimensions=dimensions, top_dimensional_cells=f_values).persistence()
