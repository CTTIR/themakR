# navbar.html, footer.html and lightswitch.js replace pkgdown's own files in
# every consuming site. These tests notice when the installed pkgdown has
# moved on, so the overrides can be brought back in step.

upstream_file <- function(...) {
  system.file("BS5", ..., package = "pkgdown")
}
shipped_file <- function(...) {
  system.file("pkgdown", "BS5", ..., package = "themakR")
}
mustache_tags <- function(path) {
  text <- paste(readLines(path, warn = FALSE), collapse = "\n")
  unique(regmatches(text, gregexpr("\\{\\{\\{?[^{}]+\\}?\\}\\}", text))[[1L]])
}

test_that("the template overrides keep every tag of pkgdown's templates", {
  skip_on_cran()
  skip_if_not_installed("pkgdown", "2.2.1")

  for (name in c("navbar.html", "footer.html")) {
    upstream <- mustache_tags(upstream_file("templates", name))
    shipped <- mustache_tags(shipped_file("templates", name))
    expect_gt(length(upstream), 0L)
    expect_identical(
      setdiff(upstream, shipped), character(),
      info = paste(name, "lacks tags of pkgdown", packageVersion("pkgdown"))
    )
  }
})

test_that("the template overrides add only the documented pieces", {
  navbar <- readLines(shipped_file("templates", "navbar.html"), warn = FALSE)
  footer <- readLines(shipped_file("templates", "footer.html"), warn = FALSE)

  expect_length(grep("class=\"themakr-navbar-logo\"", navbar, fixed = TRUE), 1L)
  expect_length(grep("themakr-brand.js\" defer", navbar, fixed = TRUE), 1L)
  expect_length(grep("themakr-footer-suite", footer, fixed = TRUE), 1L)
  # The navbar logo is decorative: the site title beside it names the link.
  expect_match(navbar[grep("themakr-navbar-logo", navbar)], "alt=\"\"",
               fixed = TRUE)
})

test_that("the adapted light switch differs from pkgdown only in storage", {
  skip_on_cran()
  skip_if_not_installed("pkgdown", "2.2.1")

  upstream <- readLines(upstream_file("assets", "lightswitch.js"),
                        warn = FALSE)
  shipped <- readLines(shipped_file("assets", "lightswitch.js"), warn = FALSE)

  first <- grep("^// Based on pkgdown", shipped)
  last <- grep("^const getPreferredTheme", shipped)
  expect_length(first, 1L)
  expect_length(last, 1L)
  # Lines between the marker and the blank line before getPreferredTheme are
  # the guarded storage helpers; they stand in for pkgdown's two one-liners.
  ours <- shipped[-seq(first, last - 2L)]
  theirs <- upstream[!grepl("^const (get|set)StoredTheme = ", upstream)]
  expect_length(upstream, length(theirs) + 2L)
  expect_identical(
    ours, theirs,
    info = paste("lightswitch.js of pkgdown", packageVersion("pkgdown"))
  )
})

test_that("the adapted light switch keeps its attribution", {
  shipped <- readLines(shipped_file("assets", "lightswitch.js"), warn = FALSE)
  notice <- readLines(system.file("COPYRIGHTS", package = "themakR"),
                      warn = FALSE)

  expect_true(any(grepl("The Bootstrap Authors", shipped, fixed = TRUE)))
  expect_true(any(grepl("Creative Commons Attribution 3.0", shipped,
                        fixed = TRUE)))
  expect_true(any(grepl("lightswitch.js", notice, fixed = TRUE)))
  expect_true(any(grepl("Creative Commons Attribution 3.0", notice,
                        fixed = TRUE)))
})
