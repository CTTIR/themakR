
<!-- README.md is generated from README.Rmd. Please edit that file. -->

# themakR <picture class="cttir-readme-logo"><source class="cttir-logo-dark-source" media="(prefers-color-scheme: dark)" srcset="man/figures/logo-with-name-dark.png" /><img src="man/figures/logo-with-name.png" align="right" alt="themakR hex logo" width="120" height="139" /></picture>

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21889968.svg)](https://doi.org/10.5281/zenodo.21889968)

<!-- badges: start -->
[![R-CMD-check](https://github.com/CTTIR/themakR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/CTTIR/themakR/actions/workflows/R-CMD-check.yaml)
[![pkgdown](https://github.com/CTTIR/themakR/actions/workflows/pkgdown.yaml/badge.svg)](https://cttir.github.io/themakR/)
[![Codecov test coverage](https://codecov.io/gh/CTTIR/themakR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/CTTIR/themakR?branch=main)
[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

themakR provides the pkgdown template for the
[CTTIR](https://cttir.github.io/website/) package suite: the Hugo Coder
palette of the suite site (light `#fafafa` / dark `#212121`, blue link
accent) with a native light/dark/auto toggle at the top right, Inter for
text, JetBrains Mono for code, the package hex at the top left, a
rotemplate-style navbar and home sidebar, and a shared suite footer.

It plays the same role for CTTIR packages that
[tidytemplate](https://github.com/tidyverse/tidytemplate) plays for the
tidyverse and [rotemplate](https://docs.ropensci.org/rotemplate/) for
rOpenSci: it is not a general-purpose theme and is not on CRAN — it
installs from GitHub and exists so the family of sites looks like a
family.

## Installation

``` r
# install.packages("pak")
pak::pak("CTTIR/themakR")
```

## Usage

In the adopting package’s `DESCRIPTION`:

    Config/Needs/website: CTTIR/themakR

In its `_pkgdown.yml`:

``` yaml
template:
  package: themakR
development:
  mode: auto
```

Then `pkgdown::build_site()`. See `vignette("themakR")` for the full
adoption guide, including the per-package accent override, and
`vignette("showcase")` for a gallery of every styled element in both
colour modes.

## Citation

If you use this software, please cite it as:

> Heller, R. (2026). *themakR: Shared pkgdown theme for the CTTIR package suite* (Version 0.1.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.21889968

DOI: [10.5281/zenodo.21889968](https://doi.org/10.5281/zenodo.21889968)

## Use of LLM tools

Where applicable, LLM tools were used for narrowly defined, non-authorial tasks:
copyediting, prose refinement, Markdown/LaTeX formatting, boilerplate scaffolding
(such as CI configurations and build scripts), and code refactoring. Tools included
[Chat AI](https://kisski.gwdg.de/leistungen/2-02-llm-service/), the KISSKI
(GWDG) service, and self-hosted **Mistral Small (24B, Apache-2.0)** served through
a local **vLLM architecture** on an Ubuntu Linux workstation with Intel
processors and NVIDIA GPUs. The self-hosted model ran locally, with no data sent
to third parties.

All scientific claims, methodological choices, analyses, interpretations and
conclusions remain the authors' own. Where applicable, LLM-generated material
must be reviewed and revised before inclusion, and references must be verified
against their DOI, arXiv ID or ISBN.

Local software setup: vLLM with Python/PyTorch, plus R and RStudio.

## Branding

Editable R artwork and regeneration instructions are in [tools/branding](https://github.com/CTTIR/themakR/blob/main/tools/branding/README.md).
