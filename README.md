# Project Organisation

The assessed assignments use the main project directories:
- `code/` contains the scripts for the assignments.
- `data/` contains the input data.
- `results/` contains generated outputs and is excluded from Git.

The `week1/` and `git-practice/` directories contain additional
class exercises and practice files. They are kept for reference
and are separate from the assessed assignment files.

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

## Sources

The code uses methods covered in MQB’s Biological Computing in Python, especially “Structuring Python programs”, “Handling CSV files” and “From doctest to a separate test script”. The supplied tree-survey Python file provides the starting structure, and the metadata defines the validation rules. ChatGPT helped to brainstorm about code usage, what can be tested in the 'test_silwood_trees.py' and also used to fix some errors.

## Limitations

This workflow is designed for the small survey provided, so it reads the whole CSV into memory before checking the records. As the file gets larger, this approach needs more memory. To handle much larger surveys, the code could be changed to read and check one record at a time.




# Week 3: Tree Heights and Pound Hill Analysis

## Directories

- `code/TreeHeight.R` – Calculates tree heights from the supplied tree data.
- `code/get_TreeHeight.R` – Runs the same calculation using a CSV path supplied in the command.
- `code/run_get_TreeHeight.sh` – Checks the command-line script using the supplied data and a small test dataset.
- `code/pound_hill_analysis.R` – Calculates and plots mean quadrat species richness for each plot, and compares richness with abundance.
- `data/trees.csv` – Original tree measurements.
- `data/pound_hill_data.csv` – Original Pound Hill plant counts and sampling labels.
- `data/pound_hill_meta_data.csv` – Descriptions of the Pound Hill fields and the meaning of blank counts.

## How the Code Works

“trees.csv” contains the species, horizontal distance and angle for each tree, which “TreeHeight.R” uses to calculate height. After reading the data, the code checks that the required columns are present and that distances and angles are finite numbers within the allowed ranges. “TreeHeight()” then converts the angles to radians and calculates height by multiplying distance by the tangent of the angle. The results are added as “height_m” and saved to “results/TreeHts.csv”, keeping the original records in order.

Building on this, “get_TreeHeight.R” takes the input path from the run command, allowing the same checks and calculation to be used with other CSV files containing the same three columns. The output is named after the input file, so “trees.csv” produces “trees_treeheights.csv” under “results/” directory. Both scripts use the same input checks and tree-height formula. "TreeHeight.R" uses a fixed input and output path, while "get_TreeHeight.R" obtains the input path from a command-line argument and builds the output filename from its basename.

The calculation is checked through “run_get_TreeHeight.sh”, which runs both the supplied data and a small test dataset. The test includes a tree measured at 8 metres and 45 degrees, with an expected height of 8 metres. The script checks the output columns, row counts, original measurements and calculated height, then repeats a run to confirm that the file is replaced consistently. It also checks that leaving out the input argument produces the expected error message.

“pound_hill_data.csv” contains sampling labels and species counts in a wide table, so “pound_hill_analysis.R” first transposes the data and reshapes it into long form. Each row then holds the count of one species in one quadrat. The accompanying “pound_hill_meta_data.csv” explains that blank counts represent observed absences, which supports converting them to zeros during this step. The code then checks that counts are finite, non-negative numbers and uses the full sampling labels to identify distinct quadrats and plots.

The reshaped data is used to count species with a positive count in each quadrat, giving “Richness”. These values are then averaged within each plot to give “MeanRichness”. Since the number of sampled quadrats varies among plots, this gives each plot equal weight in the treatment comparison. The summary is saved to “results/pound_hill_plot_richness.csv” and shown in a scatter plot grouped by cultivation treatment, saved to “results/pound_hill_plot_richness.pdf”. Each point represents one plot’s mean quadrat richness, making differences within and among treatments visible.

The same approach is also used for abundance, starting with the total number of individual plants in each quadrat and then averaging these totals within each plot. Finally, the code calculates treatment averages for both richness and abundance and prints them in the terminal, allowing the patterns in species numbers and plant numbers to be compared.

## Running Scripts and Expected Results

All commands are run from the repository root. The tree-height scripts use base R, while the Pound Hill analysis also requires “tidyr” and “ggplot2” to be installed.

“TreeHeight.R” is run with the following command:
`Rscript code/TreeHeight.R`

Running "Rscript code/TreeHeight.R" produced "results/TreeHts.csv" with 120 records and the required four columns. Comparing the original three columns with "data/trees.csv" confirmed that the measurements and row order were preserved. The first record, Populus tremula, has a horizontal distance of 31.66583 m and an angle of 41.28264 degrees. Calculating its height separately using "distance * tan(angle * pi / 180)" gave approximately 27.80212 m, matching the saved result.

The general version takes an input path when it runs, so the command for the supplied data is:
`Rscript code/get_TreeHeight.R data/trees.csv`

This run should save the same calculated results to “results/trees_treeheights.csv”. Its checks are brought together in the Shell script:
`bash code/run_get_TreeHeight.sh`

The script checks the output structure and calculations, then repeats a run to check file replacement. The test tree is measured at 8 metres and 45 degrees, giving an expected height of 8 metres. It also deliberately leaves out the input argument to check error handling, so the “Usage” message is an expected part of the process. Once all checks pass, meaning the final version completed successfully and will display “All tree-height script checks passed.”

The Pound Hill analysis is run with:
`Rscript code/pound_hill_analysis.R`

The run should create “results/pound_hill_plot_richness.csv” and “results/pound_hill_plot_richness.pdf”. The CSV should contain “Cultivation”, “Block”, “Plot” and “MeanRichness”, with one row for each of the 12 plots. Checks confirmed 41 species, 59 quadrats and 12 plots, with each plot appearing once in the summary. The analysis was run twice using separate "Rscript" calls. Comparing the two saved CSV files with "cmp" confirmed identical contents. The regenerated PDF was opened and checked against the table for treatment labels, plot values and readable axis labels.

The PDF should show each plot’s mean quadrat richness as one point, allowing the three cultivation treatments to be compared. May has the highest typical richness, and plot values vary within every treatment. The abundance comparison printed in the terminal also shows the highest plant numbers in October, illustrating how richness and abundance describe different aspects of the vegetation.

## Sources

The “TreeHeight()” function comes from “An example utility function” in MQB. Input validation, command-line arguments and the Shell check script were added following the two tree-height practicals. For Pound Hill, the import and reshaping steps reuse the transpose, blank-to-zero conversion and “pivot_longer()” code from earlier classroom scripts. Richness and abundance summaries, plotting and interpretation were then added following the current practical.

The debugging techniques introduced this week were used to check the R scripts and investigate errors. Further checks used assertions and comparisons of saved outputs to verify the results. 

ChatGPT was used to brainstorm ways to make the scatter plot clearer and more visually appealing, while the final plotting code was written manually. ChatGPT also helped refine some wording and correct grammar in the README.

## Limitations

“get_TreeHeight.R” uses the input filename to name its output. If files in different folders have the same name, they will share an output path, so a later run may overwrite a result that is still needed. For Pound Hill, the observed differences in richness may be related to cultivation timing, while assessing this relationship requires more information about treatment assignment, block layout and plot independence.