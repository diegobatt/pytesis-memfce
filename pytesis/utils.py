
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import gudhi as gd

from pytesis.intervals import IntervalResult


def plot_dataset(X, title="Conjunto de datos"):
    df = pd.DataFrame(X, columns=["x", "y"])
    plt.figure()
    sns.kdeplot(data=df, x="x", y="y", fill=True, cut=1, cmap="Blues")
    plt.scatter(x=df["x"], y=df["y"], alpha=0.5)
    plt.title(title)
    plt.xlabel("x")
    plt.ylabel("y")
    plt.show()


def plot_result(result: IntervalResult, title="Diagrama de Persistencia"):
    plt.figure()
    ax = gd.plot_persistence_diagram(result.dgm)
    max_lim = max(ax.get_xlim()[1], ax.get_ylim()[1])
    min_lim = min(ax.get_xlim()[0], ax.get_ylim()[0])
    base_line = np.array([min_lim, max_lim])
    plt.plot(base_line, base_line + result.band)
    plt.fill_between(
        x=base_line,
        y1=base_line,
        y2=base_line + result.band,
        alpha=0.3
    )
    plt.xlabel("Nacimiento")
    plt.ylabel("Muerte")
    plt.title(title)
    plt.show()
