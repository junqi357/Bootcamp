# Calculate tree height in metres from an angle in degrees, and the horizontal distance in metres.
TreeHeight <- function(degrees, distance) {
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  return(height)
}

# Read and inspect the supplied tree measurements.
trees <- read.csv("data/trees.csv")

head(trees)
str(trees)

# Check required columns.
required_columns <- c("Species", "Distance.m", "Angle.degrees")

if (!all(required_columns %in% names(trees))) {
  stop("Input CSV must contain Species, Distance.m and Angle.degrees.")
}

# Check distances.
if (!is.numeric(trees$Distance.m)) {
  stop("Distance.m must be numeric.")
}

if (any(!is.finite(trees$Distance.m) |
        trees$Distance.m <= 0 |
        trees$Distance.m > 100)) {
  stop("Distance.m must contain finite values greater than 0 and at most 100.")
}

# Check angles.
if (!is.numeric(trees$Angle.degrees)) {
  stop("Angle.degrees must be numeric.")
}

if (any(!is.finite(trees$Angle.degrees) |
        trees$Angle.degrees <= 0 |
        trees$Angle.degrees >= 90)) {
  stop("Angle.degrees must contain finite values greater than 0 and less than 90.")
}

# Calculate height for each row, preserving the input column order.
trees <- trees[, c("Species", "Distance.m", "Angle.degrees")]

trees$height_m <- TreeHeight(
  degrees = trees$Angle.degrees,
  distance = trees$Distance.m
)

# Create the results directory and save the output.
dir.create("results", showWarnings = FALSE)

write.csv(trees, "results/TreeHts.csv", row.names = FALSE)