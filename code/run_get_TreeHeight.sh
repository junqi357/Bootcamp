#!/bin/bash
# Run from the coursework repository root.
set -eu

mkdir -p sandbox

# Create a separate toy dataset.
cat > sandbox/test_trees.csv <<'EOF'
Species,Distance.m,Angle.degrees
Test species,8,45
EOF

# Check the fixed and generalised routes separately.
Rscript code/TreeHeight.R
Rscript code/get_TreeHeight.R data/trees.csv
Rscript code/get_TreeHeight.R sandbox/test_trees.csv

# Check headers, row counts, original records and heights.
Rscript - <<'EOF'
check_output <- function(input_path, output_path) {
  input <- read.csv(input_path)
  output <- read.csv(output_path)

  stopifnot(
    "Output must contain the required four columns" =
      identical(
        names(output),
        c("Species", "Distance.m", "Angle.degrees", "height_m")
      ),
    "Output row count must match the input" =
      nrow(output) == nrow(input),
    "Original measurements and row order must be preserved" =
      isTRUE(all.equal(output[, 1:3], input))
  )

  expected <- input$Distance.m *
    tan(input$Angle.degrees * pi / 180)

  stopifnot(
    "Every saved height must match the expected calculation" =
      isTRUE(all.equal(
        output$height_m,
        expected,
        tolerance = 1e-8
      ))
  )
}

check_output("data/trees.csv", "results/TreeHts.csv")
check_output("data/trees.csv", "results/trees_treeheights.csv")
check_output("sandbox/test_trees.csv", "results/test_trees_treeheights.csv")

toy <- read.csv("results/test_trees_treeheights.csv")
stopifnot(isTRUE(all.equal(toy$height_m, 8, tolerance = 1e-8)))
EOF

# Confirm that rerunning the fixed route replaces the same result.
cp results/TreeHts.csv sandbox/TreeHts_before.csv
Rscript code/TreeHeight.R
cmp sandbox/TreeHts_before.csv results/TreeHts.csv

# Run again and compare against the previous result.
cp results/test_trees_treeheights.csv sandbox/test_trees_before.csv
Rscript code/get_TreeHeight.R sandbox/test_trees.csv
cmp sandbox/test_trees_before.csv results/test_trees_treeheights.csv

# Use isolated folders so earlier results cannot hide an unexpected output.
project_root=$(pwd)
test_root=$(mktemp -d "$project_root/sandbox/treeheight_checks.XXXXXX")
trap 'rm -rf "$test_root"' EXIT

# Check the exit status, intended diagnostic and absence of result files.
expect_failure() {
  case_dir=$1
  expected_message=$2
  shift 2

  mkdir -p "$case_dir/results"

  if (cd "$case_dir" && "$@") > "$case_dir/diagnostic.log" 2>&1; then
    echo "FAIL: an invalid call completed successfully."
    exit 1
  fi

  if ! grep -Fq "$expected_message" "$case_dir/diagnostic.log"; then
    echo "FAIL: the expected diagnostic was missing."
    cat "$case_dir/diagnostic.log"
    exit 1
  fi

  if [ -n "$(find "$case_dir/results" -type f -print)" ]; then
    echo "FAIL: an invalid call wrote a result file."
    exit 1
  fi
}

# Missing arguments must stop for the intended usage error.
expect_failure \
  "$test_root/missing_argument" \
  "Usage: Rscript code/get_TreeHeight.R <input.csv>" \
  Rscript "$project_root/code/get_TreeHeight.R"

# Zero distance is outside the permitted measurement range.
fixed_case="$test_root/fixed_invalid_distance"
mkdir -p "$fixed_case/data"

cat > "$fixed_case/data/trees.csv" <<'EOF'
Species,Distance.m,Angle.degrees
Test species,0,45
EOF

expect_failure \
  "$fixed_case" \
  "Distance.m must contain finite values greater than 0 and at most 100." \
  Rscript "$project_root/code/TreeHeight.R"

general_case="$test_root/general_invalid_distance"
mkdir -p "$general_case/data"
cp "$fixed_case/data/trees.csv" "$general_case/data/trees.csv"

expect_failure \
  "$general_case" \
  "Distance.m must contain finite values greater than 0 and at most 100." \
  Rscript "$project_root/code/get_TreeHeight.R" data/trees.csv

echo "All tree-height script checks passed."