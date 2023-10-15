from typing import Callable

import numpy as np
from sklearn.neighbors import KernelDensity, NearestNeighbors


def gaussian_kernel(X):
    return 1 / np.sqrt(2 * np.pi) * np.exp(-(X**2) / 2)


def kde_grid(X, positions, h: float = 0.3):
    kde = KernelDensity(kernel="gaussian", bandwidth=h).fit(X)
    score = -np.exp(kde.score_samples(positions))
    return score


def kde_distance(X, distance_function: Callable, h: float = 0.3):
    nn = NearestNeighbors(n_neighbors=1, algorithm="ball_tree").fit(X)
    distances, indices = nn.kneighbors(X)
