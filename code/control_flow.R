## if statements
a <- TRUE

if (a) {               # If a is TRUE, run the code inside this block
    print("a is TRUE")
} else {               # Otherwise, run this block
    print("a is FALSE")
}

z <- runif(1)          # Generate one random number between 0 and 1

if (z <= 0.5) {        # Check whether z is less than or equal to 0.5
    print("Less than a half")
}


## for loops
for (i in 1:10) {      # Repeat the loop for each number from 1 to 10
    j <- i * i         # Calculate the square of the current number
    print(paste(i, " squared is", j))
}

for (species in c("Heliodoxa rubinoides",
                  "Boissonneaua jardini",
                  "Sula nebouxii")) {
    print(paste("The species is", species))
}

# for loop using vector
v1 <- c("a", "bc", "def")

for (i in v1) {        # Repeat the loop for each element in v1
    print(i)
}