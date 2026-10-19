outer_function <- function(a) {
  middle_function(a)
}

middle_function <- function(b) {
  inner_function(b)
}

inner_function <- function(c) {
  result <- c / d
  return(result)
}

outer_function(1)


buggy_function <- function(n) {
  result <- n + unknown_variable
  return(result)
}