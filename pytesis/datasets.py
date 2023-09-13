import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.stats import truncnorm
from scipy.special import ellipe
import seaborn as sns


plt.style.use("seaborn")


def ggplot_dataset(X, title="Conjunto de datos"):
    df = pd.DataFrame(X, columns=["x", "y"])
    plt.figure()
    sns.kdeplot(data=df, x="x", y="y", fill=True, cut=1, cmap="PuBu", bw_method=0.3)
    plt.scatter(x=df["x"], y=df["y"], alpha=0.5)
    plt.title(title)
    plt.xlabel("x")
    plt.ylabel("y")
    plt.show()


def eyeglasses(center=(0, 0), r=1, separation=3, n=500, bridge_height=0.2, exclude_theta=None):
    exclude_theta = exclude_theta or np.arcsin(bridge_height / r)
    effective_angle = np.pi - exclude_theta

    c_x1 = center[0] - separation / 2
    c_x2 = center[0] + separation / 2
    c_y = center[1]

    tunnel_offset = r * np.cos(exclude_theta)
    tunnel_diameter = separation - 2 * tunnel_offset

    # tunnel_length = 2 * np.pi / 2 * np.sqrt(tunnel_diameter**2 + bridge_height**2) / 2
    # tunnel_length = 2 * np.pi / 2 * np.sqrt(tunnel_diameter**2 + bridge_height**2) / 4
    a_ellipse = max(bridge_height / 2, tunnel_diameter / 2)
    b_ellipse = min(bridge_height / 2, tunnel_diameter / 2)
    e_ellipse = 1.0 - b_ellipse**2/a_ellipse**2
    # circumference formula
    tunnel_length = 4 * a_ellipse * ellipe(e_ellipse) / 2

    arc_length = 2 * effective_angle * r
    total_length = 2 * arc_length + 2 * tunnel_length

    n_tunnel = round(tunnel_length / total_length * n)
    n_arc = round(arc_length / total_length * n)
    n_reminder = n - 2 * n_tunnel - 2 * n_arc

    circle1 = arc(center=(c_x1, c_y), r=r, n=n_arc + n_reminder, max_abs_angle=effective_angle, angle_shift=np.pi)
    circle2 = arc(center=(c_x2, c_y), r=r, n=n_arc, max_abs_angle=effective_angle)

    tunnel_c_x = c_x1 + tunnel_offset + tunnel_diameter / 2
    top_tunnel = arc(center=(tunnel_c_x, c_y + bridge_height), r=(tunnel_diameter / 2, bridge_height / 2),
                     n=n_tunnel, max_abs_angle=np.pi / 2, angle_shift=np.pi / 2)
    bottom_tunnel = arc(center=(tunnel_c_x, c_y - bridge_height), r=(tunnel_diameter / 2, bridge_height / 2),
                        n=n_tunnel, max_abs_angle=np.pi / 2, angle_shift=-np.pi / 2)

    return np.vstack((circle1, circle2, top_tunnel, bottom_tunnel))


def arc(center=(0, 0), r=1, n=500, sampling="uniform", max_abs_angle=np.pi, angle_shift=0):
    if sampling == "uniform":
        theta = np.random.uniform(-max_abs_angle, max_abs_angle, n)
    elif sampling == "normal":
        angle_sd = max_abs_angle / 1.50
        theta = truncnorm.rvs(-max_abs_angle, max_abs_angle, loc=0, scale=angle_sd, size=n)
    else:
        raise ValueError("Sampling should be either 'uniform' or 'normal'")
    r = [r] if not hasattr(r, "__getitem__") else r
    x = center[0] + r[0] * np.cos(theta - angle_shift)
    y = center[1] + r[len(r) - 1] * np.sin(theta - angle_shift)
    return np.column_stack((x, y))


def filled_circle(center=(0, 0), max_r=1, r_power=4, n=500):
    theta = np.random.uniform(-np.pi, np.pi, n)
    r = np.random.uniform(0, 1, n) ** (1 / r_power) * max_r
    x = center[0] + r * np.cos(theta)
    y = center[1] + r * np.sin(theta)
    return np.column_stack((x, y))


def add_noise(X, sd=1):
    n, d = X.shape
    noise = np.random.normal(0, sd, (n, d))
    return X + noise


def add_outliers(X, frac=0.05, iqr_factor=1.5):
    n, d = X.shape
    amount = int(round(frac * n))
    qs = np.percentile(X, [25, 75], axis=0)
    iqr = qs[1] - qs[0]
    iqr_sign = np.random.choice([-1, 1], amount)
    ixs = np.random.choice(n, amount, replace=True)
    X[ixs, :] = X[ixs, :] + iqr_factor * iqr_sign[:, np.newaxis] * np.tile(iqr, (amount, 1))
    return X


def add_dummy_dimensions(X, d=1):
    n, _ = X.shape
    new_columns = np.random.normal(0, 1, (n, d))
    return np.hstack((X, new_columns))

# # Example usage
# X = eyeglasses(center=(0, 0), r=1, separation=3, n=2000, bridge_height=0.2)
# X = add_noise(X, sd=0.05)
# X = add_outliers(X, frac=0.05, iqr_factor=1.5)
# X = add_dummy_dimensions(X, d=1)
# ggplot_dataset(X)
