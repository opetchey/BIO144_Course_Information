# Helpers to render learning objectives from the YAML files in this folder.
# Used by the course information website and the course book.
#
# In a Quarto chunk with `#| output: asis`:
#   source("<path to>/learning_objectives/lo.R")
#   lo_callout("4.1", dir = "<path to>/learning_objectives")   # boxed list (book chapters)
#   lo_list("4.1", dir = ...)                                   # plain list (course info pages)
#   lo_list("course", dir = ...)                                # course-level objectives

lo_file <- function(chapter, dir) {
  if (chapter == "course") return(file.path(dir, "course.yml"))
  f <- list.files(dir, pattern = paste0("^", gsub(".", "\\.", chapter, fixed = TRUE), "-.*\\.ya?ml$"),
                  full.names = TRUE)
  if (length(f) != 1) stop("Expected one learning objectives file for chapter ", chapter, " in ", dir)
  f
}

lo_read <- function(chapter, dir) yaml::yaml.load(paste(readLines(lo_file(chapter, dir), encoding = "UTF-8", warn = FALSE), collapse = "\n"))

lo_md <- function(chapter, dir, show_stem = TRUE, show_ids = FALSE, show_bloom = FALSE,
                  show_status = TRUE) {
  d <- lo_read(chapter, dir)
  items <- vapply(d$objectives, function(o) {
    txt <- o$text
    if (isFALSE(o$examinable)) txt <- paste0(txt, " *(not examined)*")
    if (show_bloom && length(o$bloom)) txt <- paste0(txt, " [", paste(o$bloom, collapse = ", "), "]")
    if (show_ids) txt <- paste0("**", o$id, "** ", txt)
    txt
  }, character(1))
  out <- character()
  if (show_status && !identical(d$status, "locked"))
    out <- c(out, paste0("*Version ", d$version, " (", d$status, "): these learning objectives may still change.*"), "")
  if (show_stem) out <- c(out, d$stem, "")
  out <- c(out, paste0(seq_along(items), ". ", items))
  paste(out, collapse = "\n")
}

lo_list <- function(chapter, dir, ...) cat(lo_md(chapter, dir, ...), "\n\n")

lo_callout <- function(chapter, dir, title = "Learning objectives", collapse = FALSE, ...) {
  cat("\n::: {.callout-note", if (collapse) ' collapse="true"', "}\n", sep = "")
  cat("## ", title, "\n\n", sep = "")
  cat(lo_md(chapter, dir, ...), "\n")
  cat("\nThese learning objectives, together with the content of this chapter, define what you need to know for the exam.\n")
  cat("\nThe learning objectives for all chapters, and for the course as a whole, are also given on the [Learning Objectives page of the course information website](https://opetchey.github.io/BIO144_Course_Information/3.1-learning-objectives.html).\n")
  cat(":::\n\n")
}

# All chapter-level objectives, in book order, with a heading per chapter.
lo_all <- function(dir, heading_level = 3, ...) {
  files <- setdiff(list.files(dir, pattern = "\\.ya?ml$"), "course.yml")
  chapters <- sub("-.*$", "", files)
  ord <- order(as.numeric(sub("\\..*", "", chapters)), as.numeric(sub("^.*\\.", "", chapters)))
  major <- sub("\\..*", "", chapters)
  # Show "Chapter 4" unless a chapter number has several parts (e.g. 11.1 and 11.2)
  label <- ifelse(major %in% major[duplicated(major)], chapters, major)
  names(label) <- chapters
  for (ch in chapters[ord]) {
    d <- lo_read(ch, dir)
    cat(strrep("#", heading_level), " ", d$title, " (Chapter ", label[[ch]], ")\n\n", sep = "")
    lo_list(ch, dir, show_status = FALSE, ...)
  }
}
