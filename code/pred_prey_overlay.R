# Load predator-prey data
MyDF <- read.csv("data/ecol_archives_e_089_51_d_1.csv")

# Convert prey mass from mg to g where needed
MyDF$Prey.mass[MyDF$Prey.mass.unit == "mg"] <-
    MyDF$Prey.mass[MyDF$Prey.mass.unit == "mg"] / 1000

# Create the results directory if necessary
dir.create("results", showWarnings = FALSE)

# Save predator-prey histogram overlay as PDF

pdf(
    "results/Pred_Prey_Overlay.pdf",
    11.7, 8.3                          # Set the PDF page width and height in inches
)

hist(
    log(MyDF$Predator.mass),
    xlab = "Body Mass (g)",
    ylab = "Count",
    col = rgb(1, 0, 0, 0.5),           # Red with 50% opacity
    main = "Predator-Prey Size Overlap"
)

hist(
    log(MyDF$Prey.mass),
    col = rgb(0, 0, 1, 0.5),           # Blue with 50% opacity
    add = TRUE                         # Overlay the prey histogram on the existing plot
)

legend(
    "topleft",                         # Place the legend at the top-left
    c("Predators", "Prey"),
    fill = c(
        rgb(1, 0, 0, 0.5),
        rgb(0, 0, 1, 0.5)
    )
)

graphics.off()                         # Close graphics devices and finish saving the PDF