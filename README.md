# Week 1 Assignment 1: Unix, Shell and Git

## Files and purpose

'code/unixPrac1.txt' contains the one line commands for five FASTA questions.
'#1' to '#5' are used to identify the questions. Other comments starting with '#' are used to explain how the commands work (Users should only copy the command lines when running them).
The questions cover file line counts, displaying the sequence, sequence length, ATGC occurrences and the AT/GC ratio.

'code/tabtocsv.sh' converts tabs to commas. 
'code/csvtospace.sh' converts commas to spaces. 
Besides their main purpose, both scripts check the number of arguments and whether the input is a readable regular file while running. 
They preserve empty fields, report errors with a nonzero exit status, and show the output path when successful.

## How to run

Users need Bash and the following tools: tail, grep, wc, awk, tr, mkdir, basename and printf, for testing cmp will also be used. 
From the project root, users should enter the code directory with 'cd code', then run the five command lines in unixPrac1.txt individually in the terminal. 
Lines starting with # are comments and do not need to be copied.

To run the converters, use:

    bash tabtocsv.sh ../data/tab-example.tsv
    bash csvtospace.sh ../data/temperatures/1800.csv

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
Users should run the scripts from code/ because they use relative paths. 
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


## How to Run
Use Python 3.10 or later to run both scripts from the project root. Start with python3 code/test_silwood_trees.py to check that the functions give the expected results. Then run python3 code/clean_silwood_trees.py to process the original tree records and save the three output files in results/. Running it again will replace the previous output files.

## How the Code Works
The provided 'clean_silwood_trees'.py already includes the code for reading the CSV, writing the output files and running the workflow. The three added functions handle the tree records. First, 'validate_record()' checks one record at a time. It removes surrounding spaces, puts recognised names into their standard form, and checks required values, the record number, location, genus–species combination, distance and angle using the metadata rules. It returns either the cleaned record or all the reasons for rejecting it. Next, 'process_records()' function calls for each row and separates accepted records from rejected records. It keeps track of accepted record numbers to find duplicates, saves the row numbers and reasons for rejected records, and also sorts accepted records by 'record_id'. Finally, 'summarise_oaks()' counts accepted records whose genus is exactly Quercus and returns the counts sorted by species.

The test script, 'test_silwood_trees.py', imports these functions and gives them small records with expected answers. Each test calls a function and uses assert to compare its result with the expected result. These checks cover valid records, text cleaning, missing and unrecognised values, incorrect genus–species pairs, numeric limits, duplicate record numbers and multiple rejection reasons. They also check oak counts, a name close to Quercus, cases with no oaks, sorting and repeated processing. The last two tests use temporary folders to check that importing the module starts no workflow, and that running the complete script twice produces identical files while keeping the input unchanged.

## Test Example
Finding out how the 'test_silwood_trees.py' works, for example, one test starts with a valid tree record and changes distance_m to "0". It then calls 'validate_record()' and checks that the record is rejected with the reason "distance_m out of range". This checks the lower distance limit in the metadata, which requires a value greater than zero. If the condition were written as 0 <= number <= 100, the script would still run, but it would accept zero. The test would catch this mistake because the returned result would differ from the expected answer.

## Sources
The code uses methods covered in MQB’s Biological Computing in Python, especially “Structuring Python programs”, “Handling CSV files” and “From doctest to a separate test script”. The supplied tree-survey Python file provides the starting structure, and the metadata defines the validation rules. ChatGPT helped to brainstorm about code usage, what can be tested in the 'test_silwood_trees.py' and also used to fix some errors.

## Limitations
This workflow is designed for the small survey provided, so it reads the whole CSV into memory before checking the records. As the file gets larger, this approach needs more memory. To handle much larger surveys, the code could be changed to read and check one record at a time.

