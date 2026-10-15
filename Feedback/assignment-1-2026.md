# Assignment 1 feedback - Junqi Cao

**Formative feedback | Rubric 2026.2**

The FASTA explanations are clear about what is being counted: positions including ambiguity symbols, literal motif occurrences and the ratio of canonical-base counts. All five answers matched the independent checks. Your own TSV, test account and results/sandbox ignore rules also make the work easier to reproduce.

The main correction is the converter starting directory. Both scripts have useful argument, file, readability and conversion-status checks, but ../results assumes they are run from code/. The released interface is repository-root execution. Fix that path convention in both scripts and update the README examples together.

Then repeat the tests you have already documented, this time from a fresh checkout and without an existing results directory. Keep the empty-field and input-preservation checks: they test something about the data, not just whether a command ran. Record the corrected output paths and actual observations so the test account describes the revised scripts.

There is no need to replace the valid awk ratio simply because another solution might use bc. Explain its assumptions and list the tools actually used. Keep later Python/R material separate from the Assignment 1 instructions, retain the task-specific help account and make commit subjects describe the change rather than only its date. This is a focused interface correction, not a reason to rewrite the otherwise useful work.

---

## Project structure

Relevant tracked layout (simplified; missing required paths are marked):

```text
README.md
.gitignore
code/  unixPrac1.txt, tabtocsv.sh, csvtospace.sh
data/fasta/  3 required files present
data/temperatures/  4 required files present
data/tab-example.tsv
results/  no files tracked; generated on run
sandbox/  no files tracked; optional
Also: week1/
Also: git-practice/
```

All required Assignment 1 files are in the root layout, and results/sandbox are ignored with no tracked files there. Additional week1/ and git-practice/ directories contain practice material; the assessed scripts are not stranded inside them.

Keep the assessed root layout. Label the practice directories clearly in the README so they are not mistaken for alternative submission roots, and retain useful classwork. The structural change needed is in the converter paths and run instructions, not a wholesale move of files that are already correctly placed.

**Assessed snapshot:** `8c40482145e6ee09ab9d5838c921a3bd6e7f38ac`
