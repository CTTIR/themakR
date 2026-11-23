# The Hugo Coder colours are written down three times: the bslib values in
# the shared _pkgdown.yml, the colour-mode rules in extra.scss and the
# generated --cttir-* tokens. They must agree.

template_lines <- function(name) {
  readLines(system.file("pkgdown", name, package = "themakR"), warn = FALSE)
}

# Declarations of the first rule whose selector line matches `selector`.
rule_values <- function(lines, selector, property) {
  start <- grep(selector, lines, fixed = TRUE)[1L]
  stopifnot(!is.na(start))
  end <- start + which(grepl("^\\s*\\}", lines[-seq_len(start)]))[1L]
  body <- lines[seq(start + 1L, end - 1L)]
  pattern <- paste0("^\\s*", property, ":\\s*([^;]+);.*$")
  hit <- grep(pattern, body, value = TRUE)
  stopifnot(length(hit) == 1L)
  tolower(sub(pattern, "\\1", hit))
}

yaml_value <- function(lines, key) {
  pattern <- paste0("^\\s*", key, ":\\s*\"([^\"]+)\".*$")
  hit <- grep(pattern, lines, value = TRUE)
  stopifnot(length(hit) == 1L)
  tolower(sub(pattern, "\\1", hit))
}

test_that("light tokens match the shared bslib values and code surface", {
  yml <- template_lines("_pkgdown.yml")
  scss <- template_lines("extra.scss")
  tokens <- template_lines("_cttir-tokens.scss")
  light <- function(name) {
    rule_values(tokens, "[data-bs-theme=\"light\"]", paste0("--cttir-", name))
  }

  expect_identical(light("page"), yaml_value(yml, "bg"))
  expect_identical(light("text"), yaml_value(yml, "fg"))
  expect_identical(light("link"), yaml_value(yml, "primary"))
  expect_identical(light("text"),
                   rule_values(scss, "[data-bs-theme=\"light\"] {",
                               "--bs-body-color"))
  expect_identical(light("code-surface"),
                   rule_values(scss, "body pre {", "background-color"))
  expect_identical(yaml_value(yml, "pkgdown-navbar-bg"), light("page"))
})

test_that("dark tokens match the dark colour-mode rules", {
  yml <- template_lines("_pkgdown.yml")
  scss <- template_lines("extra.scss")
  tokens <- template_lines("_cttir-tokens.scss")
  dark <- function(name) {
    rule_values(tokens, "[data-bs-theme=\"dark\"]", paste0("--cttir-", name))
  }
  rule <- function(property) {
    rule_values(scss, "[data-bs-theme=\"dark\"] {", property)
  }

  expect_identical(dark("page"), rule("--bs-body-bg"))
  expect_identical(dark("text"), rule("--bs-body-color"))
  expect_identical(dark("heading"), rule("--bs-heading-color"))
  expect_identical(dark("link"), rule("--bs-link-color"))
  expect_identical(dark("border"), rule("--bs-border-color"))
  expect_identical(dark("code-surface"),
                   rule_values(scss, "[data-bs-theme=\"dark\"] body pre {",
                               "background-color"))
  expect_identical(yaml_value(yml, "pkgdown-navbar-bg-dark"), dark("page"))
})

test_that("the browser theme colour is the shared accent", {
  yml <- template_lines("_pkgdown.yml")
  meta <- grep("name=\"theme-color\"", yml, fixed = TRUE, value = TRUE)

  expect_length(meta, 1L)
  expect_match(meta, paste0("content=\"", yaml_value(yml, "primary"), "\""),
               fixed = TRUE)
})

test_that("each colour mode defines the same set of tokens", {
  tokens <- template_lines("_cttir-tokens.scss")
  names_in <- function(selector) {
    start <- grep(selector, tokens, fixed = TRUE)[1L]
    end <- start + which(grepl("^\\s*\\}", tokens[-seq_len(start)]))[1L]
    body <- tokens[seq(start + 1L, end - 1L)]
    sort(sub("^\\s*(--cttir-[a-z-]+):.*$", "\\1", body))
  }

  light <- names_in("[data-bs-theme=\"light\"]")
  expect_gt(length(light), 0L)
  expect_identical(names_in("[data-bs-theme=\"dark\"]"), light)
  expect_identical(names_in("body.colorscheme-auto"), light)
})
