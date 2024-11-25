# This is a simple function to realize QR factorization of a matrix by Householder transformation

# We store the normalized vector v which is used to construct the Householder matrix H, 
# and use the technique Qe_{1} to reconstruct the orthogonal matrix Q.

import numpy as np

def QR(A):
    m, n = A.shape
    V = []  # List to store the vectors v
    for i in range(n):
        x = A[i:, i]
        e = np.zeros_like(x)
        e[0] = 1
        v = x + np.sign(x[0]) * np.linalg.norm(x) * e
        v = v / np.linalg.norm(v)
        V.append(v)  # Store the vector v
        for j in range(i, n):
            A[i:, j] -= 2 * np.dot(v, A[i:, j]) * v


    # Compute the m-by-m matrix Q
    Q = np.eye(m)
    for i in range(m):
        e_i = np.eye(m)[:, i]
        for k in range(n-1, -1, -1):
            e_i[k:] -= 2 * np.dot(V[k], e_i[k:]) * V[k]
        Q[:, i] = e_i
        
    #-----------------------------------------------------------------
    # The following part computes the transpose of Q appearing in A = QR, 
    # which costs more time than the above part
    #-----------------------------------------------------------------
    # Q = np.eye(m)
    # for i in range(n-1, -1, -1):
    #     v = V[i]
    #     H = np.eye(m)
    #     H[i:, i:] -= 2 * np.outer(v, v)
    #     Q = np.dot(Q, H)

    return Q, A

# Example usage

if __name__ == "__main__":
    A = np.array([[12, 1], [4, 3], [3, 1]], dtype=float)
    Q, R = QR(A)
    print("Q:\n", Q)
    print("R:\n", R)
    print("QR:\n", np.dot(Q, R))

# Attention: Matrix A is changed after QR factorization, so if you want to use A later, 
# you should make a copy of A.



