## Function with conditionals

# Checks if an integer is even

is.even <- function(n) {
    if (n %% 2 == 0) {                # Check whether the remainder is zero
        return(paste(n, "is even!"))
    } else {
        return(paste(n, "is odd!"))
    }
}

is.even(7)

#Default argument

is.even.default <- function(n = 2) {  # Set 2 as the default value of n
    if (n %% 2 == 0) {
        return(paste(n, "is even!"))
    } else {
        return(paste(n, "is odd!"))
    }
}

is.even.default()
is.even.default(6)
is.even.default(n = 3)

report_height <- function(height_m, digits = 2) {  # Round to 2 decimal places by default
    round(height_m, digits = digits)
}

report_height(12.345)
report_height(12.345, digits = 1)

# Checks if a number is a power of 2

is.power2 <- function(n) {
    if (log2(n) %% 1 == 0) {           # Check whether log2(n) is an integer
        return(paste(n, "is a power of 2"))
    } else {
        return(paste(n, "is not a power of 2"))
    }
}

is.power2(4)

# Checks if a number is prime

is.prime <- function(n) {
    if (n == 0) {
        return(paste(n, "is a zero!"))
    } else if (n == 1) {               # Check another condition if the first is FALSE
        return(paste(n, "is just a unit!"))
    }

    ints <- 2:(n - 1)                  # Create possible divisors from 2 to n-1

    if (all(n %% ints != 0)) {         # Check whether every remainder is non-zero
        return(paste(n, "is a prime!"))
    } else {
        return(paste(n, "is a composite!"))
    }
}

is.prime(109)
