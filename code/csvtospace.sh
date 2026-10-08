#!/bin/bash
# Script: csvtospace.sh
# Description: Convert commas to spaces.
# Argument: One CSV input file.

if [[ $# -ne 1 ]]; then
    printf 'Usage: bash csvtospace.sh INPUT_FILE\n' >&2
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

mkdir -p ../results
output_file="../results/$(basename "$1").txt"

if tr ',' ' ' < "$1" > "$output_file"; then
    printf 'Done! Output: %s\n' "$output_file"
else
    printf 'Error: conversion failed.\n' >&2
    exit 1
fi

