# Contributing to themakR

themakR is the pkgdown template for the CTTIR package suite, so changes
here affect the documentation site of every package in the family.

## Reporting problems

Please open an issue at <https://github.com/CTTIR/themakR/issues>. A
screenshot in **both light and dark mode** plus the consuming package's
`_pkgdown.yml` makes theme bugs much easier to reproduce.

## Making changes

1. Fork and clone the repository.
2. Edit the payload under `inst/pkgdown/` (shared config, templates, SCSS).
3. Rebuild the preview site and check both colour modes:

   ```r
   devtools::install(quick = TRUE)
   pkgdown::build_site()
   ```

4. Open a pull request describing what changed and include before/after
   screenshots in both modes.

## When pkgdown changes its templates

`navbar.html`, `footer.html` and `lightswitch.js` under `inst/pkgdown/BS5/`
replace pkgdown's own files. `tests/testthat/test-template-upstream.R`
compares them with the installed pkgdown and fails when a pkgdown release
changes one of them; a red check after such a release is the intended signal.
To bring the overrides back in step, compare each file with its counterpart
in `system.file("BS5", package = "pkgdown")`, carry the upstream change over
while keeping the additions of themakR, update the pkgdown version in
`inst/COPYRIGHTS`, and run the tests again.

Style fixes should go through bslib variables or `inst/pkgdown/extra.scss` —
please don't hardcode per-package values into the shared template.
