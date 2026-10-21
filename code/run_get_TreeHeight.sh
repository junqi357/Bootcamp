#!/bin/bash
# Run from the coursework repository root.
set -eu

mkdir -p sandbox

# Create a separate toy dataset.
cat > sandbox/test_trees.csv <<'EOF'
Species,Distance.m,Angle.degrees
Test species,8,45
EOF

# Run with the supplied data and the toy data.
Rscript code/get_TreeHeight.R data/trees.csv
Rscript code/get_TreeHeight.R sandbox/test_trees.csv

# Check headers, row counts, original records and heights.
Rscript - <<'EOF'
check_output <- function(input_path, output_path) {
  input <- read.csv(input_path)
  output <- read.csv(output_path)

  stopifnot(identical(
    names(output),
    c("Species", "Distance.m", "Angle.degrees", "height_m")
  ))
  stopifnot(nrow(output) == nrow(input))
  stopifnot(isTRUE(all.equal(output[, 1:3], input)))

  expected <- input$Distance.m[1] *
    tan(input$Angle.degrees[1] * pi / 180)
  stopifnot(isTRUE(all.equal(
    output$height_m[1], expected, tolerance = 1e-8
  )))
}

check_output("data/trees.csv", "results/trees_treeheights.csv")
check_output("sandbox/test_trees.csv", "results/test_trees_treeheights.csv")

toy <- read.csv("results/test_trees_treeheights.csv")
stopifnot(isTRUE(all.equal(toy$height_m, 8, tolerance = 1e-8)))
EOF

# Run again and compare against the previous result.
cp results/test_trees_treeheights.csv sandbox/test_trees_before.csv
Rscript code/get_TreeHeight.R sandbox/test_trees.csv
cmp sandbox/test_trees_before.csv results/test_trees_treeheights.csv

# A missing argument should produce a failure.
if Rscript code/get_TreeHeight.R; then
  echo "FAIL: missing argument was accepted."
  exit 1
fi
echo "All tree-height script checks passed."