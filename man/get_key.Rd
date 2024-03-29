% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/key.R
\name{get_key}
\alias{get_key}
\title{Retrieve a key}
\usage{
get_key(key, ring = getOption("keyring_keyring", "friend"))
}
\arguments{
\item{key}{Character. The system for which user wants to retrieve a password.}

\item{ring}{Optional. Name of keyring.}
}
\value{
An individual password (character).
}
\description{
Return the password for a given system.
}
\details{
Function includes checks for \code{\link{has_keyring}},
\code{\link{keyring_locked}}, and \code{\link{has_key}}.
}
\examples{
\dontrun{
get_key("snowflake")
}
}
