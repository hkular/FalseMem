# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np 
from numpy import pi
import matplotlib.pyplot as plt 
 

N = 36   # number of points
R = 0.5  # radius

# define our angles
ang = np.linspace(0, (2*pi)-((2*pi)/N), N) 
 
# make the circle
x = R * np.cos(ang)
y = R * np.sin(ang) 
 
# plot
fig, ax = plt.subplots(1) 
 
ax.scatter(x, y, c=np.arange(0,N,1), cmap='hsv', linewidth = 5) 
ax.set_aspect(1) 

# lines for excitatory connections
ind = [[0,3],[0,5],[0,7]] 

for i in np.arange(len(ind)):
    plt.plot(x[ind[i]], y[ind[i]], c='g', alpha=1-(.25*i))
    plt.plot(x[ind[i]], -y[ind[i]], c='g', alpha=1-(.25*i))

# lines for inhibitory connections
ind = [[0,9],[0,11],[0,13],[0,15],[0,17]] 

for i in np.arange(len(ind)):
    plt.plot(x[ind[i]], y[ind[i]], c='r', alpha=(.2*i)+.2)
    plt.plot(x[ind[i]], -y[ind[i]], c='r', alpha=(.2*i)+.2)

plt.savefig('ring.svg', dpi = 600)
plt.show() 


