#' Check for keyring
#'
#' Is the user set up for R to remember their passwords?
#'
#' @param ring Optional. Name of keyring.
#'
#' @return Logical
#' @export
#'
#' @examples
#' \dontrun{
#' has_keyring()
#' }
has_keyring <- function(ring = getOption("keyring_keyring", "friend")) {
  ring %in% keyring::keyring_list()$keyring
}

#' Create a new keyring
#'
#' Make a place for R to remember the user's passwords.
#'
#' Function includes a check for \code{\link{has_keyring}}.
#'
#' @param ring Optional. Name of keyring.
#'
#' @return NULL (invisibly)
#' @export
#'
#' @examples
#' \dontrun{
#' create_keyring()
#' }
create_keyring <- function(ring = getOption("keyring_keyring", "friend")) {

  if (has_keyring(ring)) {
    if (!interactive_session()) {
      message(
        "keyring already exists; ",
        "to delete it use speakfriend::drop_keyring()"
      )

      return(invisible())
    }

    rstudioapi::showDialog(
      title   = "Already Set",
      message = paste0(
        "You've already created a master password. ",
        "I hope you remember it!"
      )
    )

    return(invisible())
  }

  if (!interactive_session()) {
    stop("must be in an interactive R session to create a keyring")

  }

  rstudioapi::showDialog(
    title   = "One Password to Rule Them All",
    message = paste0(
      "In the next dialog, ",
      "please set up a <b>master password</b> for you. ",
      "R will use this to lock and unlock ",
      "all your <i>other</i> passwords.\n",
      "<i>Please note:</i> ",
      "You won't be able to change this once you set it up, ",
      "unless you delete your keyring and start over."
    )
  )

  keyring::keyring_create(keyring = ring)

  rstudioapi::showDialog(
    title   = "Gratuitous LoTR Reference",
    message = "Keep it secret. <i>Keep it safe!</i>"
  )

  invisible()
}

#' Drop the keyring
#'
#' Delete the keyring, the place the user has set up to remember passwords.
#'
#' Usually useful only if the user has forgotten their master password.
#'
#' Function includes a check for \code{\link{has_keyring}}.
#'
#' @param ring Optional. Name of keyring.
#'
#' @return NULL (invisibly)
#' @export
#'
#' @examples
#' \dontrun{
#' drop_keyring()
#' }
drop_keyring <- function(ring = getOption("keyring_keyring", "friend")) {
  if (!has_keyring(ring)) {
    if (!interactive_session()) {
      message("no keyring to drop")

      return(invisible())
    }

    rstudioapi::showDialog(
      title   = "Nothing There",
      message = "It looks like there's no keyring to drop"
    )

    return(invisible())
  }

  keyring::keyring_delete(ring)
  invisible()
}

#' Offer to set up keyring
#'
#' Unexported, used in \code{\link{keyring_locked}}
#' and \code{\link{unlock_keyring}}.
#'
#' Will set up keyring if user accepts, or fail informatively otherwise.
#'
#' @param ring Optional. Name of keyring.
#'
#' @return Logical. Does the user want to set up a master password?
#' @import rlang
offer_keyring <- function(ring = getOption("keyring_keyring", "friend")) {

  user_agrees <- function() {
    rstudioapi::showQuestion(
      title   = "Keyring Setup",
      message = paste(
        "It looks like your keyring isn't set up",
        "(a place for keeping all your passwords).",
        "Would you like to take care of that now?"
      ),
      ok     = "Yes",
      cancel = "No"
    )
  }

  if (!interactive_session() || !user_agrees()) {
    stop(
      "the keyring does not appear to be set up; ",
      "use speakfriend::create_keyring() to set it up"
    )
  }

  create_keyring(ring)
  invisible()
}

#' Check if keyring is locked
#'
#' Does the user need to enter a master password?
#'
#' Function includes a check for \code{\link{has_keyring}}.
#'
#' @param ring Optional. Name of keyring.
#'
#' @return Logical
#' @export
#'
#' @examples
#' \dontrun{
#' keyring_locked()
#' }
keyring_locked <- function(ring = getOption("keyring_keyring", "friend")) {

  if (!has_keyring(ring)) {
    offer_keyring(ring)

    return(FALSE)
  }

  keyring::keyring_is_locked(ring)
}

#' Lock the keyring
#'
#' Hide passwords from other users until master password is entered later.
#'
#' Function includes checks for \code{\link{has_keyring}}
#' and \code{\link{keyring_locked}}.
#' If the keyring is already locked,
#' \code{\link{lock_keyring}} will message the user.
#'
#' @param ring Optional. Name of keyring.
#'
#' @return NULL (invisibly)
#' @export
#'
#' @examples
#' \dontrun{
#' lock_keyring()
#' }
lock_keyring <- function(ring = getOption("keyring_keyring", "friend")) {

  if (keyring_locked(ring)) {
    if (!interactive_session()) {
      message("keyring already locked")

      return(invisible())
    }

    rstudioapi::showDialog(
      title   = "Already Locked",
      message = "Your keyring is already locked."
    )
    return(invisible())
  }

  keyring::keyring_lock(ring)
  invisible()
}

#' Unlock the keyring
#'
#' Enter the master password for R to remember all other passwords.
#'
#' \strong{It is recommended to enter your master password interactively}
#' using \code{unlock_keyring()}.
#' You can also use \code{unlock_keyring("your_master_password")}
#' to enter your master password programmatically,
#' but \strong{entering passwords in plain text is not recommended}.
#' You could forget and save it as a script,
#' and either way it will show up in your \code{.Rhistory} file.
#'
#' Function includes checks for \code{\link{has_keyring}}
#' and \code{\link{keyring_locked}}.
#' If the keyring is already unlocked,
#' \code{\link{unlock_keyring}} will message the user.
#'
#' @param master_password Character, to specify master password in plain text,
#'   or NULL to type it in at runtime.
#' @param key Character (optional): key name. Chiefly for use in error messages,
#'   as this function is also called by \code{\link{list_keys}},
#'   which is called either directly or indirectly by \code{\link{has_key}},
#'   \code{\link{set_key}}, \code{\link{get_key}}, and \code{\link{drop_key}}.
#' @param ring Optional. Name of keyring.
#'
#' @return NULL (invisibly)
#' @import rlang
#' @export
#'
#' @examples
#' \dontrun{
#' unlock_keyring()
#' }
unlock_keyring <- function(master_password = NULL,
                           key = NULL,
                           ring = getOption("keyring_keyring", "friend")) {

  # messaging is different if user creates a new master password
  # than if user has one and it's already unlocked (next code block)
  if (!has_keyring(ring)) {
    offer_keyring(ring)

    return(invisible())
  }

  if (!keyring_locked(ring)) {
    if (!interactive_session()) {
      message("keyring not locked")

      return(invisible())
    }

    rstudioapi::showDialog(
      title   = "Not Locked",
      message = "Your keyring was not locked."
    )

    return(invisible())
  }

  reusable_messaging <- ifelse(
    !is.null(key),
    paste0("your <i>", key, "</i> password"),
    "the password you set up for a <i>particular system</i>"
  )

  get_master_password <- function() {
    if (!interactive_session()) {
      stop(
        "master password required; ",
        "see ?speakfriend::unlock_keyring for details"
      )
    }

    rstudioapi::showDialog(
      title   = "Your Master Password",
      message = paste0(
        "In the next dialog, ",
        "please enter the <b>master password</b> you set up. ",
        "This is not ", reusable_messaging, ", but the one R needs ",
        "to remember them all."
      )
    )

    rstudioapi::askForPassword("Your master password?")
  }

  attempt_master_password <- function(master_password) {
    tryCatch(
      keyring::keyring_unlock(
        keyring  = ring,
        password = master_password
      ),

      error = function(e) {
        if (!grepl("Invalid password", e)) stop(e)
        if (!interactive_session()) {
          simpler_messaging <- gsub("</?i>", "", reusable_messaging)

          stop("wrong master password - did you use ", simpler_messaging, "?")
        }

        rstudioapi::showDialog(
          title   = "Incorrect Master Password",
          message = paste0(
            "It looks like you entered an incorrect <b>master password</b>. ",
            "(Maybe you entered ", reusable_messaging, " ",
            "or an old password, or maybe your fingers just slipped?) ",
            "Please try again."
          )
        )
        return(invisible())
      }
    )
  }

  attempt_master_password(master_password %||% get_master_password())

  return(invisible)
}
