import numpy as np

# Generate random symmetric matrix
n = 6
A_random = np.random.rand(n, n)
A = (A_random + A_random.T) / 2

# Get eigenvectors Q and eigenvalues
eigenvals, Q = np.linalg.eigh(A)

# Select eigenvectors and create combination
xi1 = Q[:, 0]
xi2 = Q[:, 3]
a, b = 3.93, -0.7  # arbitrary coefficients
xi3 = a * xi1 + b * xi2
xi4 = np.zeros((n,1))

# Construct X
X = np.column_stack([xi1, xi2, xi4, xi3])

# Compute Lambda
X_pseudo = np.linalg.pinv(X)
Lambda = X_pseudo @ A @ X

print("Matrix A:")
print(A)
print("\nEigenvalues of A:", eigenvals)
print("\nMatrix X:")
print(X)
print("\nMatrix Lambda:")
print(Lambda)
print("\nEigenvalues of Lambda:", np.linalg.eigvals(Lambda))
print("\nVerify AX = XΛ:")
print("Difference norm:", np.linalg.norm(A @ X - X @ Lambda))