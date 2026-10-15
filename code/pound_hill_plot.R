library(ggplot2)

# Read the processed Pound Hill data
MyPlotData <- read.csv("results/pound_hill_long_tidy.csv")

# Set the cultivation order
MyPlotData$Cultivation <- factor(
    MyPlotData$Cultivation,
    levels = c("march", "may", "october")
)

# Create comparable histograms for the three treatments
p <- ggplot(MyPlotData, aes(x = Count)) +
    geom_histogram(
        binwidth = 1,       # Each bin covers one individual count
        boundary = -0.5,    # Centre bins on whole numbers, including zero
        fill = "lightblue",
        colour = "black"
    ) +
    facet_wrap(~ Cultivation, scales = "fixed") +  # Use shared axes
    scale_x_continuous(
        limits = c(-0.5, max(MyPlotData$Count) + 0.5)
    ) +
    labs(
        title = "Species abundance across cultivation treatments",
        x = "Individuals per species per quadrat",
        y = "Frequency"
    ) +
    theme_bw()

# Save the figure as a PDF
ggsave(
    "results/pound_hill_histograms.pdf",
    plot = p,
    width = 12,
    height = 5
)

# Summarise species abundance by cultivation treatment
SummaryTable <- aggregate(
    cbind(
        Records = rep(1, nrow(MyPlotData)),  # Count all records
        Zero_counts = as.integer(MyPlotData$Count == 0),  # Count zero records
        Total_individuals = MyPlotData$Count  # Sum all individuals
    ),
    by = list(Cultivation = MyPlotData$Cultivation),
    FUN = sum
)

# Calculate the percentage of zero-count records
SummaryTable$Zero_percentage <- round(
    SummaryTable$Zero_counts / SummaryTable$Records * 100,
    1
)

# Save the summary table
write.csv(
    SummaryTable,
    "results/pound_hill_summary.csv",
    row.names = FALSE
)

print(SummaryTable)

# The histograms show strongly right-skewed species counts across all three cultivation treatments, with many zero-count records and few observations containing large numbers of individuals.
# These distributions alone do not establish whether cultivation treatment causes differences in species abundance.