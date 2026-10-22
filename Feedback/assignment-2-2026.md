# Assignment 2 formative feedback

This feedback is organised by the relevant computing bootcamp criteria. Use it to decide what is already working, what you need to investigate, and what to revise before the cumulative submission.

The full criteria are in the [Computing Bootcamp assessment rubric](https://github.com/MulQuaBio/MQB/blob/main/content/rubrics/Computing_Bootcamp_Rubric.md).

## 1. Repository organisation and workflow discipline

- Your root README, `.gitignore`, cleaning script, test script and supplied data files are in the expected locations. The supplied CSV and metadata are unchanged, giving you a reproducible starting point.

## 2. Code completeness and functional correctness

- The cleaning workflow completed. Separately, output checks report that all three output tables satisfy the requirements in both test runs. The outputs are correct for the checked input; now make sure you can explain the method and test important edge cases.

## 3. Code quality and style

- Your `main()` function gives the program a clear overall structure by connecting loading, processing, summarising and writing. Keep these stages distinct as you revise; use descriptive names and add short comments where the reason for a validation check or data-cleaning step is not obvious.

## 4. Documentation

- Your root README is in place. Make it useful to someone opening the repository for the first time: explain what the cleaner does, how to run the script and tests from the repository root, and which three files it creates. Test the instructions in a newly cloned copy of your repository (a separate folder created with `git clone`): enter that folder and run each README command exactly as written. If something fails, correct the command or add the missing step.

## 5. Version-control practice

- Since the previous formative feedback was added, the saved history contains 9 non-merge commits. Your recent messages describe what scripts do and what was tested, which is useful evidence of your reasoning. Several commit subjects are full paragraphs, however, so the main change is difficult to spot quickly.
- Keep the first line concise—for example, `Add end-to-end checks for tree-height output`—and put the longer explanation in the commit body. Use `git diff --staged` first so the summary matches the exact change.

## 8. Basic error handling and input validation

- Your separate test file is present and ran successfully. Your test file includes assertion-based checks covering record validation, accepted/rejected partitioning, oak summaries and end-to-end execution.
- **Make test coverage easy to inspect.** Your tests currently use top-level assertions rather than named test functions. Consider grouping related assertions into clearly labelled sections or small named functions, so a failure points to the behaviour being checked. Verify that the end-to-end checks assert output content as well as successful execution: the runner recorded the test script’s exit status but did not independently check its output content.
- Run the separate tests and cleaning workflow using the README commands. Review the assertions behind one validation case, one partition case and one oak-summary case, including an appropriate invalid or boundary input.

## 9. Problem-solving approach and method implementation

- Your code shows a connected workflow: `main()` calls `load_records()` to read the unchanged supplied CSV, then `process_records()` uses `validate_record()` and returns `(clean_records, issues)`. The cleaned records feed `summarise_oaks()`, and three `write_csv()` calls produce the outputs. The route from input to outputs is clear.
- Before final submission, make this check visible in your repository. In `code/test_silwood_trees.py`, add or refine a small assertion-based test with one valid and one invalid record. Check that `process_records()` places them in the cleaned and issues collections respectively. Then pass the returned cleaned collection to `summarise_oaks()` and check that the invalid record does not contribute. Briefly explain this flow in your root README.
