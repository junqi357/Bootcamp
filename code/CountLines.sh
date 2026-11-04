#!/bin/bash

if [[ $# -ne 1 ]]; then
    printf 'Usage: bash code/CountLines.sh INPUT_FILE\n' >&2
    exit 2
fi

if [[ ! -f "$1" || ! -r "$1" ]]; then
    printf 'Error: input must be a readable regular file: %s\n' "$1" >&2
    exit 1
fi

if NumLines=$(wc -l < "$1"); then
    printf 'The file %s has %s lines\n' "$1" "$NumLines"
else
    printf 'Error: could not count lines in %s\n' "$1" >&2
    exit 1
fi