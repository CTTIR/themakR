test_that("tk_demo returns the arithmetic mean of a numeric vector", {
  expect_equal(tk_demo(1:10), 5.5)
  expect_equal(tk_demo(c(2, 4, 6)), 4)
  expect_equal(tk_demo(c(-5, 5)), 0)
})

test_that("tk_demo returns the single value for length-one input", {
  expect_equal(tk_demo(42), 42)
  expect_equal(tk_demo(0L), 0)
})

test_that("tk_demo agrees with base::mean", {
  set.seed(1)
  x <- rnorm(100)
  expect_identical(tk_demo(x), mean(x))

  y <- runif(50, -10, 10)
  expect_identical(tk_demo(y), mean(y))
})

test_that("tk_demo handles doubles and integers identically to mean", {
  expect_identical(tk_demo(1:4), mean(1:4))
  expect_identical(tk_demo(c(1.5, 2.5, 3.5)), mean(c(1.5, 2.5, 3.5)))
})

test_that("tk_demo propagates NA without na.rm", {
  expect_true(is.na(tk_demo(c(1, 2, NA))))
})

test_that("tk_demo returns NaN for empty numeric input", {
  expect_true(is.nan(tk_demo(numeric(0))))
})

test_that("tk_demo returns a single numeric scalar", {
  result <- tk_demo(1:10)
  expect_type(result, "double")
  expect_length(result, 1)
})

test_that("tk_demo handles logical input via mean's coercion", {
  expect_equal(tk_demo(c(TRUE, FALSE, TRUE, TRUE)), 0.75)
})

test_that("tk_demo errors are inherited from mean on unsupported input", {
  # mean() on a character vector warns and returns NA
  expect_warning(res <- tk_demo(c("a", "b")))
  expect_true(is.na(res))
})
