    
import numpy as np
from multiprocessing import Pool
from sklearn.neighbors import KDTree
from functools import partial
import gudhi as gd
from sklearn.neighbors import KernelDensity


def hausd_distance(X, m, pairwise_dist, *args):
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


def hausd_interval(
    X,
    alpha=0.05,
    m=None,
    B=1000,
    pairwise_dist=False,
    ncores=None
):
    n = np.size(X, 0)
    m = m or int(n / np.log(n))

    parallel_distance = partial(hausd_distance, X, m, pairwise_dist)
    with Pool(ncores) as p:
        dist_vec = p.map(parallel_distance, ["identifier_map"]*B)
    p.close()

    return 2 * np.quantile(dist_vec, 1 - alpha)


def bootstrap_distance_interval(
    X,
    alpha=0.05,
    dist_function=None,
    B=100,
    ncores=None
):
    n = np.size(X, 0)
    if dist_function:
        complex_kwargs = {"distance_matrix": dist_function(X)}
    else:
        complex_kwargs = {"points": X}
    dgm = gd.RipsComplex(**complex_kwargs).create_simplex_tree(max_dimension=2).persistence()

    def parallel_distance(dist_function):
        idxs = np.random.choice(n, n)
        bootstrap_X = X[idxs, :]
        if dist_function:
            complex_kwargs = {"distance_matrix": dist_function(bootstrap_X)}
        else:
            complex_kwargs = {"points": bootstrap_X}
        bootstrap_dgm = gd.RipsComplex(
            **complex_kwargs
        ).create_simplex_tree(max_dimension=2).persistence()
        return gd.bottleneck_distance(dgm, bootstrap_dgm)

    with Pool(ncores) as p:
        dist_vec = p.map(parallel_distance, ["identifier_map"]*B)
    p.close()

    return np.quantile(dist_vec, 1 - alpha)


def bootstrap_function_interval(
    X,
    alpha=0.05,
    B=100,
    value_function=None,
    **value_function_params,
):
    
    