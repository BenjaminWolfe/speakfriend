context("no keyring")

# definitely set this, or you'll accidentally delete your own keyring
old_keyring <- getOption("keyring_keyring")
teardown(options(keyring_keyring = old_keyring))
setup(options(keyring_keyring = "DurinDoors"))

# same error message for all tests with errors in this file
# only when dropping keyring is it different (message rather than error)
no_keyring_error <-
  paste0(
    "the keyring does not appear to be set up; ",
    "use speakfriend::create_keyring() to set it up"
  )

# do not create a keyring, and watch while everything errors out
test_that("no keyring", {
  expect_false(has_keyring())
})

test_that("cannot check non-existent keyring", {
  expect_error(keyring_locked(), no_keyring_error, fixed = TRUE)
})

test_that("cannot lock non-existent keyring", {
  expect_error(lock_keyring(), no_keyring_error, fixed = TRUE)
})

test_that("cannot unlock non-existent keyring", {
  expect_error(
    unlock_keyring(master_password = "M3110n!"),
    no_keyring_error,
    fixed = TRUE
  )
})

test_that("cannot list keys on non-existent keyring", {
  expect_error(list_keys(), no_keyring_error, fixed = TRUE)
})

test_that("cannot check for test key on non-existent keyring", {
  expect_error(has_key("star"), no_keyring_error, fixed = TRUE)
})

test_that("cannot add test key on non-existent keyring", {
  expect_error(
    set_key(key = "star", password = "Fenn@sN0g0thr1m"),
    no_keyring_error,
    fixed = TRUE
  )
})

test_that("cannot retrieve non-existent test key from non-existent keyring", {
  expect_error(get_key("star"), no_keyring_error, fixed = TRUE)
})

test_that("cannot drop non-existent test key on non-existent keyring", {
  expect_error(drop_key("star"), no_keyring_error, fixed = TRUE)
})

test_that("cannot drop non-existent keyring; informative message", {
  expect_message(drop_keyring(), "no keyring to drop", fixed = TRUE)
})
