from functools import partial, reduce
from typing import Callable, Iterable

import numpy as np
from sklearn.neighbors import KernelDensity, NearestNeighbors


def gaussian_kernel(X):
    return 1 / np.sqrt(2 * np.pi) * np.exp(-(X**2) / 2)


def kde_grid(X, positions, h: float = 0.3):
    kde = KernelDensity(kernel="gaussian", bandwidth=h).fit(X)
    score = -np.exp(kde.score_samples(positions))
    return score


def _compose_call(f: Callable, g: Callable):
    return f(g())


def _compose_two(f: Callable, g: Callable):
    f_name = getattr(f, "__name__", f.func.__name__)
    g_name = getattr(g, "__name__", g.func.__name__)
    return_f = partial(_compose_call, f, g)
    return_f.func.__name__ = f"{f_name}({g_name})"
    return return_f


def compose(*functions: Callable) -> Callable:
    return reduce(_compose_two, functions)
