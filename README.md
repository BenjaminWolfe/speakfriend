
<!-- README.md is generated from README.Rmd. Please edit that file -->

# speakfriend

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/BenjaminWolfe/speakfriend.svg?branch=master)](https://travis-ci.org/BenjaminWolfe/speakfriend)
<!-- badges: end -->

speakfriend is designed for R champions and enthusiasts who want to make
analysis easy at their school or place of work, without yet having a
comprehensive solution such as Rstudio Server.

The [keyring](https://github.com/r-lib/keyring) package provides secure
password management for R, as [Sharon
Machlis](https://twitter.com/sharon000) outlines in [this excellent
article](https://www.infoworld.com/article/3320999/r-tip-keep-your-passwords-and-tokens-secure-with-the-keyring-package.html).

But if you’ve ever tried building keyring into a *basic package* to
build momentum and buy-in, it has 2 drawbacks:

1.  All the password prompts look the same. This can seem surprisingly
    complex. *"Is this the screen where I plug in my master password,*
    *or do I use my password for \[x system\]?* *And why again is it
    asking?"* If the user enters the wrong password, more frustration
    and friction ensues.
2.  `keyring` is often more than you need. Many users only need one
    keyring, and they need it to store only one password at a time per
    system.

`speakfriend` addresses these drawbacks, and adds informative and
straightforward error messages to boot. For example, if the user tries
to create a key but doesn’t have a keyring to put it on, `speakfriend`
will offer to create the keyring first. `speakfriend` employs
user-friendly dialog boxes from the RStudio API when possible, and
returns informative messages if the user can’t be prompted.

Detail like these are important for developing an active R user
community. They address what [Emily
Riederer](https://twitter.com/EmilyRiederer) calls [first-mile
tasks](https://emilyriederer.netlify.com/post/resource-roundup-r-in-industry-edition/),
tasks you should make as simple as possible, as early as possible, to
empower and engage your community.

## Installation

`speakfriend` is not yet available on
[CRAN](https://CRAN.R-project.org). You can install it from
[GitHub](https://github.com/BenjaminWolfe/speakfriend) with:

``` r
# install.packages("devtools")
devtools::install_github("BenjaminWolfe/speakfriend")
```

## Example

`speakfriend` has just 11 exported functions:

``` r
library(speakfriend)

create_keyring()        # creates keyring, leaves it in unlocked state
has_keyring()           # checks for existence of keyring
lock_keyring()          # locks keyring, does not require master password
keyring_is_locked()     # checks if keyring is locked
unlock_keyring()        # prompts for master password, unlocks keyring

list_keys()             # lists keys
set_key("system_name")  # prompts for individual password, sets key
has_key("system_name")  # checks for existence of key for a given system
get_key("system_name")  # returns individual password
drop_key("system_name") # forgets individual password

drop_keyring()          # e.g. if you forgot your master password
```

## Nomenclature

`speakfriend` is named after a scene [in J.R.R. Tolkien’s The Fellowship
of the
Ring](http://ae-lib.org.ua/texts-c/tolkien__the_lord_of_the_rings_1__en.htm).
The party comes upon an enormous stone door with an elven inscription:

> The Doors of Durin, Lord of Moria. Speak, friend, and enter.

They tried several passwords, spells, and gestures, until finally it
occurred to Gandalf that it was a simple riddle. They needed only to say
the elven word for “friend” and the door would open.

`speakfriend` aims for a similar level of simplicity, and also strives
as much as possible to be user-friendly. I considered and avoided using
Tolkien analogies in a more heavy-handed way. For clarity instead I
retained the original analogy: one *keyring*, with individual *keys* on
it, each of which holds a password to one system.
