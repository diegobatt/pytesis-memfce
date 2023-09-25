import numpy as np
from sklearn.neighbors import KernelDensity
from numpy.typing import NDArray

BirthDeaths = list[tuple[float, float]]
Dgm = list[tuple[int, tuple[float, float]]]


def get_birth_death(dgm: Dgm) -> BirthDeaths:
    return np.array([x[1] for x in dgm])


def kde_grid(X, positions, h=0.3):
    kde = KernelDensity(kernel="gaussian", bandwidth=h).fit(X)
    score = -np.exp(kde.score_samples(positions))
    return score


