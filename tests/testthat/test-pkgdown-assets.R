# These tests assert the theme package ships the pkgdown template assets it
# promises. They are the real "behaviour" of a theme package: the installed
# inst/pkgdown tree is what pkgdown picks up via `template: package: themakR`.

test_that("the installed pkgdown template tree is present", {
  root <- system.file("pkgdown", package = "themakR")
  expect_true(nzchar(root))
  expect_true(dir.exists(root))
})

test_that("the SCSS override file is shipped", {
  scss <- system.file("pkgdown", "extra.scss", package = "themakR")
  expect_true(nzchar(scss))
  expect_true(file.exists(scss))
  expect_gt(file.info(scss)$size, 0)
})

test_that("the navbar and footer templates are shipped", {
  navbar <- system.file("pkgdown", "BS5", "templates", "navbar.html",
                         package = "themakR")
  footer <- system.file("pkgdown", "BS5", "templates", "footer.html",
                         package = "themakR")
  expect_true(file.exists(navbar))
  expect_true(file.exists(footer))
})

test_that("the bundled _pkgdown.yml declares the suite URL", {
  yml <- system.file("pkgdown", "_pkgdown.yml", package = "themakR")
  expect_true(file.exists(yml))
  txt <- readLines(yml, warn = FALSE)
  expect_true(any(grepl("cttir.github.io", txt, fixed = TRUE)))
})

test_that("a CITATION file is shipped", {
  cit <- system.file("CITATION", package = "themakR")
  expect_true(file.exists(cit))
})
