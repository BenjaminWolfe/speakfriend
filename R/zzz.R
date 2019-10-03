.onLoad <- function(libname, pkgname) {
  op <- options()

  op.speak <- list(
    keyring_keyring = "friend"
  )
  toset <- !(names(op.speak) %in% names(op))
  if(any(toset)) options(op.speak[toset])

  invisible()
}
