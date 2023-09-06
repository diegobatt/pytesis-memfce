
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import gudhi as gd

from pytesis.intervals import IntervalResult


def plot_dataset(X, title="Conjunto de datos", ax=None):
    df = pd.DataFrame(X, columns=["x", "y"])
    if ax is None:
        ax = plt.gca()
    sns.kdeplot(data=df, x="x", y="y", fill=True, cut=1, cmap="Blues", ax=ax)
    ax.scatter(x=df["x"], y=df["y"], alpha=0.5)
    ax.set_title(title)
    ax.set_xlabel("x")
    ax.set_ylabel("y")
    return ax


def plot_result(result: IntervalResult, title="Diagrama de Persistencia", ax=None):
    ax = gd.plot_persistence_diagram(result.dgm, axes=ax)
    max_lim = max(ax.get_xlim()[1], ax.get_ylim()[1])
    min_lim = min(ax.get_xlim()[0], ax.get_ylim()[0])
    base_line = np.array([min_lim, max_lim])
    ax.plot(base_line, base_line + result.band)
    ax.fill_between(
        x=base_line,
        y1=base_line,
        y2=base_line + result.band,
        alpha=0.3
    )
    ax.set_xlabel("Nacimiento")
    ax.set_ylabel("Muerte")
    ax.set_title(title)
    return ax
