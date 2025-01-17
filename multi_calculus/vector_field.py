import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Define the surface function
def f(x, y):
    return x**2 + y**2

# Create a grid of points
x = np.linspace(-5, 5, 400)
y = np.linspace(-5, 5, 400)
X, Y = np.meshgrid(x, y)
Z = f(X, Y)

# Define the plane equation
plane_equation = 2*X - Y - 4

# 1. plane_equation evaluates to an array of values
# Values < 0 are on one side of the plane, > 0 on other side
mask = plane_equation < 0  # Creates boolean array: True where < 0, False elsewhere

# 2. np.where() works like this:
# - Where mask is True: keep original Z value
# - Where mask is False: replace with np.nan
Z_masked = np.where(mask, Z, np.nan)

# 3. When plotting, numpy automatically skips np.nan values,
# effectively making those points invisible

# Plot the surface
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(X, Y, Z_masked, alpha=0.8, cmap='viridis', edgecolor='none')

# Plot the plane for reference
plane_x = np.linspace(-0.5, 4.5, 500)
plane_y = 2 * plane_x - 4
plane_z = plane_x**2 + plane_y**2
ax.plot(plane_x, plane_y, plane_z, color='r', label='Intersection Curve')

# Labels and legend
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
ax.legend()

plt.show()
