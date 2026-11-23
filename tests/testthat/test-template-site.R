# The template is exercised the way the suite uses it: a consumer package
# declares `template: package: themakR` and pkgdown builds its site.

# Pages and the style bundle are large; report the pattern, not the text.
expect_found <- function(text, pattern, fixed = TRUE) {
  found <- grepl(pattern, text, fixed = fixed, perl = !fixed)
  testthat::expect(found, sprintf("Pattern not found: %s", pattern))
  invisible(found)
}
expect_absent <- function(text, pattern) {
  found <- grepl(pattern, text, fixed = TRUE)
  testthat::expect(!found, sprintf("Unexpected pattern: %s", pattern))
  invisible(!found)
}
last_match <- function(pattern, text) {
  hits <- gregexpr(pattern, text, perl = TRUE)[[1L]]
  hits[[length(hits)]]
}

test_that("a consumer inherits the shared configuration", {
  meta <- demo_site()$pkg$meta

  expect_identical(meta$template$bootstrap, 5L)
  expect_true(meta$template[["light-switch"]])
  expect_identical(meta$template$theme, "github-light")
  expect_identical(meta$template[["theme-dark"]], "github-dark")
  expect_identical(meta$template[["math-rendering"]], "katex")
  expect_identical(meta$template$bslib$primary, "#1565c0")
  expect_identical(meta$template$bslib$bg, "#fafafa")
  expect_identical(meta$template$bslib$fg, "#212121")
  # A consumer's own bslib values are merged over the shared ones.
  expect_identical(meta$template$bslib$base_font, "sans-serif")

  expect_length(meta$navbar$structure$left, 0L)
  expect_identical(
    unlist(meta$navbar$structure$right),
    c("search", "reference", "articles", "news", "github", "lightswitch")
  )
  expect_identical(
    unlist(meta$home$sidebar$structure),
    c("links", "license", "community", "citation", "authors", "rouniverse")
  )
  expect_identical(meta$footer$structure$left, "developed_by")
  expect_identical(meta$footer$structure$right, "built_with")
  # The custom sidebar section points at the suite, not at one package.
  universe <- meta$home$sidebar$components$rouniverse
  expect_identical(universe$title, "R-universe")
  expect_match(universe$text, "[CTTIR universe](https://cttir.github.io/",
               fixed = TRUE)
})

test_that("the template scripts replace pkgdown's defaults in a built site", {
  site <- demo_site()
  shipped <- function(name) {
    system.file("pkgdown", "BS5", "assets", name, package = "themakR")
  }
  built <- function(name) file.path(site$pkg$dst_path, name)

  for (name in c("lightswitch.js", "themakr-brand.js")) {
    expect_true(file.exists(built(name)), info = name)
    expect_identical(
      unname(tools::md5sum(built(name))),
      unname(tools::md5sum(shipped(name))),
      info = name
    )
  }
})

test_that("the shared stylesheet compiles into the site bundle", {
  css <- demo_site()$css

  expect_found(css, "--themakr-navbar-offset:\\s*96px", fixed = FALSE)
  expect_found(css, ".themakr-footer-suite")
  expect_found(css, "img.themakr-navbar-logo")
  # Token and component partials are imported.
  expect_found(css, "(?i)--cttir-page:\\s*#fafafa", fixed = FALSE)
  expect_found(css, ".cttir-lockup")
  expect_found(css, "[data-cttir-topic=\"spectral\"]")
  # Dark mode drives Bootstrap's colour-mode variables.
  expect_found(
    css,
    "(?i)\\[data-bs-theme=\"?dark\"?\\]\\s*\\{\\s*--bs-body-bg:\\s*#212121",
    fixed = FALSE
  )
  # The shared accent is compiled into the bundle.
  expect_found(css, "(?i)--bs-primary:\\s*#1565c0", fixed = FALSE)
})

test_that("the version label gives way on the narrowest screens", {
  css <- demo_site()$css

  # Otherwise a long package name wraps the fixed navbar over the heading.
  expect_found(
    css,
    paste0(
      "@media\\s*\\(max-width:\\s*359\\.98px\\)\\s*\\{\\s*",
      "\\.navbar \\.nav-text\\s*\\{\\s*display:\\s*none"
    ),
    fixed = FALSE
  )
  # The reserved space matches the single-row bar at both logo sizes.
  expect_found(css, "--themakr-navbar-offset:\\s*80px", fixed = FALSE)
})

test_that("linked inline code keeps the link colour", {
  site <- demo_site()

  expect_found(site$home, "<a [^>]*><code>mean\\(\\)</code></a>",
               fixed = FALSE)
  # The body-coloured inline code rule must not be the last word for links.
  inline <- last_match(":not\\(pre\\)\\s*>\\s*code\\s*\\{", site$css)
  linked <- last_match("a\\s*>\\s*code\\s*\\{\\s*color:\\s*inherit", site$css)
  expect_gt(inline, 0L)
  expect_gt(linked, inline)
})

test_that("the navbar carries the logo, its dark alias and the light switch", {
  home <- demo_site()$home

  expect_found(home, paste0(
    "<a class=\"navbar-brand me-2\" href=\"index.html\">",
    "<img src=\"logo.svg\" alt=\"\" class=\"themakr-navbar-logo\" ",
    "data-cttir-dark-src=\"reference/figures/logo-dark.svg\">demoPkg</a>"
  ))
  expect_found(home, "<script src=\"themakr-brand.js\" defer>")
  expect_found(home, "<script src=\"lightswitch.js\">")
  expect_found(home, "id=\"dropdown-lightswitch\"")
  for (mode in c("light", "dark", "auto")) {
    expect_found(home, sprintf("data-bs-theme-value=\"%s\"", mode))
  }
  # Search precedes the page links; the light switch closes the bar.
  order <- vapply(
    c("id=\"search-input\"", "news/index.html\">Changelog",
      "id=\"dropdown-lightswitch\""),
    function(x) regexpr(x, home, fixed = TRUE)[[1L]],
    numeric(1)
  )
  expect_true(all(order > 0))
  expect_false(is.unsorted(order))
})

test_that("pages below the site root resolve the shared assets", {
  news <- demo_site()$news

  expect_found(news, "<img src=\"../logo.svg\" alt=\"\"")
  expect_found(
    news, "data-cttir-dark-src=\"../reference/figures/logo-dark.svg\""
  )
  expect_found(news, "<script src=\"../themakr-brand.js\" defer>")
  expect_found(news, "<script src=\"../lightswitch.js\">")
})

test_that("the footer names the package and accepts a wording override", {
  site <- demo_site()
  name <- "<span class=\"themakr-footer-pkg\">demoPkg</span> is part of "

  expect_found(
    site$home,
    paste0(name, "the <a href=\"https://cttir.github.io/website/\"")
  )
  expect_found(site$home, ">CTTIR</a> suite")
  expect_found(site$news, paste0(name, "the demo collection"))
  expect_absent(site$news, ">CTTIR</a> suite")
  # pkgdown's own footer cells are kept either side of the suite line.
  expect_found(site$home, "Developed by A. Tester")
  expect_found(site$home, "Site built with")
})
