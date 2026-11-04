doit <- function(x) {
    temp_x <- sample(x, replace = TRUE)

    if (length(unique(temp_x)) > 30) {
        print(paste(
            "Mean of this sample was:",
            as.character(mean(temp_x))
        ))
    } else {
        stop("Couldn't calculate mean: too few unique values!")
    }
}

set.seed(1345)
popn <- rnorm(50)

# Save the population histogram under results/.
dir.create("results", showWarnings = FALSE)

pdf("results/try_population.pdf")
hist(popn)
dev.off()

# Catch sampling errors and continue through all iterations.
result <- lapply(1:15, function(i) try(doit(popn), FALSE))

# Repeat the operation using a for loop.
result <- vector("list", 15)

for (i in 1:15) {
    result[[i]] <- try(doit(popn), FALSE)
}

result