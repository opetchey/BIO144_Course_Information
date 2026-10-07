# Learning objectives

`course.yml` holds the course-level objectives (with `chapters` linking each to the chapters that build towards it).
One YAML file per unit, named after the course book chapter (e.g. `4.1-regression-part2.yml`).
These files are the single source for the learning objectives shown in the course book and
on the course information website. Edit objectives here only.

Fields per file: `unit`, `title`, `book_chapter`, `course_info_page`, `status`
(draft | reviewed | locked), `version`, `last_updated`, `stem`, `objectives`.

Fields per objective:
- `id`: stable identifier (LO<chapter>.<n>, e.g. LO4.1.3); do not renumber once locked.
- `text`: student-facing wording (Markdown allowed, e.g. backticks for R functions).
- `bloom`: one or more of remember, understand, apply, analyse, evaluate, create.
- `type`: `concept` (answered from understanding) or `analysis` (requires using R on a dataset).

The mapping of objectives to specific exam questions is confidential and is NOT kept here.
- `review_note` (optional): what needs revising before the objective is locked. All review notes were removed when the files were locked on 2026-10-06; they are archived in `original_2026/review_notes_at_locking_2026-10-06.tsv`.

**Status:** all files were locked on 2026-10-06 (version 2027.0). From now on, do not renumber or remove IDs: practicals, quizzes and the (confidential) exam map refer to them. If an objective must be added, give it the next free number in its chapter.

**Mapping to practicals and quizzes:** every quiz question and practical section in `BIO144_Practicals_WAs/Unit*.Rmd` carries a tag naming the objectives it serves (`# LO: ...` as the first line of a quiz chunk; `<!-- LO: ... -->` after a practical heading). Run `tools/lo_coverage.R` in that repository to get the objective-by-objective coverage table (`tools/lo_coverage.csv`).
- `examinable` (optional, default true): set to false for objectives that are not examined.

`original_2026/` holds the original 2026 wording, converted to this format, for reference.

Content in the "Extras" sections of the course book is not examinable, so it has no learning objectives.
