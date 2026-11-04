# Project Organisation

This repository contains Assignments 1–3 and classroom practice scripts from the MQB Computing Bootcamp.

- `code/` contains the Unix command answers, shell scripts, Python scripts, R scripts and tests for 3 of the previous weeks' assignments and classroom exercises.
- `data/` contains the input files needed to run and check the scripts.
- `results/` stores generated tables and figures. Scripts create this directory when needed, and its contents are excluded from Git.
- `week1/` contains retained material from the first week's classroom exercises and environment setup.
- `git-practice/` contains retained material from the introductory Git exercises.
- `week1/requirements-coursework.txt` records the Python package versions saved during the environment setup exercise.
- `README.md` describes the project, software requirements, script usage, checks and revisions.
- `.gitignore` excludes generated results and temporary files from version control.

The following sections provide instructions for Assignments 1–3 and the classroom practice scripts.



# Software Requirements

The scripts were developed on Ubuntu using Bash, Python and R. Run commands from the repository root unless a specific instruction states otherwise.

- Python 3.10 or later. The Python scripts use standard-library modules. IPython is used for the interactive debugging exercise.
- R 4.5.2 was used for the R scripts. Additional packages are `reshape2`, `tidyr` and `ggplot2`.
- Bash and Unix utilities, including `awk`, `basename`, `cat`, `cmp`, `convert`, `expr`, `grep`, `mkdir`, `printf`, `tail`, `tr` and `wc`. The `convert` command is supplied by ImageMagick and is required by `tiff2_png.sh`.
- An interactive R environment with data-viewer, graphics and help support is used for `r_setup_check.R`. VS Code was used for editing and interactive work.

Install the additional R packages from an R session with:

    install.packages(c("reshape2", "tidyr", "ggplot2"))

`week1/requirements-coursework.txt` records the Python package versions saved during the classroom environment setup exercise. It preserves that environment snapshot; the dependencies needed for the scripts and interactive checks are described above.




# Week 1 Assignment 1: Unix, Shell and Git

## Directories

- `README.md` – Project organisation, assignment instructions, code explanations and test documentation.
- `.gitignore` – Excludes generated outputs and temporary files from Git tracking.
- `code/unixPrac1.txt` – FASTA commands and explanations.
- `code/tabtocsv.sh` – TSV to CSV converter.
- `code/csvtospace.sh` – CSV to space-separated converter.
- `data/fasta/` – Required FASTA input files.
- `data/temperatures/` – Required temperature input files.
- `data/tab-example.tsv` – Additional test input.


## Files and purpose

'code/unixPrac1.txt' contains the one line commands for five FASTA questions.
'#1' to '#5' are used to identify the questions. Other comments starting with '#' are used to explain how the commands work (Users should only copy the command lines when running them).
The questions cover file line counts, displaying the sequence, sequence length, ATGC occurrences and the AT/GC ratio.
Question 5 uses awk to calculate (A+T)/(G+C) from uppercase canonical-base counts. Ambiguous symbols are excluded. The supplied sequence has a nonzero GC count; a zero GC count would make the ratio undefined.

'code/tabtocsv.sh' converts tabs to commas. 
'code/csvtospace.sh' converts commas to spaces. 
Besides their main purpose, both scripts check the number of arguments and whether the input is a readable regular file while running. 
They preserve empty fields, report errors with a nonzero exit status, and show the output path when successful.

week1/ and git-practice/ contain retained classroom practice material. Assignment 1 files are located in the root-level code/ and data/ directories.

## How to run

Users need Bash and the following tools: tail, grep, wc, awk, tr, mkdir, basename and printf, for testing cmp will also be used. 
For the FASTA answers, enter code/ and run the five command lines in unixPrac1.txt individually. 
Lines starting with # are comments and do not need to be copied.
To run both converter scripts from the repository root, use:

    bash code/tabtocsv.sh data/tab-example.tsv
    bash code/csvtospace.sh data/temperatures/1800.csv

The first command converts tabs in the input file to commas and creates results/tab-example.tsv.csv. 
The second converts commas to spaces and creates results/1800.csv.txt. 
Users can replace 1800.csv with 1801.csv, 1802.csv or 1803.csv to convert the other temperature files. Empty fields are kept as repeated separators.

Both scripts leave the input unchanged and create the results directory if needed. 
Running again replaces the corresponding output rather than adding duplicate rows. 
Inputs with the same filename write to the same output file. 

## Tests carried out

Both scripts passed syntax checks using 'bash -n'. 
Tests covered valid input, missing and extra arguments, nonexistent files, directory inputs, paths containing spaces, empty fields, repeated runs and output write failures. 
Valid conversions produced the expected content, while errors returned a nonzero exit status without reporting success.

The self-created input 'data/tab-example.tsv' was used to test complete and empty fields, its output kept the empty count field as 'pine,,south'. 
All four temperature files were converted, and their inputs were compared with copies made before running using 'cmp'. 
All four comparisons showed that the inputs were unchanged.

## Revisions Following Formative Feedback

Both converter scripts were updated to write to 'results/' when run from the repository root, replacing the previous '../results/' paths. The README commands and output paths were updated accordingly. The existing argument and file checks were retained.

The revised scripts were checked from a fresh checkout without an existing 'results/' directory. Checks covered conversion results, empty fields, unchanged input files, repeated runs and error handling. The README also clarified the assumptions behind the existing FASTA ratio calculation and identified retained classroom practice material.

## Limitations

These scripts only replace characters but however do not handle quoting or escaping. 
Commas inside quoted fields would also be replaced, and space-separated output cannot clearly distinguish spaces within fields. 
Run the converter scripts from the repository root. Their output paths are relative to the current working directory.
They check that the input is a readable regular file, but do not check whether its contents follow CSV or TSV format.




# Week 2 Assignment 2: Tree-survey Practical in Python

## Workflow Purpose

This workflow will turn the supplied raw tree-survey records into validated, consistently formatted data for reuse in Assignment 3 in R. Using the supplied metadata, the program will apply permitted text cleaning, check required values, measurements and duplicate identifiers, and separate accepted records from rejected rows. It will preserve the raw input and produce three reproducible CSV outputs: cleaned records, rejected-row reports with all applicable reasons, and counts of accepted oaks by species.

## Planned Algorithm

The program will begin by reading the tree records from 'data/silwood_trees_raw.csv', using 'data/silwood_trees_metadata.md' as the reference for validation rules and output formats.

After checking the CSV column names, the program will create two empty lists. One will store accepted records, and the other will store rejected records and their reasons. A set will store the record numbers ('record_id') of accepted records.

The program will process each record in input order and note its row number, counting the header as row 1. After applying the permitted text cleaning, it will check required values, record number formats, locations, genus–species combinations and numeric measurements against the metadata rules. It will also check whether an accepted record already uses the same record number. Any problems found will be recorded as rejection reasons in the required order.

When a record passes every check, the program will save its cleaned values and add its record number to the set. When a record is rejected, the program will save its row number in the original CSV, its record number with surrounding spaces removed, and all rejection reasons. A later valid record can still use the same record number as a rejected record.

The accepted records will be sorted by 'record_id', and rejected records will be listed in their original row order. The oak summary will count accepted records whose genus is exactly Quercus, with the counts grouped and sorted by species.

Finally, the program will create 'results/' if needed and write three CSV files: 'silwood_trees_clean.csv' for accepted records, 'silwood_tree_issues.csv' for rejected records and their reasons, and 'oak_species_counts.csv' for oak counts. These files will use the column order and formats specified in the metadata. Each run will replace earlier output files, while keeping the original input file unchanged.

## Directories

- `README.md` – Project organisation, assignment instructions, code explanations and test documentation.
- `.gitignore` – Excludes generated outputs and temporary files from Git tracking.
- `code/clean_silwood_trees.py` – Tree-survey cleaning program.
- `code/test_silwood_trees.py` – Tests for the cleaning program.
- `data/silwood_trees_raw.csv` – Original tree-survey data.
- `data/silwood_trees_metadata.md` – Validation rules and output requirements.

## How to Run

Use Python 3.10 or later to run both scripts from the project root. Start with python3 code/test_silwood_trees.py to check that the functions give the expected results. Then run python3 code/clean_silwood_trees.py to process the original tree records and save the three output files in results/. Running it again will replace the previous output files.

The workflow was also tested in a fresh clone of the GitHub repository. Both Python scripts ran successfully from the repository root, and the three expected CSV files were generated in 'results/'.

## How the Code Works

The provided 'clean_silwood_trees.py' already includes the code for reading the CSV, writing the output files and running the workflow. The three added functions handle the tree records. First, 'validate_record()' checks one record at a time. It removes surrounding spaces, puts recognised names into their standard form, and checks required values, the record number, location, genus–species combination, distance and angle using the metadata rules. It returns either the cleaned record or all the reasons for rejecting it. Next, process_records() calls validate_record() for each row and separates accepted records from rejected records. It keeps track of accepted record numbers to find duplicates, saves the row numbers and reasons for rejected records, and also sorts accepted records by 'record_id'. Finally, 'summarise_oaks()' counts accepted records whose genus is exactly Quercus and returns the counts sorted by species.

The test script, 'test_silwood_trees.py', imports these functions and gives them small records with expected answers. Each test calls a function and uses assert to compare its result with the expected result. These checks cover valid records, text cleaning, missing and unrecognised values, incorrect genus–species pairs, numeric limits, duplicate record numbers and multiple rejection reasons. They also check oak counts, a name close to Quercus, cases with no oaks, sorting and repeated processing. The tests also check that incorrect CSV column names are rejected. The last two tests use temporary folders to check that importing the module starts no workflow, and that running the complete script twice produces identical files while keeping the input unchanged. The complete workflow test also checks the output column names, record counts and oak species counts against the supplied data.

A combined workflow test checks how record processing connects to oak summarisation. It passes one valid oak record and one invalid oak record to 'process_records()', then checks that the valid record is accepted and the invalid record is reported with the correct reason. The accepted records are then passed to 'summarise_oaks()' to confirm that the rejected oak does not contribute to the species count.

The tests use individual assertions, with comments describing the input conditions and expected results for each case. When an assertion fails, its line number identifies the relevant test, and the accompanying comments explain the behaviour being checked. This structure keeps the test cases easy to inspect and understand.

## Test Example

Finding out how the 'test_silwood_trees.py' works, for example, one test starts with a valid tree record and changes distance_m to "0". It then calls 'validate_record()' and checks that the record is rejected with the reason "distance_m out of range". This checks the lower distance limit in the metadata, which requires a value greater than zero. If the condition were written as 0 <= number <= 100, the script would still run, but it would accept zero. The test would catch this mistake because the returned result would differ from the expected answer.

## Revisions Following Formative Feedback

A combined test was added to 'test_silwood_trees.py' to make the connection between record processing and oak summarisation explicit. It passes one valid oak record and one oak record with zero distance to 'process_records()', checks the accepted record and rejection reason, then passes the accepted records to 'summarise_oaks()'. The expected count confirms that the rejected oak contributes nothing to the summary.

The README was updated to explain this test and the existing assertion-based checks. The test script and cleaning workflow were run from the root of a fresh GitHub clone. Both completed successfully, and the three expected CSV output files were generated.

## Sources

The code uses methods covered in MQB’s Biological Computing in Python, especially “Structuring Python programs”, “Handling CSV files” and “From doctest to a separate test script”. The supplied tree-survey Python file provides the starting structure, and the metadata defines the validation rules. ChatGPT helped to brainstorm about code usage, what can be tested in the 'test_silwood_trees.py' and also used to fix some errors.

## Limitations

This workflow is designed for the small survey provided, so it reads the whole CSV into memory before checking the records. As the file gets larger, this approach needs more memory. To handle much larger surveys, the code could be changed to read and check one record at a time.




# Week 3: Tree Heights and Pound Hill Analysis

## Directories

- `code/TreeHeight.R` – Calculates tree heights from the supplied tree data.
- `code/get_TreeHeight.R` – Runs the same calculation using a CSV path supplied in the command.
- `code/run_get_TreeHeight.sh` – Checks both tree-height routes, saved output values, repeatability and invalid-input handling.
- `code/pound_hill_analysis.R` – Calculates and plots mean quadrat species richness for each plot, and compares richness with abundance.
- `data/trees.csv` – Original tree measurements.
- `data/pound_hill_data.csv` – Original Pound Hill plant counts and sampling labels.
- `data/pound_hill_meta_data.csv` – Descriptions of the Pound Hill fields and the meaning of blank counts.

## How the Code Works

“trees.csv” contains the species, horizontal distance and angle for each tree, which “TreeHeight.R” uses to calculate height. After reading the data, the code checks that the required columns are present and that distances and angles are finite numbers within the allowed ranges. “TreeHeight()” then converts the angles to radians and calculates height by multiplying distance by the tangent of the angle. The results are added as “height_m” and saved to “results/TreeHts.csv”, keeping the original records in order.

Building on this, “get_TreeHeight.R” takes the input path from the run command, allowing the same checks and calculation to be used with other CSV files containing the same three columns. The output is named after the input file, so “trees.csv” produces “trees_treeheights.csv” under “results/” directory. Both scripts use the same input checks and tree-height formula. "TreeHeight.R" uses a fixed input and output path, while "get_TreeHeight.R" obtains the input path from a command-line argument and builds the output filename from its basename.

The calculation is checked through "run_get_TreeHeight.sh", which runs both the fixed-path and generalised scripts on the supplied data and also tests the generalised script with an independently predictable measurement of 8 m at 45 degrees. The checks compare output columns, row counts, original measurements and every calculated height. Both routes are rerun to confirm consistent replacement. Invalid calls are tested in isolated temporary directories, where the exit status, expected diagnostic and absence of result files are checked.

“pound_hill_data.csv” contains sampling labels and species counts in a wide table, so “pound_hill_analysis.R” first transposes the data and reshapes it into long form. Each row then holds the count of one species in one quadrat. The accompanying “pound_hill_meta_data.csv” explains that blank counts represent observed absences, which supports converting them to zeros during this step. The code then checks that counts are finite, non-negative numbers and uses the full sampling labels to identify distinct quadrats and plots.

The reshaped data is used to count species with a positive count in each quadrat, giving “Richness”. These values are then averaged within each plot to give “MeanRichness”. Since the number of sampled quadrats varies among plots, this gives each plot equal weight in the treatment comparison. The summary is saved to “results/pound_hill_plot_richness.csv” and shown in a scatter plot grouped by cultivation treatment, saved to “results/pound_hill_plot_richness.pdf”. Each point represents one plot’s mean quadrat richness, making differences within and among treatments visible.

The same approach is also used for abundance, starting with the total number of individual plants in each quadrat and then averaging these totals within each plot. Finally, the code calculates treatment averages for both richness and abundance and prints them in the terminal, allowing the patterns in species numbers and plant numbers to be compared.

Comments divide the R scripts into stages covering input, validation, calculation and output, and explain key decisions such as converting observed absences to zeros and averaging richness within plots. In "run_get_TreeHeight.sh", comments group checks by purpose, including output content, repeated execution and missing-argument handling. These labels help connect a failed check to the behaviour being tested.

## Running Scripts and Expected Results

All commands are run from the repository root. The tree-height scripts use base R, while the Pound Hill analysis also requires “tidyr” and “ggplot2” to be installed.

“TreeHeight.R” is run with the following command:
`Rscript code/TreeHeight.R`

Running "Rscript code/TreeHeight.R" produced "results/TreeHts.csv" with 120 records and the required four columns. Comparing the original three columns with "data/trees.csv" confirmed that the measurements and row order were preserved. The first record, Populus tremula, has a horizontal distance of 31.66583 m and an angle of 41.28264 degrees. Calculating its height separately using "distance * tan(angle * pi / 180)" gave approximately 27.80212 m, matching the saved result.

The general version takes an input path when it runs, so the command for the supplied data is:
`Rscript code/get_TreeHeight.R data/trees.csv`

This run should save the same calculated results to “results/trees_treeheights.csv”. Its checks are brought together in the Shell script:
`bash code/run_get_TreeHeight.sh`

Running "bash code/run_get_TreeHeight.sh" checked the saved measurements and all heights from both tree-height routes, the 8 m toy case and repeatability of both routes. A missing-argument call was checked for the expected usage diagnostic. Both routes were also tested with a zero-distance measurement, confirming the intended distance-range diagnostic and the absence of result files. All checks passed, and the script displayed “All tree-height script checks passed.”

Additional command-line checks confirmed that extra arguments, a missing input file and an incorrect header each produced an informative error and a nonzero exit status.

The Pound Hill analysis is run with:
`Rscript code/pound_hill_analysis.R`

The run should create “results/pound_hill_plot_richness.csv” and “results/pound_hill_plot_richness.pdf”. The CSV should contain “Cultivation”, “Block”, “Plot” and “MeanRichness”, with one row for each of the 12 plots. Checks confirmed 41 species, 59 quadrats and 12 plots, with each plot appearing once in the summary. The analysis was run twice using separate "Rscript" calls. Comparing the two saved CSV files with "cmp" confirmed identical contents. The regenerated PDF was opened and checked against the table for treatment labels, plot values and readable axis labels.

For October cultivation, block a, plot 1, quadrat richness was recalculated separately using "tapply()" with unused factor levels removed by "droplevels()". The five sampled quadrats had richness values of 7, 8, 7, 5 and 8, giving a mean of 7, which matched "MeanRichness" in the plot summary.

The PDF should show each plot’s mean quadrat richness as one point, allowing the three cultivation treatments to be compared. May has the highest typical richness, and plot values vary within every treatment. The abundance comparison printed in the terminal also shows the highest plant numbers in October, illustrating how richness and abundance describe different aspects of the vegetation.

The four Week 3 commands above were also run from the root of a newly cloned repository. All completed successfully, and the generated tree-height tables and Pound Hill table and figure were inspected.

## Revisions Following Formative Feedback

The Shell checks were extended to verify the fixed-path tree-height output and repeatability separately. Invalid-input checks now verify the expected diagnostic and the absence of result files. The revised checks completed successfully. The Pound Hill figure was regenerated with neutral points, a descriptive title and a caption, then visually compared with the saved CSV to confirm that the plotted values matched the summary.

## Sources

The “TreeHeight()” function comes from “An example utility function” in MQB. Input validation, command-line arguments and the Shell check script were added following the two tree-height practicals. For Pound Hill, the import and reshaping steps reuse the transpose, blank-to-zero conversion and “pivot_longer()” code from earlier classroom scripts. Richness and abundance summaries, plotting and interpretation were then added following the current practical.

The debugging techniques introduced this week were used to check the R scripts and investigate errors. Further checks used assertions and comparisons of saved outputs to verify the results. 

ChatGPT was used to brainstorm ways to make the scatter plot clearer and more visually appealing, while the final plotting code was written manually. ChatGPT also helped refine some wording and correct grammar in the README.

## Limitations

“get_TreeHeight.R” uses the input filename to name its output. If files in different folders have the same name, they will share an output path, so a later run may overwrite a result that is still needed. For Pound Hill, the observed differences in richness may be related to cultivation timing, while assessing this relationship requires more information about treatment assignment, block layout and plot independence.




# Classroom Practice Scripts

The classroom scripts cover shell scripting, Python programming, R programming and data handling. The tables below describe each script's purpose, how to run or check it, and its expected behaviour.

Run commands from the repository root. Interactive examples require additional input as described below. Generated files are saved under `results/`.

## Shell Scripts

These examples use Bash and standard Unix utilities. The image conversion script also requires ImageMagick's `convert` command. Run all commands from the repository root.

| Script | Purpose | Running and checking |
| --- | --- | --- |
| `variables.sh` | Demonstrates variables, command-line arguments, interactive input and integer addition. | Run `bash code/variables.sh oak pine`. Enter `hello` at the first prompt, then `3 4` at the second. Check that the script reports two arguments, displays the entered string and prints a sum of 7. |
| `MyExampleScript.sh` | Uses variables to construct a greeting. | Run `bash code/MyExampleScript.sh`. Check that it prints `Hello` followed by the current username from `$USER`. |
| `boilerplate.sh` | Provides a basic shell script template with descriptive header comments. | Run `bash code/boilerplate.sh`. Check that it prints `This is a shell script!` and exits with status 0. |
| `CheckLabel.sh` | Uses conditionals to validate a species label. | Run `bash code/CheckLabel.sh oak` and repeat with `pine`. Both should print the selected species. Repeat with `birch`, then with no argument: the exit statuses should be 1 and 2 respectively. |
| `CountLines.sh` | Counts newline characters in an input file. | Run `bash code/CountLines.sh data/bootcamp_observations.csv`. Compare the reported count with `wc -l < data/bootcamp_observations.csv`. Calls with no argument or a nonexistent input path should report an error and return a nonzero status. |
| `ConcatenateTwoFiles.sh` | Combines two files in the supplied order using redirection and appending. | Run `bash code/ConcatenateTwoFiles.sh data/temperatures/1800.csv data/temperatures/1801.csv results/combined_temperatures.csv`. Inspect the output to confirm that it contains the first file followed by the second, including both headers. Missing arguments or an output path equal to an input path should produce an error. |
| `tiff2_png.sh` | Uses a loop to convert TIFF images to PNG. | Run `bash code/tiff2_png.sh`. Each `data/*.tif` input produces a PNG with the same basename under `results/`. Open `results/test_image.png` and compare it with `data/test_image.tif`; both should show the same 100 × 100 image. |

Run `echo $?` immediately after a command to inspect its exit status. Successful commands should return 0. For scripts that create files, repeat the command and compare the regenerated output with the first result.

## Python Scripts

Run these scripts with Python 3 from the repository root. IPython is used for the interactive debugging example.

| Script | Purpose | Running and checking |
| --- | --- | --- |
| `loops.py` | Demonstrates iteration over ranges and lists, cumulative addition and a while loop. | Run `python3 code/loops.py`. Check the initial sequence 0–4, the list elements and cumulative totals ending at 1234. The final loop prints 1–100. |
| `cfexercises1.py` | Demonstrates numerical functions, conditionals and three factorial implementations. | Run `python3 code/cfexercises1.py`. The examples should return 4, 5, `[1, 2, 3]` and three factorial results of 120. Internal assertions also check factorials of 0 and 1. Successful completion prints `Function checks passed.` |
| `cfexercises2.py` | Combines conditionals, for loops, while loops and break statements. | Run `python3 code/cfexercises2.py`. The first five examples should print `hello` 4, 4, 14, 5 and 8 times respectively. The final example prints `hello!` with numbers 0–5. |
| `MyExampleScript.py` | Demonstrates defining and calling a function. | Run `python3 code/MyExampleScript.py`. The call `foo(2)` should print 4. |
| `boilerplate.py` | Demonstrates a main function and a guarded program entry point. | Run `python3 code/boilerplate.py`; it should print `This is a boilerplate`. Check import behaviour with `PYTHONPATH=code python3 -c "import boilerplate"`; the import should complete silently. |
| `using_name.py` | Demonstrates how `__name__` differs between direct execution and import. | Run `python3 code/using_name.py`; it should report `__main__`. Then run `PYTHONPATH=code python3 -c "import using_name; print(using_name.module_name())"`; it should print `using_name`. |
| `sysargv.py` | Reads command-line arguments using `sys.argv`. | Run `python3 code/sysargv.py oak pine`. Check that it reports the script path, two arguments and `['oak', 'pine']`. Repeat without arguments and check that the count is 0. |
| `control_flow.py` | Provides functions for parity, divisors, prime numbers and counting values above a threshold. | Run `python3 code/control_flow.py`. Check the even/odd descriptions, largest divisor 5, prime result for 59 and primes `[2, 3, 5, 7, 11, 13, 17, 19]`. Run its separate tests as described below. |
| `test_control_flow.py` | Checks ordinary, boundary and invalid inputs for the control-flow functions. | Run `python3 code/test_control_flow.py` and `python3 -m doctest -v code/control_flow.py`. The assertion script should complete silently with status 0, and the three doctest examples should pass. |
| `observations_practice.py` | Validates observation records, removes exact duplicates and summarises known and missing counts by site. | Run `python3 code/observations_practice.py`. It reads `data/bootcamp_observations.csv` and should print `A (2, 1)` and `B (0, 0)`. |
| `test_observations_practice.py` | Tests observation summaries, missing values, zeros, duplicates, invalid records and input preservation. | Run `python3 code/test_observations_practice.py`. It reads the ordinary, boundary and invalid observations CSV files under `data/`. Successful completion is silent with status 0. |
| `debugme.py` | Provides an intentional division-by-zero error for debugger practice. | Start `ipython`, run `%run code/debugme.py`, then enter `%debug` after the error. Inspect `i` and `y`: the failing iteration should have `i = 19` and `y = 0`. Enter `q` to leave the debugger and `exit` to leave IPython. |

The error in `debugme.py` is intentional. The debugging check identifies how repeated subtraction makes the denominator zero. For the assertion-based test scripts, a failed assertion stops execution and identifies the relevant line.

## R Scripts

Run batch examples with `Rscript` from the repository root. The data-wrangling scripts require `reshape2` and `tidyr` respectively. Use an interactive R session for inspecting returned objects and working through `browse.R`.

| Script | Purpose | Running and checking |
| --- | --- | --- |
| `basic_io.R` | Demonstrates reading tables, changing import options, writing files and appending rows. | Run `Rscript code/basic_io.R`. It reads `data/trees.csv` and writes `results/MyData.csv`. The append example intentionally produces a column-name warning. The final write replaces the file with a space-separated table containing row names and no column header. Check it with `read.table("results/MyData.csv", header = FALSE, row.names = 1)` in R; it should contain 120 rows and three data columns. |
| `boilerplate.R` | Demonstrates function arguments, object classes and return values. | In R, run `source("code/boilerplate.R")`, then `MyFunction(1, 2)` and `MyFunction("riki", "Tiki")`. Check the reported argument classes and returned vectors. `class(MyFunction)` should return `"function"`. |
| `control_flow.R` | Demonstrates if statements, for loops and a while loop. | Run `Rscript code/control_flow.R`. Check the conditional messages, squares from 1 to 100, species names and vector elements. The final while loop should also print squares from 1 to 100. The message controlled by `runif(1)` can vary between runs. |
| `r_conditionals.R` | Demonstrates conditional functions, default arguments, rounding, powers of two and prime-number checks. | In R, run `source("code/r_conditionals.R")`. Check `is.even(7)`, `is.even.default()`, `report_height(12.345)` and `is.power2(4)`. Expected results include an odd-number description, an even-number description, 12.35 and a power-of-two description. Check `is.prime(0)`, `is.prime(1)`, `is.prime(2)` and `is.prime(4)` for the zero, unit, prime and composite cases. |
| `break.R` | Demonstrates leaving a while loop with `break`. | Run `Rscript code/break.R`. It should print values of `i` from 0 to 9 and stop when the counter reaches 10. |
| `next.R` | Demonstrates skipping selected loop iterations with `next`. | Run `Rscript code/next.R`. It should print only 1, 3, 5, 7 and 9. |
| `try.R` | Demonstrates catching sampling errors while continuing repeated calculations. | Run `Rscript code/try.R`. It creates `results/try_population.pdf`. Some resamples intentionally produce a “too few unique values” error, which `try()` catches. In R, use `source("code/try.R")` and check `length(result)`: all 15 iterations should be represented. |
| `browse.R` | Demonstrates inspecting an exponential-growth calculation at a breakpoint. | Start R and run `source("code/browse.R")`. At the first `Browse[1]>` prompt, inspect `t` and `N[1:2]`; they should show 2 and approximately `1, 2.718282`. Enter `c` at each breakpoint until the normal `>` prompt returns. Open `results/browse_exponential.pdf` and check the increasing growth curve. |
| `observations_practice.R` | Imports and validates observations, summarises sites and plots known totals. | Run `Rscript code/observations_practice.R`. It reads the ordinary, boundary and invalid observations CSV files under `data/`. Internal checks cover A: total 2, one missing; B: total 0, none missing; C: total `NA`, two missing; D: total 0, none missing. Open `results/observations_known_totals.pdf` and check these known totals and the explanation for site C. |
| `data_wrang.R` | Reshapes the Pound Hill data using the legacy `reshape2` approach. | Run `Rscript code/data_wrang.R`. It reads `data/pound_hill_data.csv` and `data/pound_hill_meta_data.csv`, then writes `results/pound_hill_long.csv`. Check that the saved table has 2419 rows and the columns `Cultivation`, `Block`, `Plot`, `Quadrat`, `Species` and `Count`. |
| `data_wrang_tidy.R` | Performs the Pound Hill reshaping using `tidyr::pivot_longer()`. | Run `Rscript code/data_wrang_tidy.R`. It reads the same Pound Hill inputs and writes `results/pound_hill_long_tidy.csv`. Check for 2419 rows and the same six columns. Compare its records with the legacy output after sorting both tables by the sampling labels and species. |

For interactive checks, start R from the repository root with `R --vanilla`. Enter the expressions shown above at the R prompt.

In `browse.R`, `c` continues execution until the next `browser()` call, so the prompt reappears during successive loop iterations. The normal `>` prompt indicates that the script has finished. The checks described above inspect the first calculated value and the completed figure.

For scripts that create tables or figures, rerun them and compare the saved values or plotted content. `try.R` sets a random seed so its sampling example can be repeated.

## Additional Classroom Examples

These files retain further classroom examples and practice based on MQB topics. Run commands from the repository root. Use an interactive R session for the setup and debugging exercises.

| Script | Purpose | Running and checking |
| --- | --- | --- |
| `practice.py` | Demonstrates a range with a specified start, stop and step. | Run `python3 code/practice.py`. Check that it prints 2, 4, 6 and 8. |
| `example.py` | Demonstrates a function with an executable doctest example in its docstring. | Run `python3 -m doctest -v code/example.py`. The test should confirm that `square(4)` returns 16. |
| `r_basics.R` | Collects examples of R operators, types, vectors, indexing, data frames, matrices and lists. | In R, run `source("code/r_basics.R", echo = TRUE)` to display the expressions and their results. Check examples such as `plants[2, 1]`, which returns `"Birch"`, and `MyList$species[1]`, which returns `"Quercus robur"`. Random values produced by `runif()` vary between runs. |
| `debugging.R` | Demonstrates tracing errors through nested functions and debugging a function with an undefined variable. | In a fresh R session, run `source("code/debugging.R")`. The expected error identifies undefined object `d`. Immediately run `traceback()` and inspect the calls through `outer_function`, `middle_function` and `inner_function`. For the second example, run the `buggy_function` definition from the editor separately, then enter `debug(buggy_function)` and `buggy_function(10)`. Inspect `n`, step with `n`, and use `Q` to leave the debugger. |
| `pred_prey_overlay.R` | Converts prey mass units and overlays predator and prey mass distributions. | Run `Rscript code/pred_prey_overlay.R`. It reads `data/ecol_archives_e_089_51_d_1.csv` and creates `results/Pred_Prey_Overlay.pdf`. Inspect the red predator and blue prey histograms and their legend. The plotted values use natural-log-transformed masses. |
| `pound_hill_plot.R` | Explores species counts across cultivation treatments using histograms and a summary table. | First run `Rscript code/data_wrang_tidy.R`, then `Rscript code/pound_hill_plot.R`. The plotting script reads `results/pound_hill_long_tidy.csv` and requires `ggplot2`. Check `results/pound_hill_histograms.pdf` for March, May and October panels with shared axes. Inspect `results/pound_hill_summary.csv` for record counts, zero counts, total individuals and zero percentages for each treatment. |
| `r_setup_check.R` | Checks the R editor integration, data viewer, plotting, help system and installation paths. | Run the file line by line in an interactive R environment with a data viewer and graphics support. Check that `View(df)` opens `mtcars`, `plot(cars)` displays a scatter plot and `?mean` opens help. Inspect `R.home()`, `.libPaths()` and `Sys.which("R")` for the installation and library locations. |

The errors in `debugging.R` are intentional teaching examples. The first error stops `source()` before the second function definition, so the second example is run separately from the editor.




# Sources and AI Assistance

The classroom practice scripts follow examples and exercises from the MQB chapters on Shell scripting, Biological Computing in Python, Biological Computing in R, and Data Management and Visualization in R, together with the tooling and environment setup appendices. Assignment-specific sources are described in the corresponding sections above.

ChatGPT was used to clarify some of the meaning and behaviour of commands, investigate errors and suggest corrections. Some code was revised based on this assistance. The revised code was then run and checked to confirm that it worked as intended and that the errors being addressed were resolved. Intentional errors and interactive breakpoints retained for debugging practice are explained in the script instructions.




# Final Clean-Clone Check

The portfolio was checked on 4 November 2026 using a fresh GitHub clone, updated to commit `d428753` after correcting the control-flow script placement and README details. The README instructions were followed from the repository root, including the stated directory change for the FASTA commands.

Checks covered Assignments 1–3, all 30 required classroom scripts and the additional classroom examples. The Python tests, doctests and tree-height checks passed. Output checks confirmed 24 accepted and 12 rejected tree-survey records, four oaks of each species, 120 tree-height records and 12 Pound Hill plot summaries. Repeated runs produced identical checked CSV outputs.

Generated figures were visually inspected. Interactive checks covered shell input, Python debugging, R breakpoints and traceback examples, and the R data viewer, plotting and help interface. Intentional teaching errors behaved as documented. The checked working tree remained clean, with generated results excluded from Git.