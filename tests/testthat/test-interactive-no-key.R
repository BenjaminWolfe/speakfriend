# all tests in this file are to be run interactively
context("no key, interactive")

old_keyring <- getOption("keyring_keyring")

# create and test keyring, leave *unlocked and empty*
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

test_that("doesn't have test key yet", {
  skip_if_automated()
  expect_false(has_key("star"))
})

# test messaging if no key but add
test_that("cannot get non-existent test key, follow prompts", {
  skip_if_automated()
  expect_silent(get_key("star")) # expect "Setup (star)" question box.
                                 # follow all the way through w/ password asdf
  expect_true(has_key("star"))
})

test_that("can get test key", {
  skip_if_automated()
  expect_equal(get_key("star"), "asdf")
})

test_that("can drop test key", {
  skip_if_automated()
  expect_silent(drop_key("star"))
  expect_false(has_key("star"))
})

# test messaging if no key and not add
test_that("cannot get non-existent test key, skip prompts", {
  skip_if_automated()
  expect_error(
    get_key("star"),             # expect "Setup (star)" question box.
                                 # do not follow through
    "password not set for star"
  )
})

# dropping non-existent key: not tested. same messaging as when non-interactive.

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
