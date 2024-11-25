# This is a simple script to realize simultaneous iteration to solve the eigenvalue problem

import numpy as np
import QR_factor as myfun

def sim_iter(A, V0, max_iter, tol=1e-6):
    count = 0
    q, R = myfun.QR(A @ V0) # we use @ in place of np.dot to emphasize matrix multiplication

    while count < max_iter:
        q, r = np.linalg.qr(np.dot(A, q))
        R = r @ R
        count += 1    
    
    Q = q
    return Q, R


if __name__ == '__main__':
    A = np.array([[4, 1, 1], [1, 3, 1], [1, 1, 2]], dtype=float)
    V0 = np.array([[1, 0], [0, 1], [0, 0]], dtype=float)
    Q, R = sim_iter(A, V0, 10)
    print(Q)
    print(R)