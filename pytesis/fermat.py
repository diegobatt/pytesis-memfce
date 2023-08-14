import numpy as np
import pandas as pd
from sklearn.metrics import pairwise_distances
import networkx as nx


class FermatDistance:
    def __init__(self, sp, method):
        self.sp = sp
        self.method = method


def fermat_dist(X, method="full", alpha=2, landmarks_frac=0.1):
    available_methods = ["full", "knn", "landmarks"]
    if method not in available_methods:
        raise ValueError("Method is not available")

    n = X.shape[0]
    dist_matrix = pairwise_distances(X, metric="euclidean", squared=True) ** alpha

    if method == "knn":
        k = int(np.sqrt(n))
        for i in range(n):
            col_dists = dist_matrix[:, i]
            min_k_dist = np.partition(col_dists, k + 1)[k]
            remove_nodes = col_dists >= min_k_dist
            dist_matrix[remove_nodes, i] = 0

    g = nx.from_numpy_array(dist_matrix, create_using=nx.Graph)

    if method == "landmarks":
        landmarks_ids = np.random.choice(n, size=int(n * landmarks_frac), replace=False)
        landmarks_sp = dict(nx.single_source_dijkstra_path_length(g, source=None, cutoff=None, weight='weight'))
        sp = np.zeros((n, n))

        for i in range(n):
            for j in range(n):
                min_path = float("inf")
                for landmark in landmarks_ids:
                    path_length = landmarks_sp[landmark][i] + landmarks_sp[landmark][j]
                    if path_length < min_path:
                        min_path = path_length
                sp[i, j] = min_path

    else:
        sp = dict(nx.all_pairs_dijkstra_path_length(g, weight='weight'))
        sp = pd.DataFrame(sp)
        sp = sp.sort_index(axis=0).sort_index(axis=1).to_numpy()

    return FermatDistance(sp=sp, method=method)

# Example usage

