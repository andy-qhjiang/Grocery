import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider
from scipy.integrate import quad

# Set up the figure and the axes
fig, ax = plt.subplots(2, 1, figsize=(10, 8))
plt.subplots_adjust(left=0.1, bottom=0.25)

# Parameters
N = 10  # Number of intervals
M = 1024  # Number of sample points per interval
x = np.linspace(0, 1, M, endpoint=False)
frequencies = [3, 5, 7]  # Frequencies of the sine waves
initial_amplitudes = [1.0, 0.5, 0.3]  # Initial amplitudes

# Create blackman window
g = np.zeros(M)
for A, f in zip(initial_amplitudes, frequencies):
    g += A * np.sin(2 * np.pi * f * x)
g = g + 2  # Lift the graph of g such that it is not negative

# Extend g to [0, N]
g_extended = np.tile(g, N)
t_extended = np.linspace(0, N, N * M, endpoint=False)

# Define the range of frequencies for the manual Fourier transform
freq_range = np.arange(1, 10, 0.02)
G_manual = np.zeros(len(freq_range))

# Compute the manual Fourier transform
for i, f in enumerate(freq_range):
    integrand = lambda t: g_extended[int(t * M)] * np.cos(2 * np.pi * f * t)
    G_manual[i], _ = quad(integrand, 0, N)

# Plot the original wave
[line1] = ax[0].plot(t_extended, g_extended, label='Extended Composite Wave')
ax[0].set_title('Extended Composite Wave g(x)')
ax[0].set_xlabel('t')
ax[0].set_ylabel('g(x)')
ax[0].legend()
ax[0].grid(True)

# Plot the manually computed Fourier transform
[line2] = ax[1].plot(freq_range, G_manual, label='Manual Fourier Transform')
ax[1].set_title('Manual Fourier Transform of g(x)')
ax[1].set_xlabel('Frequency')
ax[1].set_ylabel('Real Part')
ax[1].legend()
ax[1].grid(True)
ax[1].set_xlim(0.5, 10.5)  # Set x-axis limits to focus on the relevant frequency range

# Define sliders for amplitudes
axcolor = 'lightgoldenrodyellow'
slider_ax = []
sliders = []
for i in range(len(frequencies)):
    slider_ax.append(plt.axes([0.1, 0.1 - i*0.05, 0.8, 0.03], facecolor=axcolor))
    sliders.append(Slider(slider_ax[i], f'Amplitude {frequencies[i]}Hz', 0.0, 2.0, valinit=initial_amplitudes[i]))

def update(val):
    # Update amplitudes based on slider values
    amplitudes = [slider.val for slider in sliders]
    g_updated = np.zeros(M)
    for A, f in zip(amplitudes, frequencies):
        g_updated += A * np.sin(2 * np.pi * f * x)
    g_updated = g_updated + 2  # Lift the graph of g such that it is not negative
    g_updated *= window  # Apply window
    # Extend g_updated to [0, N]
    g_extended_updated = np.tile(g_updated, N)
    # Update the composite wave plot
    line1.set_ydata(g_extended_updated)
    
    # Compute updated manual Fourier transform
    G_manual_updated = np.zeros(len(freq_range))
    for i, f in enumerate(freq_range):
        integrand = lambda t: g_extended_updated[int(t * M)] * np.cos(2 * np.pi * f * t)
        G_manual_updated[i], _ = quad(integrand, 0, N)
    
    # Update the Fourier transform plot
    line2.set_ydata(G_manual_updated)
    
    fig.canvas.draw_idle()

# Register the update function with each slider
for slider in sliders:
    slider.on_changed(update)

plt.show()