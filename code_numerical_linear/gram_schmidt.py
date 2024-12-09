# This is a file to compare three orthogonolization methods: Gram-Schmidt, Modified Gram-Schmidt, 
# and modified Gram-Schmidt with reorthogonolization.


import numpy as np

def gram_schmidt(A):
    """
    Perform the classical Gram-Schmidt orthogonalization.

    Parameters:
        A (ndarray): The input matrix with linearly independent columns.

    Returns:
        Q (ndarray): An orthogonal matrix.
        R (ndarray): An upper triangular matrix.
    """
    n, m = A.shape
    Q = np.zeros((n, m))
    R = np.zeros((m, m))

    for j in range(m):
        v = A[:, j]
        for i in range(j):
            R[i, j] = np.dot(Q[:, i], A[:, j])
            v = v - R[i, j] * Q[:, i]
        R[j, j] = np.linalg.norm(v)
        Q[:, j] = v / R[j, j]
    return Q, R

def modified_gram_schmidt(A):
    """
    Perform the Modified Gram-Schmidt orthogonalization.

    Parameters:
        A (ndarray): The input matrix with linearly independent columns.

    Returns:
        Q (ndarray): An orthogonal matrix.
        R (ndarray): An upper triangular matrix.
    """
    n, m = A.shape
    Q = np.zeros((n, m))
    R = np.zeros((m, m))

    for j in range(m):
        v = A[:, j]
        for i in range(j):
            R[i, j] = np.dot(Q[:, i], v)
            v = v - R[i, j] * Q[:, i]
        R[j, j] = np.linalg.norm(v)
        Q[:, j] = v / R[j, j]
    return Q, R

def modified_gs_reorthogonalization(A, tol=1e-20):
    """
    Perform the Modified Gram-Schmidt orthogonalization with reorthogonalization.

    Parameters:
        A (ndarray): The input matrix with linearly independent columns.
        tol (float): Tolerance for reorthogonalization.

    Returns:
        Q (ndarray): An orthogonal matrix.
        R (ndarray): An upper triangular matrix.
    """
    Q, R = modified_gram_schmidt(A)
    n, m = Q.shape

    for i in range(m):
        for j in range(i):
            proj = np.dot(Q[:, j], Q[:, i])
            if abs(proj) > tol:
                Q[:, i] -= proj * Q[:, j]
                R[j, i] -= proj
        R[i, i] = np.linalg.norm(Q[:, i])
        Q[:, i] = Q[:, i] / R[i, i]
    return Q, R

def main():
    delta = 1e-10
    A = np.array([
        [1, 1, 1],
        [delta, 0, 0],
        [0, delta, 0],
        [0, 0, delta]
    ], dtype=float)

    print("Matrix A:")
    print(A)
    print("\n")

    # Classical Gram-Schmidt
    Q_gs, R_gs = gram_schmidt(A)
    orthogonality_gs = np.dot(Q_gs.T, Q_gs)
    print("Classical Gram-Schmidt Orthogonality Q:")
    print(Q_gs)
    print("\n")

    # Modified Gram-Schmidt
    Q_mgs, R_mgs = modified_gram_schmidt(A)
    orthogonality_mgs = np.dot(Q_mgs.T, Q_mgs)
    print("Modified Gram-Schmidt Orthogonality Q:")
    print(Q_mgs)
    print("\n")

    # Modified Gram-Schmidt with Reorthogonalization
    Q_mgs_reortho, R_mgs_reortho = modified_gs_reorthogonalization(A)
    orthogonality_mgs_reortho = np.dot(Q_mgs_reortho.T, Q_mgs_reortho)
    print("Modified Gram-Schmidt with Reorthogonalization Q:")
    print(Q_mgs_reortho)
    print("\n")

    # # Compare Orthogonality
    # print("Deviation from Orthogonality (|Q^T Q - I|):")
    # identity = np.eye(A.shape[1])
    # dev_gs = np.linalg.norm(orthogonality_gs - identity)
    # dev_mgs = np.linalg.norm(orthogonality_mgs - identity)
    # dev_mgs_reortho = np.linalg.norm(orthogonality_mgs_reortho - identity)
    # print(f"Classical Gram-Schmidt: {dev_gs:.2e}")
    # print(f"Modified Gram-Schmidt: {dev_mgs:.2e}")
    # print(f"Modified Gram-Schmidt with Reorthogonalization: {dev_mgs_reortho:.2e}")

if __name__ == "__main__":
    main()