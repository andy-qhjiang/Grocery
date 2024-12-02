# This is a simple script to realize QR iteration for solving eigenvalue problem
# The algotihm consists of computing the QR decomposition of the matrix A, 
# and then multiply RQ to get a new matrix A


import numpy as np
import QR_factor as myfun

def QR_iter_basic(A, tol=1e-6, max_iter=1000):
    n = A.shape[0]
    V = np.eye(n)
    for i in range(max_iter):
        Q, R = myfun.QR(A)
        A = R @ Q
        V = V @ Q
        if np.linalg.norm(np.tril(A, -1)) < tol:
            break
    return np.diag(A), V


if __name__ == '__main__':
    A = np.array([[1, 2, 3], [2, 3, 4], [3, 4, 5]], dtype=float)
    eigvals, eigvecs = QR_iteration(A)
    print('Eigenvalues:', eigvals)
    print('Eigenvectors:', eigvecs)
    print('Check:', A @ eigvecs - eigvecs @ np.diag(eigvals))
