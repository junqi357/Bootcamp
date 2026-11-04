## Import data
getwd()

MyData <- read.csv("data/trees.csv")

class(MyData)
head(MyData)
str(MyData)

# Include the first line as data.
MyData <- read.csv("data/trees.csv", header = FALSE)

head(MyData)
str(MyData)

# Specify the separator and header.
MyData <- read.table(
    "data/trees.csv",
    sep = ",",
    header = TRUE
)

# Skip the first five lines.
MyData <- read.csv("data/trees.csv", skip = 5)

head(MyData)


## Write and save files
MyData <- read.csv("data/trees.csv", header = TRUE)

# Create the output directory for a fresh checkout.
dir.create("results", showWarnings = FALSE)

write.csv(MyData, "results/MyData.csv")

dir("results/")

# Append a row; repeated column names produce the teaching warning.
write.table(
    MyData[1, ],
    file = "results/MyData.csv",
    append = TRUE
)

# Replace the file and include row names.
write.csv(MyData, "results/MyData.csv", row.names = TRUE)

# Demonstrate writing without column names.
write.table(MyData, "results/MyData.csv", col.names = FALSE)