#!/bin/bash

if [[ $# -ne 3 ]]; then
    printf 'Usage: bash code/ConcatenateTwoFiles.sh INPUT1 INPUT2 OUTPUT\n' >&2
    exit 2
fi

for input_file in "$1" "$2"
do
    if [[ ! -f "$input_file" || ! -r "$input_file" ]]; then
        printf 'Error: input must be a readable regular file: %s\n' "$input_file" >&2
        exit 1
    fi
done

# Protect both inputs from being overwritten.
if [[ "$3" -ef "$1" || "$3" -ef "$2" ]]; then
    printf 'Error: output must differ from both input files.\n' >&2
    exit 1
fi

mkdir -p results || exit 1

if cat "$1" > "$3" && cat "$2" >> "$3"; then
    printf 'Merged File is\n'
    cat "$3"
else
    printf 'Error: could not merge the files.\n' >&2
    exit 1
fi