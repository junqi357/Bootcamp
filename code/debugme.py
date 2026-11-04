"""Intentional division-by-zero example for debugger practice."""


def buggyfunc(x):
    y = x
    for i in range(x):
        y = y - 1
        z = x / y
    return z


# With x = 20, the final iteration reaches i = 19 and y = 0.
buggyfunc(20)