#' Check for interactive session
#'
#' Unexported. Is the function being called in an interactive setting?
#'
#' \code{\link[base]{interactive}} has thrown errors for me in the past.
#' This way all such errors are abstracted out to a single function.
#'
#' @return Logical
interactive_session <- function() isTRUE(interactive())
