#!/usr/bin/env python3
"""Pure geometry for G64-Q-164. Does NOT run or model LinuxCNC."""
from math import dist

A, B, C = (0.0, 0.0), (10.0, 0.0), (20.0, 0.4)
P_TOL, Q_TOL = 0.01, 0.5

vx, vy = C[0] - A[0], C[1] - A[1]
t = max(0.0, min(1.0, ((B[0] - A[0]) * vx + (B[1] - A[1]) * vy) / (vx * vx + vy * vy)))
foot = (A[0] + t * vx, A[1] + t * vy)
deviation = dist(B, foot)
assert abs(deviation - 0.1999600119960014) < 1e-12
assert P_TOL < deviation < Q_TOL
print(f"PASS: distance={deviation:.12f} mm; P={P_TOL}, Q={Q_TOL}; "
      "geometry only, LinuxCNC NOT RUN")
