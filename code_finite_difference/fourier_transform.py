import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import quad
from matplotlib.animation import FuncAnimation

# Set up the first figure and the axes
fig1, ax1 = plt.subplots(2, 1, figsize=(10, 8))
plt.subplots_adjust(left=0.1, bottom=0.2, hspace=0.5)

# Parameters
N = 10  # Number of intervals
M = 500  # Number of sample points per interval
x = np.linspace(0, 1, M, endpoint=False)
frequencies = [3, 5, 7]  # Frequencies of the sine waves
initial_amplitudes = [1.0, 0.5, 0.3]  # Initial amplitudes

# Create blackman window
g = np.zeros(M)
for i in range(3):
    g += initial_amplitudes[i] * np.sin(2 * np.pi * frequencies[i] * x)
g = g + 2  # Lift the graph of g such that it is not negative

# Extend g to [0, N]
g_extended = np.tile(g, N)
t_extended = np.linspace(0, N, N * M, endpoint=False)

# Define the range of frequencies for the manual Fourier transform
freq_range = np.arange(1, 10, 0.02)
G_manual = np.zeros(len(freq_range))

# Compute x-coordinate of Fourier transform of g
for i, f in enumerate(freq_range):
    integrand = lambda t: g_extended[int(t * M)] * np.cos(2 * np.pi * f * t)
    G_manual[i], _ = quad(integrand, 0, N)

# Plot the original wave
ax1[0].plot(t_extended, g_extended, label='Extended Composite Wave')
ax1[0].set_title('Extended Composite Wave g(t)')
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
fixed_frequency = 3  # You can change this to any frequency of interest
x_coordinates = g_extended * np.cos(2 * np.pi * fixed_frequency * t_extended)
y_coordinates = -g_extended * np.sin(2 * np.pi * fixed_frequency * t_extended)

# Initialize the plot
line, = ax2.plot([], [], label=f'Track of Point P at f={fixed_frequency}')
mean_point, = ax2.plot([], [], 'ro', label='Mean Point')
completion_text = ax2.text(0.5, 0.5, '', transform=ax2.transAxes, ha='center')
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
    if 0< i < len(x_coordinates):
        mean_point.set_data([np.mean(x_coordinates[:i])], [np.mean(y_coordinates[:i])])
        mean_point.set_label(f'Mean Point ({np.mean(x_coordinates[:i]):.2f}, {np.mean(y_coordinates[:i]):.2f})')
    else:
        mean_point.set_data([mean_x], [mean_y])
        mean_point.set_label(f'Mean Point ({mean_x:.2f}, {mean_y:.2f})')
        completion_text.set_text('Animation Complete')
    ax2.legend(loc='upper right')
    return line, mean_point, completion_text

# Create the animation
ani = FuncAnimation(fig2, animate, frames=len(x_coordinates)+10, interval=20, blit=True, repeat=False)

# Show both figures
plt.show()