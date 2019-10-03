# Many of my tests require a keyring to be created.
# I looked in `keyring/tests/testthat/` for ways to do that non-interactively.
# `keyring` has 5 back ends:
#
# - Windows     - test-wincred.R creates a keyring non-interactively, skips CRAN
# - MacOS       - test-macos.R creates a keyring non-interactively, skips CRAN
# - Linux       - test-secret-service.R says it requires interaction
# - Environment - test-env.R does not create a keyring
# - File-based  - this may be beyond me
#
# I have incorporated everything below that I can,
# including some code inspired by keyring's helper.R.
# Building on `keyring`, I'm assuming `speakfriend` will work on all platforms.
# I just have to ensure I can create a keyring for my tests whenever possible.
get_os <- function() {

  os <- tolower(Sys.info()[["sysname"]])
  ifelse(os == "darwin", "mac", os)
}

skip_if_not_os <- function(os) {

  if (get_os() != os) skip(paste("not", os))
  invisible(TRUE)
}

create_dummy_keyring_macos <- function() {

  skip_if_not_os("mac")
  skip_on_cran()

  ring <- getOption("keyring_keyring")
  message(getOption("keyring_keyring"))
  expect_equal(ring, "DurinDoors")

  # to avoid an interactive password
  kb <- keyring::backend_macos$new()
  kb$.__enclos_env__$private$keyring_create_direct(ring, "M3110n!")

  # ensure that it exists and is empty
  list <- kb$list(keyring = ring)
  expect_equal(nrow(list), 0)

  service  <- "silverstar"
  username <- "AnnonEdhellen"
  password <- "edr0H1Amm3n!"

  # ensure that it works; otherwise neither can we expect other tests to
  expect_silent(kb$set_with_value(service, username, password))

  expect_equal(kb$get(service, username), password)

  expect_silent(kb$delete(service, username))

  invisible()
}

create_dummy_keyring_windows <- function() {

  skip_if_not_os("windows")
  skip_on_cran()

  ring <- getOption("keyring_keyring")
  expect_equal(ring, "DurinDoors")

  # to avoid an interactive password
  kb <- keyring::backend_wincred$new(keyring = ring)
  kb$.__enclos_env__$private$keyring_create_direct(ring, "M3110n!")

  # ensure that it exists
  expect_true(ring %in% kb$keyring_list()$keyring)

  # and is empty
  list <- kb$list()
  expect_equal(nrow(list), 0)

  # ensure that it works; otherwise neither can we expect other tests to
  service  <- "silverstar"
  username <- "AnnonEdhellen"
  password <- "edr0H1Amm3n!"

  expect_silent(kb$set_with_value(service, username, password))

  expect_equal(kb$get(service, username), password)

  expect_silent(kb$delete(service, username))

  invisible()
}

need_keyring <- function() {

  os <- get_os()
  if (!(os %in% c("mac", "windows"))) {
    skip("not mac or windows")
  }
  skip_on_cran()
}

create_dummy_keyring <- function() {

  os <- get_os()
  switch(
    os,
    "mac"     = create_dummy_keyring_macos(),
    "windows" = create_dummy_keyring_windows(),
    skip("not mac or windows")
  )

  invisible()
}
