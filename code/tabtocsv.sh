#!/bin/bash
# Script: tabtocsv.sh
# Description: Convert tabs to commas.
# Argument: One tab-delimited input file.

echo "Creating a comma delimited version of $1 ..."
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"
