#!/usr/bin/env Rscript
# Deterministic behavioural fingerprint for themakR.
#
# Loads the package, enumerates its exported objects, exercises the public
# API on fixed inputs, and reduces the whole observation to a single sha256
# digest. Running this before and after a behaviour-preserving change (e.g.
# adding tests) must yield an IDENTICAL digest. Dev-only: depends on
# {digest}, which is not a package dependency.

suppressMessages(devtools::load_all(quiet = TRUE))

# --- Exported surface (sorted for determinism) ------------------------------
exports <- sort(getNamespaceExports("themakR"))

# --- Behavioural probes on fixed inputs -------------------------------------
probe <- list(
  exports        = exports,
  tk_demo_1_10   = tk_demo(1:10),
  tk_demo_scalar = tk_demo(42),
  tk_demo_neg    = tk_demo(c(-5, 5)),
  tk_demo_frac   = tk_demo(c(1.5, 2.5, 3.5)),
  tk_demo_logical = tk_demo(c(TRUE, FALSE, TRUE, TRUE)),
  tk_demo_na     = tk_demo(c(1, 2, NA)),
  tk_demo_empty  = tk_demo(numeric(0)),
  tk_demo_formals = names(formals(tk_demo))
)

# --- Shipped pkgdown template assets (paths relative to inst) ----------------
inst_files <- sort(
  list.files(system.file("pkgdown", package = "themakR"), recursive = TRUE)
)
probe$pkgdown_assets <- inst_files

digest_value <- digest::digest(probe, algo = "sha256")

cat("themakR behavioural fingerprint\n")
cat("exports:", paste(exports, collapse = ", "), "\n")
cat("pkgdown assets:", length(inst_files), "files\n")
cat("sha256:", digest_value, "\n")
