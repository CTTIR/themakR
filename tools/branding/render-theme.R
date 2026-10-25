# Regenerate the shared theme token partial from the versioned source bundle.
render_theme <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  script <- sub("^--file=", "", args[grepl("^--file=", args)])
  if (length(script) != 1L) stop("Run this file with Rscript.")
  branding <- dirname(normalizePath(script, winslash = "/", mustWork = TRUE))
  repository <- normalizePath(file.path(branding, "..", ".."),
                              winslash = "/", mustWork = TRUE)
  params <- commandArgs(trailingOnly = TRUE)
  if (length(params) != 1L || is.na(params) || !nzchar(params)) {
    stop("Supply an output directory or --apply.")
  }
  apply <- identical(params, "--apply")
  fonts <- c("Inter-static.ttf", "InterBold-static.ttf", "OFL.txt",
             "JetBrainsMono-Regular.ttf", "JetBrainsMono-SemiBold.ttf",
             "JetBrainsMono-OFL.txt")
  required <- c("design_tokens.csv", "write_integration.R",
                file.path("R", c("tokens.R", "palette.R")),
                file.path("fonts", fonts))
  if (!all(file.exists(file.path(branding, required)))) {
    stop("The branding source bundle is incomplete.")
  }

  core <- new.env(parent = baseenv())
  sys.source(file.path(branding, "R", "tokens.R"), envir = core)
  core$cttir_tokens <- core$cttir_load_tokens(file.path(branding, "design_tokens.csv"))
  sys.source(file.path(branding, "R", "palette.R"), envir = core)
  sys.source(file.path(branding, "write_integration.R"), envir = core)

  staging <- tempfile("cttir-theme-")
  dir.create(file.path(staging, "fonts"), recursive = TRUE)
  on.exit(unlink(staging, recursive = TRUE), add = TRUE)
  if (!all(file.copy(file.path(branding, "fonts", fonts),
                     file.path(staging, "fonts")))) {
    stop("Could not stage the source bundle fonts.")
  }
  # The supplied generator also copies standalone fonts; retain only its CSS.
  generated <- file.path(core$cttir_write_integration(staging), "cttir-tokens.css")
  output <- if (apply) file.path(repository, "inst", "pkgdown") else params
  if (apply) {
    resolved <- normalizePath(output, winslash = "/", mustWork = TRUE)
    if (!startsWith(resolved, paste0(repository, "/"))) {
      stop("The theme output directory escapes the repository.")
    }
  } else {
    dir.create(output, recursive = TRUE, showWarnings = FALSE)
  }
  target <- file.path(output, "_cttir-tokens.scss")
  link <- Sys.readlink(target)
  if (dir.exists(target) || (!is.na(link) && nzchar(link))) {
    stop("The token output must be a regular file.")
  }
  if (!file.copy(generated, target, overwrite = TRUE)) {
    stop("Could not write ", target)
  }
  message("Wrote ", normalizePath(target, winslash = "/", mustWork = TRUE))
}

render_theme()
