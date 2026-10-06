from observations_practice import load_observations, summarise_site

rows = load_observations("data/bootcamp_observations.csv")
assert summarise_site(rows, "A") == (2, 1)
assert summarise_site(rows, "B") == (0, 0)

boundary_rows = load_observations(
    "data/bootcamp_observations_boundary.csv"
)
assert summarise_site(boundary_rows, "C") == (None, 2)
assert summarise_site(boundary_rows, "D") == (0, 0)
assert summarise_site([], "A") == (None, 0)
assert summarise_site(rows, "Z") == (None, 0)


invalid_rows = load_observations(
    "data/bootcamp_observations_invalid.csv"
)

for row in invalid_rows:
    try:
        summarise_site([row], row["site"])
    except ValueError:
        pass
    else:
        raise AssertionError("Invalid count was accepted")

try:
    summarise_site([{"site": "A", "count": "2"}], "A")
except ValueError:
    pass
else:
    raise AssertionError("Missing date was accepted")

import copy

original_rows = copy.deepcopy(rows)
summarise_site(rows, "A")
assert rows == original_rows

new_rows = [
    {"site": "E", "date": "2026-10-03", "count": "3"},
    {"site": "E", "date": "2026-10-04", "count": "5"},
    {"site": "E", "date": "2026-10-05", "count": ""}
]

assert summarise_site(new_rows, "E") == (8, 1)