# -*- coding: utf-8 -*-
"""
Created on Sun Mar 12 14:32:21 2023

@author: soltanis
"""
import matplotlib.pyplot as plt
import numpy as np

# Load the data from two files
data_files = ['FAR_MEAN_EQ.ell', 'FAR_MEAN_Noise.ell']

# Loop through the files and plot each one
fig, ax = plt.subplots(figsize=(7, 7))

for i, file in enumerate(data_files):
    # Load the data from file
    data = np.loadtxt(file)

    # Extract the data columns
    freq, val, err = data[:,0], data[:,1], data[:,2]

    # Compute the ratio and product of the value and error columns
    ratio = val / err
    prod = val * err

    # Plot the ratio and product of the data with error bars
    ax.loglog(freq, ratio, '--', color=f'C{i}', linewidth=2)
    ax.loglog(freq, prod, '--', color=f'C{i}', linewidth=2)

    # Fill the area between the ratio and product lines
    ax.fill_between(freq, ratio, prod, alpha=0.2, color=f'C{i}', label='RayDecC-error')

# Set up the plot for the first file
data = np.loadtxt(data_files[0])
freq, val, err = data[:,0], data[:,1], data[:,2]
ax.loglog(freq, val, 'b', linewidth=2, label = 'RayDecC')
# Set up the plot for the first file
data = np.loadtxt(data_files[1])
freq, val, err = data[:,0], data[:,1], data[:,2]
ax.loglog(freq, val, 'r', linewidth=2)


# Set axis limits and scale
ax.set_xlim(0.25, 1)
ax.set_ylim(0.1, 10)
ax.set_xscale('log')
ax.set_yscale('log')

# Set tick locations and formatting
ax.xaxis.set_major_locator(plt.LogLocator(base=10.0, subs=[1.0]))
ax.yaxis.set_major_locator(plt.LogLocator(base=10.0, subs=[1.0]))
ax.yaxis.set_major_formatter(plt.FormatStrFormatter("%.0f"))
ax.xaxis.set_major_formatter(plt.FormatStrFormatter("%.0f"))

# Add a legend
ax.legend()

# Set gridlines
ax.grid(True, color='black', linestyle='-', linewidth=0.1, which='both')

# Set background color
ax.set_facecolor('white')
plt.xlabel('Frequency(Hz)', fontsize=16, fontname='Arial')
plt.ylabel('Ellipticity', fontsize=16, fontname='Arial')

plt.xticks(fontsize=18, fontname='Arial')
plt.yticks(fontsize=18, fontname='Arial')

# Show the plot
plt.show()
