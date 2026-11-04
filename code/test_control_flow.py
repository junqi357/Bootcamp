#!/usr/bin/env python3

"""Check the functions in control_flow.py."""

from control_flow import (
    count_above,
    even_or_odd,
    find_all_primes,
    is_prime,
    largest_divisor_five,
)


# Check ordinary even and odd integers.
assert even_or_odd(10) == "10 is Even!"
assert even_or_odd(5) == "5 is Odd!"

# Check zero and a negative integer.
assert even_or_odd(0) == "0 is Even!"
assert even_or_odd(-2) == "-2 is Even!"

# Check that text input raises TypeError.
try:
    even_or_odd("10")
except TypeError:
    pass
else:
    raise AssertionError("A non-integer input was accepted")

# Check divisors and a value with no divisor among 2–5.
assert largest_divisor_five(120) == 5
assert largest_divisor_five(8) == 4
assert largest_divisor_five(7) is None

# Check values around the first prime.
assert not is_prime(-1)
assert not is_prime(0)
assert not is_prime(1)
assert is_prime(2)
assert is_prime(3)
assert not is_prime(4)

# Check an empty prime range and an ordinary range.
assert find_all_primes(1) == []
assert find_all_primes(10) == [2, 3, 5, 7]

# Check an ordinary height collection.
assert count_above([8, 12, 10, 15], 10) == 2

# Check values below, at and above the threshold.
assert count_above([9, 10, 11], 10) == 1

# Check an empty collection.
assert count_above([], 10) == 0