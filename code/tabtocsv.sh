#!/bin/bash
# Script: tabtocsv.sh
# Description: Convert tabs to commas.
# Argument: One tab-delimited input file.

if [[ $# -ne 1 ]]; then
    printf 'Usage: bash tabtocsv.sh INPUT_FILE\n' >&2
    exit 2
fi

if [[ ! -f "$1" ]]; then
    printf 'Error: input is not a regular file: %s\n' "$1" >&2
    exit 1
fi

if [[ ! -r "$1" ]]; then
    printf 'Error: input file is not readable: %s\n' "$1" >&2
    exit 1
fi

echo "Creating a comma delimited version of $1 ..."

if tr '\t' ',' < "$1" > "$1.csv"; then
    printf 'Done!\n'
else
    printf 'Error: conversion failed.\n' >&2
    exit 1
fi

