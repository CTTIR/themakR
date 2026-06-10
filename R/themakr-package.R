#' @keywords internal
"_PACKAGE"

#' Demo function for template preview only
#'
#' Exists solely so the template package has documented reference content to
#' render in its own preview site. Not part of the public theming API.
#'
#' @param x A numeric vector.
#' @return The mean of `x`.
#' @examples
#' tk_demo(1:10)
#' @export
tk_demo <- function(x) {
  mean(x)
}
