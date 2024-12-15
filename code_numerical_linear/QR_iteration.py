# This is a simple script to realize QR iteration for solving eigenvalue problem
# The algotihm consists of computing the QR decomposition of the matrix A, 
# and then multiply RQ to get a new matrix A


import numpy as np
import QR_factor as myfun

def givens_set(a, b):
    if b == 0:
        return 1, 0
    c = a / np.sqrt(a**2 + b**2)
    s = -b / np.sqrt(a**2 + b**2)
    return c, s

def givens_rotation(A, row, col, c, s): 
    A[row:row+2, col:] = np.array([[c, -s], [s, c]]) @ A[row:row+2, col:]

def conj_givens_rotation(A, row, col, c, s): 
    A[:row+2, col:col+2] = A[:row+2, col:col+2] @ np.array([[c, s], [-s, c]])


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

def qr_hessenberg(A, tol=1e-6, max_iter=1000):
    n = A.shape[0]
    c_store = np.zeros(n-1)
    s_store = np.zeros(n-1)
    for j in range(max_iter):
        # Hessenberg form to diagonal form by multiplying givens from left
        for i in range(n-1):
            c_store[i], s_store[i] = givens_set(A[i, i], A[i+1, i])
            givens_rotation(A, i, i, c_store[i], s_store[i])
        # return to Hessenberg form by multiplying conjugate givens from right
        for i in range(n-1):
            conj_givens_rotation(A, i, i, c_store[i], s_store[i])
    return np.diag(A)

if __name__ == '__main__':
    # Generate a random 5x5 Hessenberg matrix
    np.random.seed(0)
    H = np.random.rand(5, 5)
    for i in range(2, 5):
        for j in range(i-1):
            H[i, j] = 0

    print("Original Hessenberg matrix H:")
    print(H)

    # Test the qr_hessenberg function
    eigenvalues = qr_hessenberg(H)
    print("Eigenvalues of H:")
    print(eigenvalues)
