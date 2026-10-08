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
