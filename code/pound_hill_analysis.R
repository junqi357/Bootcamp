# Wrangle the Pound Hill dataset.
# Run from the coursework project root with:
# Rscript code/pound_hill_analysis.R

# Load the data ----------------------------------------------------------
# The first rows describe the sampling design, so do not use one as a header yet.
MyData <- as.matrix(read.csv("data/pound_hill_data.csv", header = FALSE))

# The metadata file does have a header and uses semicolons as separators.
MyMetaData <- read.csv("data/pound_hill_meta_data.csv", header = TRUE, sep = ";")

# Inspect the data -------------------------------------------------------
head(MyData)
dim(MyData)
str(MyData)
head(MyMetaData)
dim(MyMetaData)
str(MyMetaData)

# Transpose so species become columns and sampled quadrats become rows.
MyData <- t(MyData) 
head(MyData)
dim(MyData)

# For this dataset, we have been told that blanks are observed absences.
# That knowledge is what allows us to record them as zero rather than NA.
MyData[MyData == ""] <- 0

# Convert the raw matrix to a data frame --------------------------------

TempData <- as.data.frame(MyData[-1, ], stringsAsFactors = FALSE)
colnames(TempData) <- MyData[1, ]
rownames(TempData) <- NULL

# Convert from wide to long form using tidyr ----------------------------
library(tidyr)                                         # Load the package for reshaping data

MyWrangledData <- TempData |>
    tidyr::pivot_longer(
        cols = -c(Cultivation, Block, Plot, Quadrat),  # Keep the four identifying columns
        names_to = "Species",                          # Store species names in one column
        values_to = "Count"                            # Store species counts in one column
    )

MyWrangledData$Cultivation <- as.factor(MyWrangledData$Cultivation)
MyWrangledData$Block <- as.factor(MyWrangledData$Block)
MyWrangledData$Plot <- as.factor(MyWrangledData$Plot)
MyWrangledData$Quadrat <- as.factor(MyWrangledData$Quadrat)
MyWrangledData$Count <- as.numeric(MyWrangledData$Count)

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

# Check counts before calculating richness.
if (!is.numeric(MyWrangledData$Count) ||
    any(!is.finite(MyWrangledData$Count) |
        MyWrangledData$Count < 0)) {
  stop("Counts must be numeric, finite and non-negative.")
}

if (any(MyWrangledData$Count %% 1 != 0)) {
  stop("Counts must be whole numbers.")
}

# Count species and sampling units using their complete identifiers.
n_species <- length(unique(MyWrangledData$Species))

quadrats <- unique(
  MyWrangledData[, c("Cultivation", "Block", "Plot", "Quadrat")]
)

plots <- unique(
  MyWrangledData[, c("Cultivation", "Block", "Plot")]
)

print(c(
  Species = n_species,
  Quadrats = nrow(quadrats),
  Plots = nrow(plots)
))

stopifnot(nrow(plots) == 12)

# Count species present in each quadrat.
quadrat_richness <- aggregate(
  x = list(Richness = MyWrangledData$Count > 0),
  by = MyWrangledData[, c("Cultivation", "Block", "Plot", "Quadrat")],
  FUN = sum
)

# Calculate mean quadrat richness within each plot.
plot_richness <- aggregate(
  Richness ~ Cultivation + Block + Plot,
  data = quadrat_richness,
  FUN = mean
)

names(plot_richness)[names(plot_richness) == "Richness"] <- "MeanRichness"

# Check that each plot appears exactly once.
stopifnot(nrow(quadrat_richness) == 59)
stopifnot(nrow(plot_richness) == 12)
stopifnot(anyDuplicated(
  plot_richness[, c("Cultivation", "Block", "Plot")]
) == 0)

# Save the plot-level summary.
dir.create("results", showWarnings = FALSE)

write.csv(
  plot_richness,
  "results/pound_hill_plot_richness.csv",
  row.names = FALSE
)

print(plot_richness)

# Plot mean quadrat richness for each plot by cultivation treatment.
library(ggplot2)

richness_figure <- ggplot(
  plot_richness,
  aes(
    x = Cultivation,
    y = MeanRichness
  )
) +
  geom_point(
    colour = "grey30",
    size = 3.5,
    alpha = 0.85
  ) +
  scale_x_discrete(
    limits = c("march", "may", "october"),
    labels = c("March", "May", "October")
  ) +
labs(
  title = "Plant species richness at Pound Hill",
  x = "Cultivation treatment",
  y = "Mean species richness per quadrat",
  caption = "Each point represents one plot's mean across sampled quadrats."
) +
  theme_bw(base_size = 12) +
  theme(
    legend.position = "none",
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )

ggsave(
  filename = "results/pound_hill_plot_richness.pdf",
  plot = richness_figure,
  width = 6,
  height = 4
)

# Sum individual plants within each quadrat.
quadrat_abundance <- aggregate(
  Count ~ Cultivation + Block + Plot + Quadrat,
  data = MyWrangledData,
  FUN = sum
)

names(quadrat_abundance)[5] <- "Abundance"

# Calculate mean quadrat abundance within each plot.
plot_abundance <- aggregate(
  Abundance ~ Cultivation + Block + Plot,
  data = quadrat_abundance,
  FUN = mean
)

names(plot_abundance)[4] <- "MeanAbundance"

print(plot_abundance)

# Compare treatment averages, giving each plot equal weight.
comparison <- merge(
  plot_richness,
  plot_abundance,
  by = c("Cultivation", "Block", "Plot")
)

print(aggregate(
  cbind(MeanRichness, MeanAbundance) ~ Cultivation,
  data = comparison,
  FUN = mean
))

## Interpretation of richness

# May cultivation has the highest typical mean quadrat richness across the four plots.
# Plot values vary within each treatment, and the ranges overlap among treatments.
# Assessing whether cultivation timing caused these differences would require information about random treatment allocation, the block layout and plot independence.

## Comparison with abundance

# May has the highest mean richness, while October has the highest mean abundance.
# Richness counts species and abundance counts individual plants, so a plot containing many individuals of a few species can have high abundance alongside relatively low richness.