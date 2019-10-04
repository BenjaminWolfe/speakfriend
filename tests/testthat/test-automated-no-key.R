context("no key")

# create and test keyring, leave *unlocked and empty*
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

test_that("no keys exist yet", {
  need_keyring()
  expect_equal(list_keys(), character(0))
})

test_that("doesn't have test key yet", {
  need_keyring()
  expect_false(has_key("star"))
})

# test error messages for missing key in non-interactive session
test_that("cannot get non-existent test key", {
  need_keyring()
  expect_error(get_key("star"), "password not set for star")
})

test_that("cannot drop non-existent test key", {
  need_keyring()
  expect_error(drop_key("star"), "password not set for star")
})

# drop keyring for next set of tests
test_that("can drop keyring", {
  need_keyring()
  expect_silent(drop_keyring())
  expect_false(has_keyring())
})
