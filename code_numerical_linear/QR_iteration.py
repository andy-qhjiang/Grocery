# This is a simple script to realize QR iteration for solving eigenvalue problem
# The algotihm consists of computing the QR decomposition of the matrix A, 
# and then multiply RQ to get a new matrix A


import numpy as np
import time
from scipy.linalg import hessenberg
from scipy.linalg import qr

def givens_setup(a, b):
    if b == 0:
        return 1, 0
    c = a / np.sqrt(a**2 + b**2)
    s = -b / np.sqrt(a**2 + b**2)
    return c, s

def givens_rotation(A, row, col, c, s): 
    A[row:row+2, col:] = np.array([[c, -s], [s, c]]) @ A[row:row+2, col:]

def conj_givens_rotation(A, row, col, c, s): 
    A[:row+2, col:col+2] = A[:row+2, col:col+2] @ np.array([[c, s], [-s, c]])


def qr_basic(A, tol=1e-8, max_iter=1000):
    n = A.shape[0]
    V = np.eye(n)
    for i in range(max_iter):
        Q, R = qr(A)
        A = R @ Q
        # V = V @ Q
        if np.linalg.norm(np.tril(A, -1)) < tol:
            break
    return np.diag(A), V

def qr_hessenberg(A, tol=1e-8, max_iter=1000):
    A = hessenberg(A)
    n = A.shape[0]
    c_store = np.zeros(n-1)
    s_store = np.zeros(n-1)
    for j in range(max_iter):
        # Hessenberg form to diagonal form by multiplying givens from left
        for i in range(n-1):
            c_store[i], s_store[i] = givens_setup(A[i, i], A[i+1, i])
            givens_rotation(A, i, i, c_store[i], s_store[i])
        # return to Hessenberg form by multiplying conjugate givens from right
        for i in range(n-1):
            conj_givens_rotation(A, i, i, c_store[i], s_store[i])
        if np.linalg.norm(np.tril(A, -1)) < tol:
            break
    return np.diag(A)

# QR iteration with deflation and shift based on qr_hessenberg above
def qr_deflation(A, tol=1e-8, max_iter=1000):
    n = A.shape[0]
    V = np.eye(n)
    for i in range(max_iter):
        Q, R = np.linalg.qr(A)
        A = R @ Q
        V = V @ Q
        if np.linalg.norm(np.tril(A, -1)) < tol:
            break
    return np.diag(A), V


if __name__ == '__main__':
    # Generate a random 5x5 Hessenberg matrix
    A = np.random.rand(200, 200)

    # Measure time for qr_basic
    start_time = time.time()
    eigenvalues_basic, eigenvectors_basic = qr_basic(A.copy())
    time_basic = time.time() - start_time

    # Measure time for qr_hessenberg
    start_time = time.time()
    eigenvalues_hessenberg = qr_hessenberg(A.copy())
    time_hessenberg = time.time() - start_time

    print(f"Time taken by qr_basic: {time_basic:.4f} seconds")
    print(f"Time taken by qr_hessenberg: {time_hessenberg:.4f} seconds")
