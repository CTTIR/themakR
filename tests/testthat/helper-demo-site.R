# A minimal consumer package whose site is built with the shipped template.
# The site is built once per test run; every test that needs it calls
# demo_site(), which skips where a site cannot be built.

demo_site_cache <- new.env(parent = emptyenv())

demo_site_source <- function(path) {
  dir.create(file.path(path, "man", "figures"), recursive = TRUE)
  # An existing favicon folder keeps pkgdown from requesting generated icons.
  dir.create(file.path(path, "pkgdown", "favicon"), recursive = TRUE)
  writeLines("", file.path(path, "pkgdown", "favicon", "favicon.ico"))
  writeLines(c(
    "Package: demoPkg",
    "Title: Demo Consumer of the Shared Template",
    "Version: 0.0.1",
    paste0(
      "Authors@R: person('A.', 'Tester', email = 'a@example.org', ",
      "role = c('aut', 'cre'))"
    ),
    "Description: A minimal package used to build a site with the template.",
    "License: MIT + file LICENSE",
    "Encoding: UTF-8"
  ), file.path(path, "DESCRIPTION"))
  writeLines(
    c("YEAR: 2026", "COPYRIGHT HOLDER: A. Tester"),
    file.path(path, "LICENSE")
  )
  writeLines(
    c("# demoPkg", "", "Linked code: [`mean()`](https://example.org/mean)."),
    file.path(path, "README.md")
  )
  writeLines(
    c("# demoPkg 0.0.1", "", "* First version."),
    file.path(path, "NEWS.md")
  )
  svg <- paste0(
    "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"10\" height=\"10\">",
    "<rect width=\"10\" height=\"10\"/></svg>"
  )
  writeLines(svg, file.path(path, "man", "figures", "logo.svg"))
  writeLines(svg, file.path(path, "man", "figures", "logo-dark.svg"))
  # System fonts keep the build offline; the shared config asks for web fonts.
  writeLines(c(
    "template:",
    "  package: themakR",
    "  bslib:",
    "    base_font: sans-serif",
    "    heading_font: sans-serif",
    "    code_font: monospace"
  ), file.path(path, "_pkgdown.yml"))
  invisible(path)
}

demo_site <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_not_installed("pkgdown", "2.1.0")
  testthat::skip_if_not_installed("rmarkdown")
  testthat::skip_if_not_installed("withr")
  testthat::skip_if_not(
    rmarkdown::pandoc_available("2.0"),
    "pandoc is needed to build a site"
  )
  if (!is.null(demo_site_cache$site)) {
    return(demo_site_cache$site)
  }

  root <- withr::local_tempdir(
    pattern = "themakR-demo-",
    .local_envir = testthat::teardown_env()
  )
  src <- demo_site_source(file.path(root, "demoPkg"))
  withr::local_options(pkgdown.internet = FALSE)
  suppressMessages({
    pkg <- pkgdown::as_pkgdown(src)
    pkgdown::init_site(pkg)
    pkgdown::build_home(pkg, preview = FALSE)
    # A page one level down, built with the footer wording override.
    worded <- pkgdown::as_pkgdown(src, override = list(
      template = list(params = list(part_of = "the demo collection"))
    ))
    pkgdown::build_news(worded, preview = FALSE)
  })

  read_page <- function(...) {
    paste(readLines(file.path(pkg$dst_path, ...), warn = FALSE),
          collapse = "\n")
  }
  css <- list.files(
    file.path(pkg$dst_path, "deps"), "^bootstrap[.]min[.]css$",
    recursive = TRUE, full.names = TRUE
  )
  demo_site_cache$site <- list(
    pkg = pkg,
    home = read_page("index.html"),
    news = read_page("news", "index.html"),
    css = paste(readLines(css[[1L]], warn = FALSE), collapse = "\n")
  )
  demo_site_cache$site
}
