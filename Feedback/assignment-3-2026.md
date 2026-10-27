# Assignment 3 formative feedback

This feedback is organised using the [Computing Bootcamp rubric](https://mulquabio.github.io/MQB/rubrics/Computing_Bootcamp_Rubric.html). It does not award a mark; use it to decide what to revise and check before final submission.

## Criterion 1: Repository organisation & workflow discipline

Before final submission, check that the required scripts are under `code/`, supplied inputs are under `data/`, and generated files remain outside Git.

## Criterion 2: Code completeness & functional correctness

- Both tree-height routes ran successfully in the checks run for this feedback. Separately, output comparisons found that `results/TreeHts.csv` and `results/trees_treeheights.csv` satisfied the tree-height required output format and values. Your code shows the degree-to-radian conversion, measurement validation and preservation of input order.
- Before final submission, **Keep the fixed and generalised routes separately reproducible.** Your Shell checks exercise `get_TreeHeight.R`, not the fixed-path program. Both worked in this review, but later edits could affect only one. Include a short repeatable check for `TreeHeight.R`, comparing its saved measurements and heights with the input and a direct calculation.

## Criterion 3: Code quality & style

As you revise, keep names descriptive, use comments to explain decisions rather than restating code, and avoid repeating the same calculation in several places.

## Criterion 4: Documentation

- Your checking connects measurements to saved results: the Shell script checks original columns, every calculated height and repeatability, and includes a simple independently predictable case. Your README also documents a separate calculation for a supplied tree; this is useful evidence of your checking approach, beyond successful execution alone.

## Criterion 5: Version-control practice

- Required paths are present, supplied inputs match the supplied files, and no generated results are tracked. The root README explains dependencies, commands and limitations; your Git history contains descriptive commits. When I opened the figure, I found readable axes and visible plot-level points.

## Criterion 8: Basic error-handling & input validation

- Before final submission, **Make invalid-input checks verify the intended reason for stopping.** The invalid-distance runs halted with a useful distance-range error and the expected no-output behaviour. However, your Shell script’s missing-argument test accepts any unsuccessful exit; an unrelated error could therefore look like successful validation. Add a small check of the captured diagnostic and confirm that no new result was written. The captured usage message is consistent with the deliberate missing-argument test, rather than evidence that the ordinary generalised run failed.

## Criterion 9: Problem-solving approach & method implementation

- The Pound Hill table had the expected rows, plot identifiers and richness values. The code uses complete sampling identifiers, counts species present within quadrats and then averages within plots. Your interpretation distinguishes richness from abundance and avoids claiming that cultivation caused the observed differences. The README documents an independent plot-level calculation, although that calculation was not separately rerun here.
- Before final submission, **Polish the figure’s presentation.** The PDF exists; automated presence checking alone does not validate its biological meaning. When I reviewed the figure, I found that treatment colours duplicate horizontal position and that there is no title. Consider a neutral point colour and a short descriptive title or caption, then compare the regenerated points with the CSV. These are presentation refinements, not evidence that the numerical table is wrong.

## Criterion 10: Learning progression demonstration

Use this feedback as a revision checklist. Make the changes in small, descriptive commits, then add a short README note explaining what you changed and how you checked it. This will make your development from this formative checkpoint visible in the final portfolio.

## Priorities before final submission

- Run from the directory containing `code/`, `data/` and the root `README.md`. Before the cumulative submission, rerun one ordinary and one invalid case for each tree-height route, then regenerate and visually inspect the Pound Hill outputs. Record the commands and observed outcomes, distinguishing these from checks merely described in the README.
