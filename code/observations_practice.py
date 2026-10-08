import csv


def load_observations(path):
    with open(path, newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream))


def parse_count(count_text):
    if not isinstance(count_text, str):
        raise ValueError("Count must be text")
    if count_text == "":
        return None
    count = int(count_text)
    if count < 0:
        raise ValueError("Count cannot be negative")
    return count

#Input and purpose, the algorithm takes a list of observation records and a site to query. Each record contains site, date, and count. The query site decides which records are included in the final calculation.
#Data validation, checks every record before calculation. Each record must contain exactly site, date, and count, and all values must be strings. site and date cannot be empty. count can be empty for missing data, or a non-negative integer. Invalid data raises a ValueError, including records from other sites.
#Duplicate records, ignores exact duplicate records with the same site, date, and count. Different dates are treated as different records. The original input is not changed.
#Count calculation, adds known counts for the query site and counts empty values as missing records. A count of 0 is treated as a known value, not missing data.
#Return values, the function returns (known_total, missing_count). If there is at least one known count, known_total is the sum of those counts. If all counts for the site are missing, the total is None. If the input is empty or the site does not appear in the data, the result is (None, 0).
#Manual check, for site A, the first count is 2, so the total becomes 2. The B record is checked but not included. Another A record has a missing count, so missing_count becomes 1. The last A record is a duplicate and is skipped. Therefore, the expected result is (2, 1). For site B, the known count is 0 and there are no missing records, so the expected result is (0, 0).

def summarise_site(rows, site):
    if not isinstance(rows, list):
        raise ValueError("Rows must be a list")

    if not isinstance(site, str) or site == "":
        raise ValueError("Site must be non-empty text")

    seen = set()
    known_total = None
    missing_count = 0

    for row in rows:
        if not isinstance(row, dict):
            raise ValueError("Each row must be a dictionary")

        if set(row) != {"site", "date", "count"}:
            raise ValueError("Invalid fields")

        for value in row.values():
            if not isinstance(value, str):
                raise ValueError("All values must be text")

        if row["site"] == "" or row["date"] == "":
            raise ValueError("Site and date cannot be empty")

        count = parse_count(row["count"])

        record = (row["site"], row["date"], row["count"])
        if record in seen:
            continue
        seen.add(record)

        if row["site"] == site:
            if count is None:
                missing_count += 1
            else:
                if known_total is None:
                    known_total = 0
                known_total += count

    return (known_total, missing_count)

if __name__ == "__main__":
    rows = load_observations("data/bootcamp_observations.csv")
    sites = set()

    for row in rows:
        sites.add(row["site"])

    for site in sorted(sites):
        print(site, summarise_site(rows, site))