# This is a file to realize Arnoldi iteration for a given matrix A and a given vector b
# Assume iter_num is m
# The output is a matrix V and a matrix H

import numpy as np
import numpy.linalg as la


def Arnoldi_iter(A, b, m):
    n = np.size(b)
    V = np.zeros((n, m+1))
    H = np.zeros((m+1, m))
    V[:, 0] = b / la.norm(b)
    for j in range(m):
        w = np.dot(A, V[:, j])
        for i in range(j+1):
            H[i, j] = np.dot(V[:, i], w)
            w = w - H[i, j] * V[:, i]
        H[j+1, j] = la.norm(w)
        if H[j+1, j] == 0:
            break
        V[:, j+1] = w / H[j+1, j]
    return V, H