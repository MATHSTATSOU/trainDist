# Train delay distribution (dpqr) implemented in pure Python.
# Y has density f(y) = c * (25 - y^2) for -5 < y < 5, 0 otherwise, where c = 3/500.
# The CDF on (-5,5) is F(y) = 1/2 + 0.15*y - y**3/500.
# This module provides vector-friendly dpqr functions to be called from R via reticulate.

from typing import Iterable, Union
import random

Number = Union[int, float]
C = 3.0 / 500.0

def _is_iterable(x) -> bool:
    try:
        iter(x)
        return not isinstance(x, (str, bytes))
    except TypeError:
        return False

def _to_list(x):
    if _is_iterable(x):
        return [float(v) for v in x]
    return [float(x)]

def _from_list(vals, template):
    return vals if _is_iterable(template) else vals[0]

def _d_scalar(y: Number) -> float:
    if -5.0 < y < 5.0:
        return C * (25.0 - y * y)
    return 0.0

def dtrain(x):
    xs = _to_list(x)
    return _from_list([_d_scalar(v) for v in xs], x)

def _F_scalar(y: Number) -> float:
    if y <= -5.0:
        return 0.0
    if y >= 5.0:
        return 1.0
    return 0.5 + 0.15 * y - (y ** 3) / 500.0

def ptrain(q):
    qs = _to_list(q)
    return _from_list([_F_scalar(v) for v in qs], q)

def _q_scalar(p: float, tol: float = 1e-12, maxiter: int = 200) -> float:
    if not (0.0 <= p <= 1.0):
        raise ValueError("p must be in [0, 1]")
    if p == 0.0:
        return -5.0
    if p == 1.0:
        return 5.0
    a, b = -5.0, 5.0
    def g(y):
        return _F_scalar(y) - p
    if g(a) > 0:
        a, b = b, a
    for _ in range(maxiter):
        m = 0.5 * (a + b)
        gm = g(m)
        if abs(gm) < tol or (b - a) < tol:
            return m
        if gm > 0:
            b = m
        else:
            a = m
    return 0.5 * (a + b)

def qtrain(p):
    ps = _to_list(p)
    return _from_list([_q_scalar(float(v)) for v in ps], p)

def rtrain(n: int, seed: int = None):
    if seed is not None:
        random.seed(int(seed))
    if n < 0:
        raise ValueError("n must be non-negative")
    us = [random.random() for _ in range(int(n))]
    return [_q_scalar(u) for u in us]

