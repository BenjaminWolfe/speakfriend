# first create a bare, unlocked keyring called test, with password asdf
#   speakfriend::drop_keyring("test")
#   speakfriend::create_keyring("test")

library(testthat)
library(speakfriend)
options(speak.keyring = "test")

test_that("has keyring", {
  expect_equal(has_keyring(), TRUE)
})

test_that("keyring unlocked", {
  expect_equal(keyring_is_locked(), FALSE)
})

test_that("can lock keyring", {
  lock_keyring()
  expect_equal(keyring_is_locked(), TRUE)
})

test_that("can unlock keyring", {
  unlock_keyring(master_password = "asdf")
  expect_equal(keyring_is_locked(), FALSE)
})

test_that("no keys exist yet", {
  expect_equal(list_keys(), character(0))
})

test_that("doesn't have test key yet", {
  expect_equal(has_key("skeleton"), FALSE)
})

test_that("can add test key", {
  set_key(key = "skeleton", password = "bones")
  expect_equal(has_key("skeleton"), TRUE)
})

test_that("can get test key", {
  expect_equal(get_key("skeleton"), "bones")
})

test_that("can drop test key", {
  drop_key("skeleton")
  expect_equal(has_key("skeleton"), FALSE)
})

test_that("can drop keyring", {
  drop_keyring()
  expect_equal(has_keyring(), FALSE)
})
