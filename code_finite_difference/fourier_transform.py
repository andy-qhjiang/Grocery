import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import quad
from matplotlib.animation import FuncAnimation

# Set up the first figure and the axes
fig1, ax1 = plt.subplots(2, 1, figsize=(10, 8))
plt.subplots_adjust(left=0.1, bottom=0.2, hspace=0.5)

# Parameters
N = 7  # Number of intervals
M = 500  # Number of sample points per interval
x = np.linspace(0, 1, M, endpoint=False)
frequencies = [3, 5, 7]  # Frequencies of the sine waves
initial_amplitudes = [1.0, 0.5, 0.3]  # Initial amplitudes

# Define the original function g(t) based on the parameters and sine waves
def g(t):
    return sum(a * np.sin(2 * np.pi * f * t) for a, f in zip(initial_amplitudes, frequencies))

# Generate t values and compute g(t) for plotting
t_values = np.linspace(0, N, N * M, endpoint=False)
g_values = g(t_values % 1) + 2  # Lift the graph of g such that it is not negative

# Define the range of frequencies for the manual Fourier transform
freq_range = np.arange(1, 10, 0.01)
G_manual = np.zeros(len(freq_range))

# Compute x-coordinate of Fourier transform of g
for i, f in enumerate(freq_range):
    integrand = lambda t: g(t % 1) * np.cos(2 * np.pi * f * t)
    G_manual[i], _ = quad(integrand, 0, N, limit=1000, epsabs=1e-12, epsrel=1e-12)

# Plot the original wave
ax1[0].plot(t_values, g_values, label='Original Wave g(t)')
ax1[0].set_title('Function g(t)')
ax1[0].set_xlabel('t')
ax1[0].set_ylabel('g(t)')
ax1[0].legend()
ax1[0].grid(True)

# Plot the manually computed Fourier transform
ax1[1].plot(freq_range, G_manual, label='Manual Fourier Transform')
ax1[1].set_title('Fourier Transform \hat{g}(f)')
ax1[1].set_xlabel('Frequency')
ax1[1].set_ylabel('Real Part')
ax1[1].legend()
ax1[1].grid(True)
ax1[1].set_xlim(0.5, 10.5)  # Set x-axis limits to focus on the relevant frequency range

# Create a new figure for the track of point P
fig2, ax2 = plt.subplots(figsize=(8, 6))

# Compute the coordinates for the track of point P
fixed_frequency = 3.6  # You can change this to any frequency of interest
x_coordinates = g_values * np.cos(2 * np.pi * fixed_frequency * t_values)
y_coordinates = -g_values * np.sin(2 * np.pi * fixed_frequency * t_values)

# Initialize the plot
line, = ax2.plot([], [], label=f'Track of Point P at f={fixed_frequency}')
mean_point, = ax2.plot([], [], 'ro', label='Mean Point')
progress_text = ax2.text(0.5, 0.9, '')
ax2.set_title(f'Track of Point P with Coordinates g(t)cos(2πft) and -g(t)sin(2πft)')
ax2.set_xlabel('Real Part')
ax2.set_ylabel('Imaginary Part')
ax2.legend(loc='upper right')
ax2.grid(True)

# Set the limits of the plot
ax2.set_xlim(np.min(x_coordinates), np.max(x_coordinates))
ax2.set_ylim(np.min(y_coordinates), np.max(y_coordinates))

# Precompute the mean point
mean_x = np.mean(x_coordinates)
mean_y = np.mean(y_coordinates)

# Animation function
def animate(i):
    line.set_data(x_coordinates[:i], y_coordinates[:i])
    if 0 < i < len(x_coordinates):
        mean_point.set_data([np.mean(x_coordinates[:i])], [np.mean(y_coordinates[:i])])
        mean_point.set_label(f'Mean Point ({np.mean(x_coordinates[:i]):.2f}, {np.mean(y_coordinates[:i]):.2f})')
    progress_text.set_text(f'Progress: {i/len(x_coordinates)*100:.2f}%')
    ax2.legend(loc='upper right')
    return line, mean_point, progress_text

# Create the animation
ani = FuncAnimation(fig2, animate, frames=len(x_coordinates)+1, interval=10, repeat=False)
# Show both figures
plt.show()