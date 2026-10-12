#!/usr/bin/env python3
"""Validate and clean the synthetic Silwood tree survey."""

from __future__ import annotations

import csv
from pathlib import Path
from typing import Iterable


PROJECT_ROOT = Path(__file__).resolve().parents[1]
INPUT_PATH = PROJECT_ROOT / "data" / "silwood_trees_raw.csv"
RESULTS_DIR = PROJECT_ROOT / "results"

INPUT_FIELDS = [
    "record_id",
    "location",
    "genus",
    "species",
    "distance_m",
    "angle_degrees",
]
ISSUE_FIELDS = ["source_row", "record_id", "reasons"]
OAK_COUNT_FIELDS = ["species", "count"]


def load_records(path: Path = INPUT_PATH) -> list[dict[str, str]]:
    """Load survey records and check that the published columns are present."""
    with path.open(newline="", encoding="utf-8") as source:
        reader = csv.DictReader(source)
        if reader.fieldnames != INPUT_FIELDS:
            raise ValueError(
                f"Expected columns {INPUT_FIELDS}, found {reader.fieldnames}"
            )
        return list(reader)


def validate_record(
    row: dict[str, str],
    source_row: int,
    accepted_ids: set[str],
) -> tuple[dict[str, str] | None, list[str]]:
    """Return a cleaned record or its ordered rejection reasons."""
    import math
    import re

    cleaned = {
        field: (row.get(field) or "").strip()
        for field in INPUT_FIELDS
    }
    reasons = []

    record_number = cleaned["record_id"]

    if record_number == "":
        reasons.append("missing record_id")
    else:
        if re.fullmatch(r"ST[0-9]{3}", record_number) is None:
            reasons.append("invalid record_id")
        if record_number in accepted_ids:
            reasons.append("duplicate record_id")

    permitted_values = {
        "location": [
            "Silwood Bottom",
            "Nash's Field",
            "Manor House",
            "Reactor Wood",
        ],
        "genus": [
            "Quercus", "Acer", "Betula", "Fagus", "Fraxinus",
        ],
        "species": [
            "robur", "petraea", "pseudoplatanus",
            "pendula", "sylvatica", "excelsior",
        ],
    }
    recognised = {}

    for field, values in permitted_values.items():
        value = cleaned[field]
        canonical_values = {
            item.lower(): item for item in values
        }

        if value == "":
            reasons.append(f"missing {field}")
            recognised[field] = False
        elif value.lower() in canonical_values:
            cleaned[field] = canonical_values[value.lower()]
            recognised[field] = True
        else:
            reasons.append(f"invalid {field}")
            recognised[field] = False

    permitted_pairs = {
        ("Quercus", "robur"),
        ("Quercus", "petraea"),
        ("Acer", "pseudoplatanus"),
        ("Betula", "pendula"),
        ("Fagus", "sylvatica"),
        ("Fraxinus", "excelsior"),
    }

    if recognised["genus"] and recognised["species"]:
        pair = (cleaned["genus"], cleaned["species"])
        if pair not in permitted_pairs:
            reasons.append("invalid genus/species combination")

    for field in ("distance_m", "angle_degrees"):
        value = cleaned[field]

        if value == "":
            reasons.append(f"missing {field}")
            continue

        try:
            number = float(value)
        except ValueError:
            reasons.append(f"invalid {field}")
            continue

        if not math.isfinite(number):
            reasons.append(f"invalid {field}")
            continue

        if field == "distance_m":
            in_range = 0 < number <= 100
        else:
            in_range = 0 < number < 90

        if not in_range:
            reasons.append(f"{field} out of range")
        else:
            cleaned[field] = str(number)

    if reasons:
        return None, reasons

    return cleaned, []


def process_records(
    rows: Iterable[dict[str, str]],
) -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    """Separate accepted records from rejected-row reports."""
    clean_records = []
    issues = []
    accepted_ids = set()

    for source_row, row in enumerate(rows, start=2):
        cleaned, reasons = validate_record(
            row, source_row, accepted_ids
        )

        if cleaned is not None:
            clean_records.append(cleaned)
            accepted_ids.add(cleaned["record_id"])
        else:
            issues.append({
                "source_row": str(source_row),
                "record_id": (row.get("record_id") or "").strip(),
                "reasons": "; ".join(reasons),
            })

    clean_records.sort(key=lambda record: record["record_id"])

    return clean_records, issues


def summarise_oaks(clean_records: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    """Count accepted oak records by species."""
    counts = {}

    for record in clean_records:
        if record["genus"] == "Quercus":
            species = record["species"]
            counts[species] = counts.get(species, 0) + 1

    return [
        {"species": species, "count": str(counts[species])}
        for species in sorted(counts)
    ]


def write_csv(
    path: Path,
    fieldnames: list[str],
    rows: Iterable[dict[str, str]],
) -> None:
    """Replace a CSV file with the supplied rows."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as destination:
        writer = csv.DictWriter(destination, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    """Run the complete validation workflow."""
    clean_records, issues = process_records(load_records())
    oak_counts = summarise_oaks(clean_records)

    write_csv(
        RESULTS_DIR / "silwood_trees_clean.csv",
        INPUT_FIELDS,
        clean_records,
    )
    write_csv(
        RESULTS_DIR / "silwood_tree_issues.csv",
        ISSUE_FIELDS,
        issues,
    )
    write_csv(
        RESULTS_DIR / "oak_species_counts.csv",
        OAK_COUNT_FIELDS,
        oak_counts,
    )


if __name__ == "__main__":
    main()
