# This is a simple script to realize simultaneous iteration to solve the eigenvalue problem

import numpy as np

def sim_iter(A, V0, max_iter, tol=1e-6):
    count = 0
    q, R =np.linalg.qr(A @ V0) # we use @ in place of np.dot to emphasize matrix multiplication

    while count < max_iter:
        q, r = np.linalg.qr(np.dot(A, q))
        R = r @ R
        count += 1    
    
    Q = q
    return Q, R


if __name__ == '__main__':
    A = np.array([[4, 1, 1], [1, 3, 1], [1, 1, 2]])
    V0 = np.array([[1, 0], [0, 1], [0, 0]])
    Q, R = sim_iter(A, V0, 10)
    print(Q)
    print(R)