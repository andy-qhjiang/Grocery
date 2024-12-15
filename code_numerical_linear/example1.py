# This is an example showing that a vector in real number filed 
# can approximate a complex eigenvector of a matrix by Power method

import numpy as np

a = np.sqrt(3)
A = np.array([[1, 1, a], [1, 1, 1], [-a, 1, 1]])
v = np.array([1, 1, 1])

eigenvalues, eigenvectors = np.linalg.eig(A)

print("Eigenvalues of A:", eigenvalues)
print("Eigenvectors of A:\n", eigenvectors)

with open("vectors.txt", "w") as file:
    for i in range(100):
        v = A @ v
        v = v / np.linalg.norm(v)
        file.write(f"{v}\n")