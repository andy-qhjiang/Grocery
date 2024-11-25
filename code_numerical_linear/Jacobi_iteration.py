# This is a program to compute the eigenvalues of a n-by-n real symmetrix matrix
#  by Jacobi algorithm with the standard row-wise ordering.
# Also Plot the sum of the squares of off-diagonal elements of the updated matrix A 
# on a log scale as a function of the number of sweeps, i.e. the number of upper triangular elements of A, (n-1)*n/2.

import numpy as np
import matplotlib.pyplot as plt

# This is a program to compute the eigenvalues of a n-by-n real symmetric matrix
# by Jacobi algorithm with the standard row-wise ordering.
# Also Plot the sum of the squares of off-diagonal elements of the updated matrix A 
# on a log scale as a function of the number of sweeps.

def jacobi_eigenvalue(A, tol=1e-20, max_sweeps=50):
    n = A.shape[0]
    sweep = 0
    off_diagonal_sums = []

    while sweep < max_sweeps:
        for i in range(n-1):
            for j in range(i+1, n):
                if A[i, j] != 0:
                    tau = (A[j, j] - A[i, i]) / (2 * A[i, j])
                    t = np.sign(tau) / (abs(tau) + np.sqrt(1 + tau**2)) if tau != 0 else 1
                    c = 1 / np.sqrt(1 + t**2)
                    s = c * t

                    # Create the rotation matrix
                    R = np.eye(n)
                    R[i, i] = c
                    R[j, j] = c
                    R[i, j] = s
                    R[j, i] = -s

                    # Apply the rotation
                    A = R.T @ A @ R

        # Compute the sum of squares of off-diagonal elements
        off_sum = np.sum(A**2) - np.sum(np.diag(A)**2)
        if off_sum < tol:
            break
        
        off_diagonal_sums.append(off_sum)
        sweep += 1
        # print("After", sweep, "sweeps:")
        # print(A)
    eigenvalues = np.diag(A)
    return eigenvalues, sweep, off_diagonal_sums


# Example usage
if __name__ == "__main__":
    # Define a symmetric matrix
    # Generate a random 10x10 matrix
    A = np.random.rand(80, 80)

    # Make the matrix symmetric
    A = (A + A.T) / 2

    print("Random 40x40 symmetric matrix:")
    print(A)

    eigenvalues, sweeps, off_sums = jacobi_eigenvalue(A)
    print("Off-diagonal sums:", off_sums)

    # Plot the sum of squares of off-diagonal elements
    plt.figure(figsize=(8, 6))
    plt.semilogy(range(1, len(off_sums) + 1), off_sums, 'b-o')
    plt.title('Convergence of Jacobi Method')
    plt.xlabel('Number of Sweeps')
    plt.ylabel('Sum of Squares of Off-Diagonal Elements')
    plt.grid(True)
    plt.show()