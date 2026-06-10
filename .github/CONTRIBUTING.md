# Contributing to themakR

themakR is the pkgdown template for the r-heller package suite, so changes
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

Style fixes should go through bslib variables or `inst/pkgdown/extra.scss` —
please don't hardcode per-package values into the shared template.
