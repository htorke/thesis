#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import matplotlib as mpl
from mpl_toolkits.mplot3d import Axes3D
from scipy import integrate
from matplotlib import pyplot as plt
from matplotlib import cm
import time
import os

plt.close('all')

# selection 1 = Gaussian
# selection 2 = Donut
selection = 1

print(' ')
print('raysimple.py')


def refindex(x, y):
    if selection == 1:

        sig = 10

        n = 1 + np.exp(-(x ** 2 + y ** 2) / 2 / sig ** 2)
        nx = (-2 * x / 2 / sig ** 2) * np.exp(-(x ** 2 + y ** 2) / 2 / sig ** 2)
        ny = (-2 * y / 2 / sig ** 2) * np.exp(-(x ** 2 + y ** 2) / 2 / sig ** 2)

    elif selection == 2:

        sig = 10;
        r2 = (x ** 2 + y ** 2)
        r1 = np.sqrt(r2)
        np.expon = np.exp(-r2 / 2 / sig ** 2)

        n = 1 + 0.3 * r1 * np.expon;
        nx = 0.3 * r1 * (-2 * x / 2 / sig ** 2) * np.expon + 0.3 * np.expon * 2 * x / r1
        ny = 0.3 * r1 * (-2 * y / 2 / sig ** 2) * np.expon + 0.3 * np.expon * 2 * y / r1

    return [n, nx, ny]


def flow_deriv(x_y_z, tspan):
    x, y, z, w = x_y_z

    n, nx, ny = refindex(x, y)

    yp = np.zeros(shape=(4,))
    yp[0] = z / n
    yp[1] = w / n
    yp[2] = nx
    yp[3] = ny

    return yp


V = np.zeros(shape=(100, 100))
for xloop in range(100):
    xx = -20 + 40 * xloop / 100
    for yloop in range(100):
        yy = -20 + 40 * yloop / 100
        n, nx, ny = refindex(xx, yy)
        V[yloop, xloop] = n

fig = plt.figure(1)
contr = plt.contourf(V, 100, cmap=cm.coolwarm, vmin=1, vmax=3)
fig.colorbar(contr, shrink=0.5, aspect=5)
fig = plt.show()

v1 = 0.5  # Change this initial condition
v2 = np.sqrt(1 - v1 ** 2)
y0 = [12, v1, 0, v2]  # Change these initial conditions

tspan = np.linspace(1, 1700, 1700)

y = integrate.odeint(flow_deriv, y0, tspan)

plt.figure(2)
lines = plt.plot(y[1:1550, 0], y[1:1550, 1])
plt.setp(lines, linewidth=0.5)
plt.show()