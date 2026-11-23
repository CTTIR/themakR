# themakR 0.2.0

* Linked inline code (a Markdown link around code in backticks) keeps the link
  colour again. The inline code rule of the shared stylesheet had overridden
  pkgdown's own rule, so such links were drawn in the body colour on every
  site that uses the template.
* The navbar logo now finds its dark artwork on a site's "page not found"
  page wherever that page is served; below the site root it used to keep the
  light logo in dark mode.
* Below a width of 360 pixels the navbar no longer shows the version label.
  With a long package name the fixed navbar wrapped onto a second row there
  and covered the top of the page.
* Code blocks are easier to read. In light mode comments, the printed output
  of examples, keywords, variables and alerts are drawn in darker shades of
  the same hues; in dark mode comments and example output are drawn lighter.
  On the code surfaces of the template these colours of the highlight themes
  fell below the 4.5:1 contrast minimum of the Web Content Accessibility
  Guidelines 2.1; example output stood at 2.9:1 in dark mode. The light
  shades apply in light mode only.
* An article no longer shows the package hex twice. The branding block that
  vignettes carry for standalone HTML output is hidden where the page heading
  already shows the logo.
* The package description names the blue accent the template has used since
  0.1.0 instead of the earlier purple, and the package help page is
  regenerated from it.
* The README source carries the citation section of the rendered README, and
  the citation names the current version.
* The adoption guide explains how to link a "Get started" vignette, which the
  shared navbar does not list. The site of themakR links the guide that way.
* `DESCRIPTION` gains a `Copyright` field that points to `inst/COPYRIGHTS`,
  the notice for the light switch script adapted from pkgdown.
* The figure in the element showcase has alternative text.
* New tests build a minimal consumer site with the template and check the
  merged configuration, the compiled stylesheet, the navbar, the footer and
  pages below the site root. Further tests compare the overridden templates
  and light switch with the installed pkgdown and check that the colour
  tokens agree across the template files.
* Keep light/dark/auto controls and matching artwork usable when browser
  storage is unavailable or contains an unrecognised theme value.
* Prepare the package for CRAN: the maintainer address is now
  raban.heller@uni-ulm.de, `Language` is declared, the `Description` is
  written in full sentences, `inst/CITATION` takes the version from the
  installed package, and `cran-comments.md` is added.
* Use neutral wording in the README introduction and drop the CRAN status and
  download badges from the README source and the vignettes.

# themakR 0.1.0

* Standardize the named v5 package logo across README, documentation pages
  and available application headers, with matching light and dark artwork.
* Initial release: shared pkgdown template for the CTTIR suite.
* Hugo Coder palette (light `#fafafa`, dark `#212121`, blue link accent) with
  pkgdown's native light/dark/auto switch.
* rotemplate-style navbar (hex + brand far left, Search · Reference ·
  Articles · Changelog · GitHub · toggle on the right) and home sidebar
  (Links · License · Community · Citation · Developers · R-universe).
* Inter body/heading font, JetBrains Mono code font.
* Shared suite footer with per-package `part_of` wording override.
* Per-package accent override via `template.bslib.primary`.
