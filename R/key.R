#' List keys
#'
#' What all passwords has the user set?
#'
#' Function includes checks for \code{\link{has_keyring}}
#' and \code{\link{keyring_locked}}.
#'
#' @param key Character (optional): key name. Chiefly for use in error messages,
#'   as this function is also called by \code{\link{has_key}},
#'   which in turn is called by \code{\link{set_key}}, \code{\link{get_key}},
#'   and \code{\link{drop_key}}.
#' @param ring Optional. Name of keyring.
#'
#' @return Character vector of key names.
#' @import rlang
#' @export
#'
#' @examples
#' \dontrun{
#' list_keys()
#' }
list_keys <- function(key = NULL,
                      ring = getOption("keyring_keyring", "friend")) {

  reusable_messaging <- ifelse(
    !is.null(key),
    paste0("your ", key, " key"),
    "your keyring"
  )

  if (keyring_locked()) {
    ok_to_proceed <- function() {
      rstudioapi::showQuestion(
        title   = "Your Master Password",
        message = paste(
          "To access ", reusable_messaging, ", ",
          "you'll need to enter your master password. ",
          "OK to proceed?"
        )
      )
    }

    if (!interactive_session() %||% !ok_to_proceed()) {
      stop("unlock keyring with unlock_keyring()")
    }

    unlock_keyring(key = key, ring = ring)
  }

  keyring::key_list(keyring = ring)$service
}

#' Check for key
#'
#' Has the user set up a given password?
#'
#' Function includes checks for \code{\link{has_keyring}}
#' and \code{\link{keyring_locked}}.
#'
#' @param key Character. The system for which the user wants to check
#'   the existence of a password.
#' @param ring Optional. Name of keyring.
#'
#' @return Logical.
#' @export
#'
#' @examples
#' \dontrun{
#' has_key("snowflake")
#' }
has_key <- function(key,
                    ring = getOption("keyring_keyring", "friend")) {
  key %in% list_keys(key, ring = ring)
}

#' Create a key or set a password for an existing key
#'
#' Save the password for a given system.
#'
#' \strong{It is recommended to enter passwords interactively}
#' using \code{set_key("system_name")}.
#' Users can also use \code{set_key("system_name", "your_password")}
#' to enter passwords programmatically,
#' but \strong{entering passwords in plain text is not recommended}.
#' Users could forget and save it as a script,
#' and either way it will show up in their \code{.Rhistory} file.
#'
#' Function includes checks for \code{\link{has_keyring}},
#' \code{\link{keyring_locked}}, and \code{\link{has_key}}.
#' If the key already exists, \code{\link{set_key}} will either overwrite it,
#' fail, or prompt you, depending on the value of \code{overwrite}.
#'
#' @param key Character. The system for which you want to set up a password.
#' @param password Character, to specify a password in plain text,
#'   or NULL to type it in at runtime.
#' @param overwrite Character. Overwrite any existing password?
#'   "yes" to overwrite, "no" to fail, "ask" to prompt.
#' @param ring Optional. Name of keyring.
#'
#' @return NULL (invisibly)
#' @import rlang
#' @export
#'
#' @examples
#' \dontrun{
#' set_key("snowflake")
#' }
set_key <- function(key,
                    password = NULL,
                    overwrite = c("ask", "yes", "no"),
                    ring = getOption("keyring_keyring", "friend")) {
  overwrite <- rlang::arg_match(overwrite)

  if (has_key(key)) {
    prompt_to_change <- function() {
      if (!interactive_session()) return(FALSE)
      rstudioapi::showQuestion(
        title   = "Change Password",
        message = "Password already exists. OK to change?"
      )
    }

    ok_to_change <- switch(
      overwrite,
      "yes" = TRUE,
      "no"  = FALSE,
      "ask" = prompt_to_change()
    )

    if (!ok_to_change) stop("key already exists")
  }

  prompt_for_password <- function(key) {
    if (!interactive_session()) stop("cannot prompt user for password")

    rstudioapi::showDialog(
      title   = "Password",
      message = paste0(
        "In the next dialog, ",
        "please set up a password <b>for ", key, "</b>.\n",
        "This is <b>not</b> the same as the <i>master password</i>."
      )
    )

    rstudioapi::askForPassword(
      prompt = paste0("Password for ", key, "?")
    )
  }

  keyring::key_set_with_value(
    service  = key,
    password = password %||% prompt_for_password(),
    keyring  = ring
  )
}

#' Retrieve a key
#'
#' Return the password for a given system.
#'
#' Function includes checks for \code{\link{has_keyring}},
#' \code{\link{keyring_locked}}, and \code{\link{has_key}}.
#'
#' @param key Character. The system for which user wants to retrieve a password.
#' @param ring Optional. Name of keyring.
#'
#' @return An individual password (character).
#' @export
#'
#' @examples
#' \dontrun{
#' get_key("snowflake")
#' }
get_key <- function(key,
                    ring = getOption("keyring_keyring", "friend")) {

  wants_key <- function(key) {
    if (!interactive_session()) return(FALSE)

    rstudioapi::showQuestion(
      title   = paste0("Setup (", key, ")"),
      message = paste0(
        "It looks like you don't have a password set up for ", key, ". ",
        "Would you like to take care of that now?"
      )
    )
  }

  if (!has_key(key)) {
    if (!wants_key()) stop("password not set for ", key)

    set_key(key = key)
  }

  keyring::key_get(key, keyring = ring)
}

#' Forget a key
#'
#' Delete the password for a given system.
#'
#' Function includes checks for \code{\link{has_keyring}},
#' \code{\link{keyring_locked}}, and \code{\link{has_key}}.
#'
#' @param key Character. The system for which yser wants to retrieve a password.
#' @param ring Optional. Name of keyring.
#'
#' @return NULL (invisibly)
#' @export
#'
#' @examples
#' \dontrun{
#' drop_key("snowflake")
#' }
drop_key <- function(key,
                     ring = getOption("keyring_keyring", "friend")) {

  if (!has_key(key)) stop("password not set for ", key)

  keyring::key_delete(key, keyring = ring)
}
