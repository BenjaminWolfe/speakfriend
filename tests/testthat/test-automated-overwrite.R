context("overwrite keys")

# create and test keyring, add key
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

test_that("doesn't have test key yet", {
  need_keyring()
  expect_false(has_key("star"))
})

test_that("can add test key", {
  need_keyring()
  expect_silent(set_key(key = "star", password = "Fenn@sN0g0thr1m"))
  expect_true(has_key("star"))
})

test_that("can get test key", {
  need_keyring()
  expect_equal(get_key("star"), "Fenn@sN0g0thr1m")
})

# attempt overwriting key, with various values of 'overwrite' parameter
test_that("attempt overwriting key, overwrite = 'no'", {
  need_keyring()
  expect_error(
    set_key(key = "star", password = "l@st0B3+hLamm3n", overwrite = "no"),
    "key already exists"
  )
})

test_that("attempt overwriting key, overwrite = 'ask', but non-interactive", {
  need_keyring()
  expect_error(
    set_key(key = "star", password = "l@st0B3+hLamm3n", overwrite = "ask"),
    "key already exists"
  )
})

test_that("attempt overwriting key, overwrite = 'yes'", {
  need_keyring()
  expect_silent(
    set_key(key = "star", password = "l@st0B3+hLamm3n", overwrite = "yes")
  )
})

test_that("test key is changed", {
  need_keyring()
  expect_equal(get_key("star"), "l@st0B3+hLamm3n")
})

# drop key and keyring for next set of tests
test_that("can drop test key", {
  need_keyring()
  expect_silent(drop_key("star"))
  expect_false(has_key("star"))
})

test_that("can drop keyring", {
  need_keyring()
  expect_silent(drop_keyring())
  expect_false(has_keyring())
})
