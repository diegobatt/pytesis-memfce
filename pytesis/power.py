import logging
import multiprocessing as mp
from dataclasses import dataclass
from functools import partial
from multiprocessing import Pool
from typing import Callable, Optional

import numpy as np
import pandas as pd
from numpy.typing import ArrayLike, NDArray

from pytesis.tda import build_distance_diagram, build_function_diagram

# logging.basicConfig(level=logging.INFO)
LOGGER = logging.getLogger("power")
DEFAULT_CORES = mp.cpu_count()


@dataclass
class PowerResult:
    significant_holes: ArrayLike

    @property
    def table(self) -> pd.DataFrame:
        holes_df = pd.DataFrame(self.significant_holes, columns=["holes"])
        # pivots the significant holes table into the percentage of times each hole was significant
        return (
            holes_df.pivot_table(index="holes", aggfunc="size", fill_value=0)
            .reset_index(name="counts")
            .assign(percentage=lambda df: df.counts / df.counts.sum())
        )


def _parallel_compute_dgm_power(
    dgm_factory: Callable,
    dataset_factory: Callable,
    band: float,
    ix: int,
) -> int:
    LOGGER.info("Iteration: %s", ix)
    X = dataset_factory()
    dgm = dgm_factory(X)
    holes_birth_deaths = np.array([x[1] for x in dgm if x[0] == 1])
    significant_holes = np.sum(np.abs(holes_birth_deaths[:, 1] - holes_birth_deaths[:, 0]) > band)
    return int(significant_holes)


def compute_dgm_power(
    dgm_factory: Callable,
    dataset_factory: Callable,
    band: float,
    B: int = 100,
    ncores: Optional[int] = None,
    **dgm_kwargs
) -> PowerResult:
    dgm_factory = partial(dgm_factory, **dgm_kwargs)
    parallel_compute_dgm_power = partial(
        _parallel_compute_dgm_power, dgm_factory, dataset_factory, band
    )
    with Pool(ncores or 1) as p:
        significant_holes = p.map(parallel_compute_dgm_power, np.arange(B))
    return PowerResult(significant_holes=significant_holes)


def distance_power(
    dataset_factory: Callable,
    band: float,
    dist_function: Optional[Callable] = None,
    B: int = 100,
    ncores: Optional[int] = None,
) -> PowerResult:
    return compute_dgm_power(
        build_distance_diagram,
        dataset_factory,
        band,
        B,
        dist_function=dist_function,
        ncores=ncores,
    )


def function_power(
    dataset_factory: Callable,
    band: float,
    value_function: Callable,
    positions: NDArray[np.float64],
    dimensions: tuple[int, int],
    B: int = 100,
    ncores: Optional[int] = None,
) -> PowerResult:
    return compute_dgm_power(
        build_function_diagram,
        dataset_factory,
        band,
        B,
        value_function=value_function,
        positions=positions,
        dimensions=dimensions,
        ncores=ncores,
    )
