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
    return partial(_compose_call, f, g)


def compose(*functions: Callable) -> Callable:
    return reduce(_compose_two, functions)


# def compose(*functions: Callable) -> Callable:
#     def compose2(f: Callable, g: Callable):
#         def compose_():
#             return f(g())
#         return compose_
#     return reduce(compose2, functions)
