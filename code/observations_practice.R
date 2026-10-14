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