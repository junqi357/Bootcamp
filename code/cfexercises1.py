#!/usr/bin/env python3

"""Demonstrate functions, conditionals and factorial calculations."""


def foo_1(x):
    """Return the square root of a non-negative number."""
    return x ** 0.5


def foo_2(x, y):
    """Return the larger of two numbers."""
    if x > y:
        return x
    return y


def foo_3(x, y, z):
    """Return three numbers in ascending order."""
    if x > y:
        x, y = y, x
    if x > z:
        x, z = z, x
    if y > z:
        y, z = z, y
    return [x, y, z]


def foo_4(x):
    """Return the factorial of a non-negative integer using a for loop."""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result


def foo_5(x):
    """Return the factorial of a non-negative integer recursively."""
    if x == 0 or x == 1:
        return 1
    return x * foo_5(x - 1)


def foo_6(x):
    """Return the factorial of a non-negative integer using a while loop."""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto


def main():
    """Run examples and check their results."""
    print("Square root:", foo_1(16))
    print("Larger number:", foo_2(3, 5))
    print("Sorted numbers:", foo_3(3, 1, 2))
    print("For-loop factorial:", foo_4(5))
    print("Recursive factorial:", foo_5(5))
    print("While-loop factorial:", foo_6(5))

    assert foo_1(16) == 4
    assert foo_2(3, 5) == 5
    assert foo_3(3, 1, 2) == [1, 2, 3]

    # Check known factorial results, including zero.
    for number, expected in [(0, 1), (1, 1), (5, 120)]:
        assert foo_4(number) == expected
        assert foo_5(number) == expected
        assert foo_6(number) == expected

    print("Function checks passed.")


if __name__ == "__main__":
    main()