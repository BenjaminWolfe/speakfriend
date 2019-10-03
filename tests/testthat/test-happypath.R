context("happy path")

old_keyring <- getOption("keyring_keyring")
on.exit(options(keyring_keyring = old_keyring), add = TRUE)
options(keyring_keyring = "DurinDoors")

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

test_that("can unlock keyring", {
  need_keyring()
  expect_silent(unlock_keyring(master_password = "M3110n!"))
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

test_that("can add test key", {
  need_keyring()
  expect_silent(set_key(key = "star", password = "Fenn@sN0g0thr1m"))
  expect_true(has_key("star"))
})

test_that("can get test key", {
  need_keyring()
  expect_equal(get_key("star"), "Fenn@sN0g0thr1m")
})

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
