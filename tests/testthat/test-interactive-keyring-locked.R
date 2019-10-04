# all tests in this file are to be run interactively
context("keyring locked, interactive")

old_keyring <- getOption("keyring_keyring")

# create and test keyring, leave *locked*
test_that("changing keyring name", {
  skip_if_automated()
  options(keyring_keyring = "DurinDoors") # change back at bottom of script
})

test_that("creating keychains", {
  skip_if_automated()
  create_keyring()               # expect messaging. follow it.
})

test_that("has keyring", {
  skip_if_automated()
  expect_true(has_keyring())
})

test_that("keyring unlocked", {
  skip_if_automated()
  expect_false(keyring_locked())
})

test_that("can lock keyring", {
  skip_if_automated()
  expect_silent(lock_keyring())
  expect_true(keyring_locked())
})

# test error messages for locked keyring ---------------------------------------
# in the following tests, expect the Your Master Password question box
# and DO NOT follow it
test_that("cannot list keys", {
  skip_if_automated()
  expect_error(
    list_keys(),
    "unlock keyring with unlock_keyring()"
  )
})

test_that("cannot check for test key", {
  skip_if_automated()
  expect_error(
    has_key("star"),
    "unlock keyring with unlock_keyring()"
  )
})

test_that("cannot add test key", {
  skip_if_automated()
  expect_error(
    set_key(
      key = "star",
      password = "Fenn@sN0g0thr1m"
    ),
    "unlock keyring with unlock_keyring()"
  )
})

test_that("cannot get test key", {
  skip_if_automated()
  expect_error(
    get_key("star"),
    "unlock keyring with unlock_keyring()"
  )
})

test_that("cannot drop test key", {
  skip_if_automated()
  expect_error(
    drop_key("star"),
    "unlock keyring with unlock_keyring()"
  )
})

# drop keyring for next set of tests
test_that("can drop keyring", {
  skip_if_automated()
  expect_silent(drop_keyring())
  expect_false(has_keyring())
})

test_that("changing keyring name back to default", {
  skip_if_automated()
  options(keyring_keyring = old_keyring)
})
