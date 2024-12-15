# This is a simple script to explore whether the basis we find by QR-iteration for invariant subspaces 
# corresponding to largest k eigenvalues of a matrix are exactly the same as the eigenvectors of the matrix.

import numpy as np

def gene_Q(A, k, iter_max=1000):
    n = A.shape[0]
    V = np.zeros((n, k))
    for i in range(k):
        V[i, i] = 1
        Q, _ = np.linalg.qr(A @ V)
    for i in range(iter_max):
        Q, _ = np.linalg.qr(A @ Q)
    return Q

# This is a 6\times 6 normal matrix with a triple eigenvalue 5 
# and three single eigenvalues 1 2 and 3. 
# I wanna see whether there exists a basis with k=3 which is different from the eigenvectors.
def test2():
    # Set random seed for reproducibility
    np.random.seed(42)

    # Generate a random 6x6 matrix
    random_matrix = np.random.rand(6, 6)

    # Perform QR decomposition to obtain an orthogonal matrix Q
    Q, _ = np.linalg.qr(random_matrix)
    print(Q)
    # Create the diagonal matrix with eigenvalues 1, 2, 3, 5, 5, 5
    D = np.diag([1, 2, 3, 5, 5, 5])

    # Construct the matrix A
    A = Q.T @ D @ Q
    print(A)

if __name__ ==  "__main__":
    # A = np.random.rand(8, 8)
    # A = (A + A.T)/2
    # eig_val, eig_vec = np.linalg.eig(A)
    # print(eig_vec)
    # Q = gene_Q(A)
    # print(Q)
    # Lambda = Q.T @ A @ Q
    # print(Lambda)
    A = np.array([
    [3.77700333, -0.31327627, 0.22123663, -0.53334636, 0.94481186, -0.57762509],
    [-0.31327627, 2.34192535, 0.69067867, 0.68996756, 0.70022714, -0.57595962],
    [0.22123663, 0.69067867, 4.78552492, -0.06851749, -0.21283886, 0.44159718],
    [-0.53334636, 0.68996756, -0.06851749, 4.42317306, 0.11877337, -0.59404255],
    [0.94481186, 0.70022714, -0.21283886, 0.11877337, 3.91824692, -0.36352365],
    [-0.57762509, -0.57595962, 0.44159718, -0.59404255, -0.36352365, 1.75412642]
    ])
    Q = gene_Q(A, 3)
    print(Q)
    Lambda = Q.T @ A @ Q
    print(Lambda)