# This is a simple script to realize QR iteration and all improvements mentioned in the lecture notes
# qr_basic, qr_hessenberg, qr_deflation are limited to self-adjoint matrices where there are only real eigenvalues


import numpy as np
import time
from scipy.linalg import hessenberg

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

def deflation(A, tol):
    alpha, beta = 0 , 0
    n = A.shape[0]
    for i in range(n-1):
        if abs(A[i+1, i]) < tol * (abs(A[i, i]) + abs(A[i+1, i+1])):
            A[i+1, i] = 0
            alpha = i+1 # We read subdiagonal elements in order of columns, A[i+1, i]=0 means block splits at (i+1)-th row
        else:
            break
    if alpha <= n-2:
        beta = alpha + 1
        while beta < n-1:
            if abs(A[beta+1, beta]) < tol * (abs(A[beta, beta]) + abs(A[beta+1, beta+1])):
                break
            beta += 1
    return alpha, beta

def wilkinson_shift(A):
    d = (A[1, 1] - A[0, 0]) / 2
    sign = np.sign(d) if d != 0 else 1
    mu = A[1, 1] - (A[1, 0]**2) / (abs(d) + np.sqrt(d**2 + A[1, 0]**2)) * sign
    return mu

def qr_basic(A, tol=1e-8, max_iter=1000):
    n = A.shape[0]
    V = np.eye(n)
    for i in range(max_iter):
        Q, R = np.linalg.qr(A)
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
    A = hessenberg(A)
    n = A.shape[0]
    V = np.eye(n)
    for i in range(max_iter): 
        alpha, beta = deflation(A, tol)
        if alpha == n-1: # if the matrix is already upper triangular
            break 
        # we deal with the block matrix A[alpha:beta+1, alpha:beta+1]
        blockSize = beta - alpha + 1
        c_store = np.zeros(blockSize-1)
        s_store = np.zeros(blockSize-1)
        mu = wilkinson_shift(A[beta-1:beta+1, beta-1:beta+1])
        for j in range(alpha, beta+1):
            A[j, j] -= mu
        # transform the block hessenberg to uppper triangular
        for k in range(alpha, beta):
            c_store[k-alpha], s_store[k-beta] = givens_setup(A[k, k], A[k+1, k])
            givens_rotation(A, k, k, c_store[k-alpha], s_store[k-alpha])
        # apply conjugate givens from right to return to hessenberg form
        for k in range(alpha, beta):
            conj_givens_rotation(A, k, k, c_store[k-alpha], s_store[k-alpha])
        # Adding mu back to the diagonal
        for j in range(alpha, beta+1):
            A[j, j] += mu
         # **Stopping Criterion**
        if all(
            abs(A[i + 1, i]) < tol * (abs(A[i, i]) + abs(A[i + 1, i + 1]))
            for i in range(n - 1)
        ):
            break
    return np.diag(A)

if __name__ == '__main__':
    # Generate a random 5x5 Hessenberg matrix
    A = np.random.rand(20, 20)
    A = (A + A.T) / 2

    # Measure time for qr_basic
    start_time = time.time()
    eigenvalues_basic, eigenvectors_basic = qr_basic(A.copy())
    time_basic = time.time() - start_time

    # Measure time for qr_hessenberg
    start_time = time.time()
    eigenvalues_hessenberg = qr_hessenberg(A.copy())
    time_hessenberg = time.time() - start_time

    # Measure time for qr_deflation
    start_time = time.time()
    eigenvalues_deflation = qr_deflation(A.copy())
    time_deflation = time.time() - start_time

    # use standard library to check the result
    eigenvalues_standard = np.sort(np.linalg.eigvals(A))
    

    print(f"Time taken by qr_basic: {time_basic:.4f} seconds")
    print(f"Time taken by qr_hessenberg: {time_hessenberg:.4f} seconds")
    print(f"Time taken by qr_deflation: {time_deflation:.4f} seconds")


    # Sort eigenvalues for comparison
    eigenvalues_basic_sorted = np.sort(eigenvalues_basic)
    eigenvalues_hessenberg_sorted = np.sort(eigenvalues_hessenberg)
    eigenvalues_deflation_sorted = np.sort(eigenvalues_deflation)
    
    print("Eigenvalues from standard library:")
    print(eigenvalues_standard)
    print("Eigenvalues from qr_basic:")
    print(eigenvalues_basic_sorted)
    print("Eigenvalues from qr_hessenberg:")    
    print(eigenvalues_hessenberg_sorted)
    print("Eigenvalues from qr_deflation:")
    print(eigenvalues_deflation_sorted)
