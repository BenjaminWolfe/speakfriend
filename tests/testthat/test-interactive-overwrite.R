context("overwrite keys, interactive")

old_keyring <- getOption("keyring_keyring")

# create and test keyring, add key
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

test_that("can add test key", {
  skip_if_automated()
  expect_silent(set_key(key = "star", password = "Fenn@sN0g0thr1m"))
  expect_true(has_key("star"))
})

test_that("can get test key", {
  skip_if_automated()
  expect_equal(get_key("star"), "Fenn@sN0g0thr1m")
})

# attempt overwriting key, with various values of 'overwrite' parameter
# overwrite = 'no': not tested. same messaging as when non-interactive.
test_that("attempt overwriting key, overwrite = 'ask', interactive, follow", {
  skip_if_automated()
  expect_silent(
    set_key(                        # expect Change Password question box
      key = "star",                 # follow it
      password = "l@st0B3+hLamm3n",
      overwrite = "ask"
    )
  )
})

test_that("test key is changed", {
  skip_if_automated()
  expect_equal(get_key("star"), "l@st0B3+hLamm3n")
})

test_that("attempt overwriting key, overwrite = 'ask', interactive, cancel", {
  skip_if_automated()
  expect_error(
    set_key(                        # expect Change Password question box
      key = "star",                 # do *not* follow it
      password = "Fenn@sN0g0thr1m",
      overwrite = "ask"
    ),
    "key already exists"
  )
})

test_that("test key is not changed", {
  skip_if_automated()
  expect_equal(get_key("star"), "l@st0B3+hLamm3n")
})

# overwrite = 'yes': not tested. same messaging as when non-interactive.

# drop key and keyring for next set of tests
test_that("can drop test key", {
  skip_if_automated()
  expect_silent(drop_key("star"))
  expect_false(has_key("star"))
})

test_that("can drop keyring", {
  skip_if_automated()
  expect_silent(drop_keyring())
  expect_false(has_keyring())
})

test_that("changing keyring name back to default", {
  skip_if_automated()
  options(keyring_keyring = old_keyring)
})
