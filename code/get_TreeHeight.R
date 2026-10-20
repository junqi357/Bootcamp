# Calculate tree height in metres from an angle in degrees, and the horizontal distance in metres.
TreeHeight <- function(degrees, distance) {
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  return(height)
}

# Read and inspect the supplied tree measurements.
# Accept exactly one input CSV path.
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 1) {
  stop("Usage: Rscript code/get_TreeHeight.R <input.csv>")
}

input_path <- args[1]

if (!file.exists(input_path) ||
    dir.exists(input_path) ||
    file.access(input_path, mode = 4) != 0) {
  stop("Input must be an existing, readable CSV file.")
}

trees <- read.csv(input_path)

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

# Build the output filename from the input basename.
input_name <- tools::file_path_sans_ext(basename(input_path))
output_path <- file.path(
  "results",
  paste0(input_name, "_treeheights.csv")
)

if (normalizePath(input_path, mustWork = TRUE) ==
    normalizePath(output_path, mustWork = FALSE)) {
  stop("Output path must differ from the input path.")
}

write.csv(trees, output_path, row.names = FALSE)