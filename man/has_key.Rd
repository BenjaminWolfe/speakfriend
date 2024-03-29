% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/key.R
\name{has_key}
\alias{has_key}
\title{Check for key}
\usage{
has_key(key, ring = getOption("keyring_keyring", "friend"))
}
\arguments{
\item{key}{Character. The system for which the user wants to check
the existence of a password.}

\item{ring}{Optional. Name of keyring.}
}
\value{
Logical.
}
\description{
Has the user set up a given password?
}
\details{
Function includes checks for \code{\link{has_keyring}}
and \code{\link{keyring_locked}}.
}
\examples{
\dontrun{
has_key("snowflake")
}
}
