## Function with conditionals

# Check whether an integer is even.
is.even <- function(n) {
    if (n %% 2 == 0) {
        return(paste(n, "is even!"))
    } else {
        return(paste(n, "is odd!"))
    }
}

is.even(7)


## Default arguments

is.even.default <- function(n = 2) {
    if (n %% 2 == 0) {
        return(paste(n, "is even!"))
    } else {
        return(paste(n, "is odd!"))
    }
}

is.even.default()
is.even.default(6)
is.even.default(n = 3)


# Round a height using the supplied or default precision.
report_height <- function(height_m, digits = 2) {
    round(height_m, digits = digits)
}

report_height(12.345)
report_height(12.345, digits = 1)


# Check whether a number is a power of 2.
is.power2 <- function(n) {
    if (log2(n) %% 1 == 0) {
        return(paste(n, "is a power of 2"))
    } else {
        return(paste(n, "is not a power of 2"))
    }
}

is.power2(4)


# Check whether a non-negative integer is prime.
is.prime <- function(n) {
    if (n == 0) {
        return(paste(n, "is a zero!"))
    } else if (n == 1) {
        return(paste(n, "is just a unit!"))
    } else if (n == 2) {
        return(paste(n, "is a prime!"))
    }

    ints <- 2:(n - 1)

    if (all(n %% ints != 0)) {
        return(paste(n, "is a prime!"))
    } else {
        return(paste(n, "is a composite!"))
    }
}

is.prime(109)