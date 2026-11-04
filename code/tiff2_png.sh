#!/bin/bash

if ! command -v convert > /dev/null; then
    printf 'Error: ImageMagick convert is required.\n' >&2
    exit 1
fi

mkdir -p results || exit 1

for filename in data/*.tif
do
    if [[ ! -f "$filename" ]]; then
        printf 'Error: no .tif files found in data/.\n' >&2
        exit 1
    fi

    output_file="results/$(basename "$filename" .tif).png"

    printf 'Converting %s\n' "$filename"

    if ! convert "$filename" "$output_file"; then
        printf 'Error: conversion failed for %s\n' "$filename" >&2
        exit 1
    fi
done