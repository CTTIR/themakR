## README URL correction (24 November 2026)

The reserved Zenodo DOI is now shown as plain text, without a DOI link or
badge. R's URL extraction confirms that the README no longer exposes the
unpublished DOI as a URL. The DOI-related findings below describe earlier
checks, before this correction; the reservation has not been published.

## Submission

This is a new submission of themakR 0.2.0.

## Test environments

* local: macOS (aarch64-apple-darwin), R 4.6.1, `R CMD check --as-cran` on
  the built tarball. All 127 test expectations passed without warnings or
  skips. The PDF manual builds with TinyTeX (TeX Live 2026). A downstream pkgdown 2.2.1 site built from the installed
  template was also checked in Chromium 151 for theme selection, keyboard
  focus, mobile navigation, and unavailable browser storage.
* GitHub Actions (r-lib/actions v2, `--as-cran`):
  macOS-latest (release), windows-latest (release),
  ubuntu-latest (devel, release, oldrel-1) and an informational
  ubuntu-latest (oldrel-3) row.

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
  Maintainer: 'R. Heller <raban.heller@uni-ulm.de>'
  New submission

  Found the following (possibly) invalid URLs:
    URL: https://doi.org/10.5281/zenodo.21889968
      From: README.md
      Status: 404

  This is the first submission of the package. The DOI is reserved at Zenodo
  and resolves once the record for this version is published.

## Notes for the CRAN team

* The package is a 'pkgdown' template: its main content is the template
  files in `inst/pkgdown`. `tk_demo()` exists so that the template's own
  reference page has documented content to render.
* The tests that build a small site with 'pkgdown', or compare the template
  overrides with the installed 'pkgdown', are skipped on CRAN. The built site
  uses system fonts and needs no network access.
