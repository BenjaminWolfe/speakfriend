#' Check if currently running automated tests
#'
#' Unexported. Checks if currently running automated tests
#' with the \code{devtools} / \code{testthat} suite.
#'
#' If I don't check for this, technically I"m still in an interactive session
#' even if I'm running automated tests from within RStudio.
#'
#' @return Logical
currently_testing <- function() {
  call_trace <-
    sapply(
      rlang::trace_back()$calls,
      as.character
    )
  any(grepl("(devtools::test)|(testthat::test_check)", call_trace))
}

#' Check for interactive session
#'
#' Unexported. Is the function being called in an interactive setting?
#'
#' \code{\link[base]{interactive}} has thrown errors for me in the past.
#' This way all such errors are abstracted out to a single function.
#'
#' It also allows me to check for \code{\link{currently_testing}}.
#'
#' @return Logical
interactive_session <- function() isTRUE(interactive()) & !currently_testing()

