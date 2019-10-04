context("no keyring, interactive")

old_keyring <- getOption("keyring_keyring")

# definitely set this, or you'll accidentally delete your own keyring
# create and test keyring, add key
test_that("changing keyring name", {
  skip_if_automated()
  options(keyring_keyring = "DurinDoors") # change back at bottom of script
})

# same error message for all tests with errors in this file
# only when dropping keyring is it different (message rather than error)
no_keyring_error <-
  paste0(
    "the keyring does not appear to be set up; ",
    "use speakfriend::create_keyring() to set it up"
  )

# do not create a keyring, and watch while everything errors out
test_that("no keyring", {
  skip_if_automated()
  expect_false(has_keyring())
})

# throughout, expect "Keyring Setup" question box, do not follow ---------------
test_that("cannot check non-existent keyring", {
  skip_if_automated()
  expect_error(keyring_locked(), no_keyring_error, fixed = TRUE)
})

test_that("cannot lock non-existent keyring", {
  skip_if_automated()
  expect_error(lock_keyring(), no_keyring_error, fixed = TRUE)
})

test_that("cannot unlock non-existent keyring", {
  skip_if_automated()
  expect_error(
    unlock_keyring(master_password = "M3110n!"),
    no_keyring_error,
    fixed = TRUE
  )
})

test_that("cannot list keys on non-existent keyring", {
  skip_if_automated()
  expect_error(list_keys(), no_keyring_error, fixed = TRUE)
})

test_that("cannot check for test key on non-existent keyring", {
  skip_if_automated()
  expect_error(has_key("star"), no_keyring_error, fixed = TRUE)
})

test_that("cannot add test key on non-existent keyring", {
  skip_if_automated()
  expect_error(
    set_key(key = "star", password = "Fenn@sN0g0thr1m"),
    no_keyring_error,
    fixed = TRUE
  )
})

test_that("cannot retrieve non-existent test key from non-existent keyring", {
  skip_if_automated()
  expect_error(get_key("star"), no_keyring_error, fixed = TRUE)
})

test_that("cannot drop non-existent test key on non-existent keyring", {
  skip_if_automated()
  expect_error(drop_key("star"), no_keyring_error, fixed = TRUE)
})

# here expect informative dialog box, no keyring to drop -----------------------
test_that("cannot drop non-existent keyring; informative message", {
  skip_if_automated()
  expect_silent(drop_keyring())
})

test_that("changing keyring name back to default", {
  skip_if_automated()
  options(keyring_keyring = old_keyring)
})
