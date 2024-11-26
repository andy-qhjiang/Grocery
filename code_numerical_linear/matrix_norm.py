# This is a file to draw the unit circle under 2-norm 
# and the image of the unit circle by multiplying matrix np.array([[1, 2], [0 ,2]])
# where one can see that the image is an ellipse and the major axis corresponds to the eigenvector of the matrix.

import os
import numpy as np
import matplotlib.pyplot as plt

# Define the unit circle
theta = np.linspace(0, 2 * np.pi, 100) # one dimensional array, like a list with 100 elements
unit_circle = np.array([np.cos(theta), np.sin(theta)]) #Two dimensional array, like a matrix with 2 rows and 100 columns


# Define the transformation matrix
transformation_matrix = np.array([[1, 2], [0, 2]])

# Apply the transformation to the unit circle
transformed_circle = transformation_matrix @ unit_circle

eigenvector =np.array([2, 1])
transformed_eigenvector = transformation_matrix @ eigenvector

# Create subplots
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))

# Plot the unit circle in the first subplot
ax1.plot(unit_circle[0, :], unit_circle[1, :], 'b-')
ax1.fill(unit_circle[0, :], unit_circle[1, :], 'b', alpha=0.3)
ax1.set_title('Unit Circle under 2-norm')
ax1.set_xlim(-2, 2)
ax1.set_ylim(-2, 2)
ax1.set_aspect('equal')

# Plot the transformed circle (ellipse) in the second subplot
ax2.plot(transformed_circle[0, :], transformed_circle[1, :], 'r-')
ax2.fill(transformed_circle[0, :], transformed_circle[1, :], 'r', alpha=0.3)
ax2.set_title('Transformed Circle (Ellipse)')
ax2.set_xlim(-4, 4)
ax2.set_ylim(-4, 4)
ax2.set_aspect('equal')

# Draw a dashed line from (0, 0) to the transformed eigenvector
ax2.plot([0, 4/np.sqrt(5)], [0, 2/np.sqrt(5)], 'k--')

# Define the path to save the plot
script_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(script_dir)
save_dir = os.path.join(parent_dir, 'illustrations')

# Create the directory if it doesn't exist
os.makedirs(save_dir, exist_ok=True)

# Save the plot
save_path = os.path.join(save_dir, 'matrix_norm.png')
plt.savefig(save_path)

# Show the plots
plt.show()