"""Testing the Silwood tree-survey cleaning rules by small records."""

from clean_silwood_trees import (
    validate_record,
    process_records,
    summarise_oaks,
)

import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


# Give validate_record() a complete, valid tree record.
# Check that it returns the expected cleaned record and an empty error list.
record = {
    "record_id": "ST001",
    "location": "Silwood Bottom",
    "genus": "Quercus",
    "species": "robur",
    "distance_m": "12.5",
    "angle_degrees": "35",
}

cleaned, reasons = validate_record(record, 2, set())

assert reasons == []
assert cleaned == {
    "record_id": "ST001",
    "location": "Silwood Bottom",
    "genus": "Quercus",
    "species": "robur",
    "distance_m": "12.5",
    "angle_degrees": "35.0",
}


# Add spaces and change the case of the location, genus and species.
# Check that the result matches the cleaned record from the first test.
messy_record = {
    "record_id": " ST001 ",
    "location": " silwood bottom ",
    "genus": " QUERCUS ",
    "species": " ROBUR ",
    "distance_m": " 12.5 ",
    "angle_degrees": " 35 ",
}

cleaned_messy, messy_reasons = validate_record(
    messy_record, 2, set()
)

assert messy_reasons == []
assert cleaned_messy == cleaned


# Replace each required value with a space, one field at a time.
# Check that validate_record() rejects it and names the missing field.
for field in record:
    missing_record = record.copy()
    missing_record[field] = " "

    cleaned_missing, missing_reasons = validate_record(
        missing_record, 2, set()
    )

    assert cleaned_missing is None
    assert missing_reasons == [f"missing {field}"]


# Give validate_record() an incorrect record number or an unrecognised name.
# Check that it rejects each record and returns the expected reason.
invalid_values = {
    "record_id": "st001",
    "location": "Unknown Wood",
    "genus": "Quercuss",
    "species": "roburr",
}

for field, value in invalid_values.items():
    invalid_record = record.copy()
    invalid_record[field] = value

    cleaned_invalid, invalid_reasons = validate_record(
        invalid_record, 2, set()
    )

    assert cleaned_invalid is None
    assert invalid_reasons == [f"invalid {field}"]


# Change the species to pendula while keeping Quercus as the genus.
# Check that validate_record() rejects this pairing and gives the combination reason.
wrong_pair = record.copy()
wrong_pair["species"] = "pendula"

cleaned_pair, pair_reasons = validate_record(
    wrong_pair, 2, set()
)

assert cleaned_pair is None
assert pair_reasons == ["invalid genus/species combination"]


# Try valid distances and angles, including the allowed distance limit.
# Check that each record is accepted and its number is saved correctly.
valid_numbers = {
    "distance_m": ["0.1", "100"],
    "angle_degrees": ["0.1", "89.9"],
}

for field, values in valid_numbers.items():
    for value in values:
        test_record = record.copy()
        test_record[field] = value

        result, reasons = validate_record(test_record, 2, set())

        assert reasons == []
        assert result is not None
        assert result[field] == str(float(value))


# Give each measurement text that cannot represent a valid finite number.
# Check that the record is rejected with only the invalid-number reason.
for field in ("distance_m", "angle_degrees"):
    for value in ("abc", "nan", "inf", "-inf"):
        test_record = record.copy()
        test_record[field] = value

        result, reasons = validate_record(test_record, 2, set())

        assert result is None
        assert reasons == [f"invalid {field}"]


# Try numbers outside the allowed ranges, including excluded endpoints.
# Check that each record is rejected with the correct range reason.
out_of_range = {
    "distance_m": ["-1", "0", "100.1"],
    "angle_degrees": ["-1", "0", "90", "91"],
}

for field, values in out_of_range.items():
    for value in values:
        test_record = record.copy()
        test_record[field] = value

        result, reasons = validate_record(test_record, 2, set())

        assert result is None
        assert reasons == [f"{field} out of range"]


# Give process_records() two valid records with the same number.
# Check that it accepts the first and reports the second as a duplicate.
accepted, issues = process_records([record.copy(), record.copy()])

assert accepted == [cleaned]
assert issues == [{
    "source_row": "3",
    "record_id": "ST001",
    "reasons": "duplicate record_id",
}]


# Put an invalid record before a valid record with the same number.
# Check that the rejected record leaves the number available for the valid one.
bad_record = record.copy()
bad_record["distance_m"] = "0"

accepted, issues = process_records([bad_record, record.copy()])

assert accepted == [cleaned]
assert issues == [{
    "source_row": "2",
    "record_id": "ST001",
    "reasons": "distance_m out of range",
}]


# Give validate_record() a record with several problems.
# Check that it returns every reason in the order required by the metadata.
several_problems = record.copy()
several_problems.update({
    "location": "Unknown Wood",
    "genus": "",
    "species": "",
    "distance_m": "abc",
    "angle_degrees": "",
})

result, reasons = validate_record(several_problems, 2, set())

assert result is None
assert reasons == [
    "invalid location",
    "missing genus",
    "missing species",
    "invalid distance_m",
    "missing angle_degrees",
]


# Pass the same record through process_records().
# Check that its report includes the row number and correctly joined reasons.
accepted, issues = process_records([several_problems])

assert accepted == []
assert issues == [{
    "source_row": "2",
    "record_id": "ST001",
    "reasons": (
        "invalid location; missing genus; missing species; "
        "invalid distance_m; missing angle_degrees"
    ),
}]


# Give summarise_oaks() two robur records, one petraea and one Acer.
# Check that it counts only the oaks and sorts the species names.
petraea_record = cleaned.copy()
petraea_record["record_id"] = "ST002"
petraea_record["species"] = "petraea"

second_robur = cleaned.copy()
second_robur["record_id"] = "ST003"

acer_record = cleaned.copy()
acer_record["record_id"] = "ST004"
acer_record["genus"] = "Acer"
acer_record["species"] = "pseudoplatanus"

oak_counts = summarise_oaks([
    cleaned.copy(),
    petraea_record,
    second_robur,
    acer_record,
])

assert oak_counts == [
    {"species": "petraea", "count": "1"},
    {"species": "robur", "count": "2"},
]


# Try Quercuss, which is close to Quercus but has an extra letter.
# Check that validation rejects it and the summary counts only exact Quercus.
near_match = record.copy()
near_match["genus"] = "Quercuss"

result, reasons = validate_record(near_match, 2, set())

assert result is None
assert reasons == ["invalid genus"]
assert summarise_oaks([cleaned.copy(), near_match]) == [
    {"species": "robur", "count": "1"},
]


# Give the summary an accepted Acer record, then an empty list.
# Both should return an empty list because there are no accepted oaks.
assert summarise_oaks([acer_record]) == []
assert summarise_oaks([]) == []


# Give process_records() valid records in reverse record-number order.
# Check that it returns them sorted and reports no rejected records.
unsorted_records = [
    second_robur.copy(),
    petraea_record.copy(),
    cleaned.copy(),
]

accepted, issues = process_records(unsorted_records)

assert accepted == [
    cleaned,
    petraea_record,
    second_robur,
]
assert issues == []


# Process the same input twice, including a duplicate and an invalid record.
# Check that both runs return the same records, reports and oak counts.
repeat_records = [
    second_robur.copy(),
    several_problems.copy(),
    petraea_record.copy(),
    cleaned.copy(),
    cleaned.copy(),
]

first_clean, first_issues = process_records(repeat_records)
second_clean, second_issues = process_records(repeat_records)

assert first_clean == second_clean
assert first_issues == second_issues
assert summarise_oaks(first_clean) == summarise_oaks(second_clean)

assert len(first_clean) == 3
assert [issue["source_row"] for issue in first_issues] == ["3", "6"]


# Copy the module into a temporary project with no input data.
# Import it in a fresh Python process and check that it prints nothing
# and creates no results folder.
with tempfile.TemporaryDirectory() as temporary_directory:
    temporary_root = Path(temporary_directory)
    temporary_code = temporary_root / "code"
    temporary_code.mkdir()

    source_module = Path(__file__).resolve().parent / "clean_silwood_trees.py"
    shutil.copy2(source_module, temporary_code / "clean_silwood_trees.py")

    imported = subprocess.run(
        [
            sys.executable,
            "-B",
            "-c",
            "import clean_silwood_trees",
        ],
        cwd=temporary_code,
        capture_output=True,
        text=True,
    )

    assert imported.returncode == 0, imported.stderr
    assert imported.stdout == ""
    assert imported.stderr == ""
    assert not (temporary_root / "results").exists()


# Run the complete script twice in a temporary project.
# Check that all three output files stay identical and the input stays unchanged.
with tempfile.TemporaryDirectory() as temporary_directory:
    temporary_root = Path(temporary_directory)
    temporary_code = temporary_root / "code"
    temporary_data = temporary_root / "data"
    temporary_code.mkdir()
    temporary_data.mkdir()

    project_root = Path(__file__).resolve().parents[1]

    temporary_script = temporary_code / "clean_silwood_trees.py"
    temporary_input = temporary_data / "silwood_trees_raw.csv"

    shutil.copy2(
        project_root / "code" / "clean_silwood_trees.py",
        temporary_script,
    )
    shutil.copy2(
        project_root / "data" / "silwood_trees_raw.csv",
        temporary_input,
    )

    original_input = temporary_input.read_bytes()

    first_run = subprocess.run(
        [sys.executable, str(temporary_script)],
        cwd=temporary_root,
        capture_output=True,
        text=True,
    )
    assert first_run.returncode == 0, first_run.stderr

    output_names = [
        "silwood_trees_clean.csv",
        "silwood_tree_issues.csv",
        "oak_species_counts.csv",
    ]

    first_outputs = {}
    for name in output_names:
        output_path = temporary_root / "results" / name
        assert output_path.is_file()
        first_outputs[name] = output_path.read_bytes()

    second_run = subprocess.run(
        [sys.executable, str(temporary_script)],
        cwd=temporary_root,
        capture_output=True,
        text=True,
    )
    assert second_run.returncode == 0, second_run.stderr

    for name in output_names:
        output_path = temporary_root / "results" / name
        assert output_path.read_bytes() == first_outputs[name]

    assert temporary_input.read_bytes() == original_input