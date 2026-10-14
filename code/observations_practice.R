observations <- read.csv(
    "data/bootcamp_observations.csv",
    colClasses = "character",  # Read every column as character data
    na.strings = "",           # Treat empty fields as NA
    check.names = FALSE        # Preserve the original column names
)

str(observations)
print(observations)

read_observations <- function(path) {

    data <- read.csv(
        path,
        colClasses = "character",
        na.strings = "",
        check.names = FALSE
    )

    expected_columns <- c("site", "date", "count")

    if (!identical(names(data), expected_columns)) {  # Check exact column names and order
        stop("Invalid columns: expected site, date, count")
    }

    for (column in c("site", "date")) {               # Check both required text columns

        values <- data[[column]]

        invalid <- is.na(values) | trimws(values) == ""  # Find missing or blank values

        if (any(invalid)) {                           # Stop if any row contains invalid text
            row <- which(invalid)[1]

            stop(
                paste0(
                    basename(path),
                    ": CSV line ", row + 1,
                    ", column '", column,
                    "': missing required text"
                )
            )
        }
    }

    counts <- data$count

    for (i in seq_along(counts)) {                    # Check each count separately

        value <- counts[i]

        if (is.na(value)) {
            next                                      # Leave missing counts as NA
        }

        if (!grepl("^(0|[1-9][0-9]*)$", value)) {     # Validate non-negative integer text
            stop(
                paste0(
                    basename(path),
                    ": CSV line ", i + 1,
                    ", column 'count': found '", value,
                    "'; expected an empty field or a non-negative integer."
                )
            )
        }

        number <- suppressWarnings(as.integer(value))  # Convert a valid count to integer

        if (is.na(number)) {                          # Catch values outside the integer range
            stop(
                paste0(
                    basename(path),
                    ": CSV line ", i + 1,
                    ", column 'count': integer is outside the supported range."
                )
            )
        }
    }

    data$count <- as.integer(data$count)

    return(data)
}

summarise_observations <- function(data) {

    data <- data[!duplicated(data), ]           # Remove exact duplicate rows

    sites <- unique(data$site)                  # Get each site name once

    results <- data.frame(
        site = character(0),
        total_known = integer(0),
        missing_count = integer(0)
    )                                           # Create an empty data frame for the summary

    for (site in sites) {                       # Process each site separately

        counts <- data$count[data$site == site] # Select counts for this site

        missing_count <- sum(is.na(counts))     # Count missing observations

        if (all(is.na(counts))) {               # Check whether every count is missing
            total_known <- NA_integer_
        } else {
            total_known <- sum(counts, na.rm = TRUE)  # Sum known counts
        }

        site_result <- data.frame(
            site = site,
            total_known = total_known,
            missing_count = missing_count
        )                                       # Store the summary for the current site

        results <- rbind(results, site_result)  # Add the current site to the results
    }

    return(results)
}

# Read and summarise the ordinary observations

ordinary <- read_observations(
    "data/bootcamp_observations.csv"
)

ordinary_summary <- summarise_observations(ordinary)

print(ordinary_summary)


# Read and summarise the boundary observations

boundary <- read_observations(
    "data/bootcamp_observations_boundary.csv"
)

boundary_summary <- summarise_observations(boundary)

print(boundary_summary)

# Check the ordinary observations

stopifnot(ordinary_summary$total_known[ordinary_summary$site == "A"] == 2)
stopifnot(ordinary_summary$missing_count[ordinary_summary$site == "A"] == 1)

stopifnot(ordinary_summary$total_known[ordinary_summary$site == "B"] == 0)
stopifnot(ordinary_summary$missing_count[ordinary_summary$site == "B"] == 0)


# Check the boundary observations

stopifnot(is.na(boundary_summary$total_known[boundary_summary$site == "C"]))
stopifnot(boundary_summary$missing_count[boundary_summary$site == "C"] == 2)

stopifnot(boundary_summary$total_known[boundary_summary$site == "D"] == 0)
stopifnot(boundary_summary$missing_count[boundary_summary$site == "D"] == 0)

# Check that invalid observations produce an error

invalid_result <- tryCatch(
    read_observations("data/bootcamp_observations_invalid.csv"),
    error = function(e) e                     # Capture the error instead of stopping the script
)

stopifnot(inherits(invalid_result, "error"))  # Check that an error occurred

stopifnot(
    grepl("found '-1'", conditionMessage(invalid_result), fixed = TRUE)
)                                             # Check that the error identifies the invalid count