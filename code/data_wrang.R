# Wrangle the Pound Hill dataset.
# Run from the project root:
# Rscript code/data_wrang.R

# Read the sampling labels and counts without assigning a header.
MyData <- as.matrix(
    read.csv("data/pound_hill_data.csv", header = FALSE)
)

MyMetaData <- read.csv(
    "data/pound_hill_meta_data.csv",
    header = TRUE,
    sep = ";"
)

head(MyData)
dim(MyData)
str(MyData)
head(MyMetaData)

# Transpose so sampled quadrats become rows.
MyData <- t(MyData)

head(MyData)
dim(MyData)

# The metadata identifies blank counts as observed absences.
MyData[MyData == ""] <- 0

TempData <- as.data.frame(
    MyData[-1, ],
    stringsAsFactors = FALSE
)

colnames(TempData) <- MyData[1, ]
rownames(TempData) <- NULL

# Reshape the table using the legacy reshape2 method.
library(reshape2)

MyWrangledData <- melt(
    TempData,
    id = c("Cultivation", "Block", "Plot", "Quadrat"),
    variable.name = "Species",
    value.name = "Count"
)

MyWrangledData$Cultivation <- as.factor(MyWrangledData$Cultivation)
MyWrangledData$Block <- as.factor(MyWrangledData$Block)
MyWrangledData$Plot <- as.factor(MyWrangledData$Plot)
MyWrangledData$Quadrat <- as.factor(MyWrangledData$Quadrat)
MyWrangledData$Count <- as.integer(MyWrangledData$Count)

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

# Save the derived table separately from the raw data.
dir.create("results", showWarnings = FALSE)

write.csv(
    MyWrangledData,
    "results/pound_hill_long.csv",
    row.names = FALSE
)