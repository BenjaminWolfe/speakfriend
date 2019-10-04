context("keyring locked")

# create and test keyring, leave *locked*
old_keyring <- getOption("keyring_keyring")
teardown(options(keyring_keyring = old_keyring))
setup(options(keyring_keyring = "DurinDoors"))

test_that("creating keychains", {
  need_keyring()
  create_dummy_keyring()
})

test_that("has keyring", {
  need_keyring()
  expect_true(has_keyring())
})

test_that("keyring unlocked", {
  need_keyring()
  expect_false(keyring_locked())
})

test_that("can lock keyring", {
  need_keyring()
  expect_silent(lock_keyring())
  expect_true(keyring_locked())
})

# test error messages for locked keyring in non-interactive session
test_that("cannot list keys", {
  need_keyring()
  expect_error(list_keys(), "unlock keyring with unlock_keyring()")
})

test_that("cannot check for test key", {
  need_keyring()
  expect_error(has_key("star"), "unlock keyring with unlock_keyring()")
})

test_that("cannot add test key", {
  need_keyring()
  expect_error(
    set_key(key = "star", password = "Fenn@sN0g0thr1m"),
    "unlock keyring with unlock_keyring()"
  )
})

test_that("cannot get test key", {
  need_keyring()
  expect_error(get_key("star"), "unlock keyring with unlock_keyring()")
})

test_that("cannot drop test key", {
  need_keyring()
  expect_error(drop_key("star"), "unlock keyring with unlock_keyring()")
})

# drop keyring for next set of tests
test_that("can drop keyring", {
  need_keyring()
  expect_silent(drop_keyring())
  expect_false(has_keyring())
})
