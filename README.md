
<!-- README.md is generated from README.Rmd. Please edit that file -->

# speakfriend <img src='man/figures/logo.svg' align="right" height="138.5" />

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/BenjaminWolfe/speakfriend.svg?branch=master)](https://travis-ci.org/BenjaminWolfe/speakfriend)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/BenjaminWolfe/speakfriend?branch=master&svg=true)](https://ci.appveyor.com/project/BenjaminWolfe/speakfriend)
[![Codecov test
coverage](https://codecov.io/gh/BenjaminWolfe/speakfriend/branch/master/graph/badge.svg)](https://codecov.io/gh/BenjaminWolfe/speakfriend?branch=master)
<!-- badges: end -->

`speakfriend` offers simple, straightforward password management for R
users and advocates.

Password management is what [Emily
Riederer](https://twitter.com/EmilyRiederer) calls a “[first-mile
task](https://emilyriederer.netlify.com/post/resource-roundup-r-in-industry-edition/),”
the kind an R champion should make as simple as possible, as early as
possible, to empower and engage their community. `speakfriend` builds on
the powerful and flexible `keyring` package to help community developers
do just that.

[RStudio](https://rstudio.com/)’s
[keyring](https://github.com/r-lib/keyring) package provides secure
password management for R, as [Sharon
Machlis](https://twitter.com/sharon000) outlines in [this excellent
article](https://www.infoworld.com/article/3320999/r-tip-keep-your-passwords-and-tokens-secure-with-the-keyring-package.html).

`speakfriend` adds 4 elements targeted to the beginner:

1.  **Descriptive prompts**. `keyring` shows the same featureless prompt
    no matter what’s being asked. This can be confusing for new users
    who need to know clearly whether R needs their *master password* or
    an individual *system password*, and why.
2.  **Supportive default behaviors**. For example, if the user tries to
    create a key but doesn’t yet have a keyring to store it,
    `speakfriend` will offer to create one first, and explain what it’s
    doing.
3.  **Instructive messages**. `speakfriend` strives to give the user as
    much information as is helpful. For example if an action that
    requires interactivity is being run outside an interactive session
    (e.g. unlocking the keyring), `speakfriend` will fail and tell the
    user exactly what function they need to run.
4.  **Streamlined functionality**. `speakfriend` uses just one keyring
    and stores just one password per system. This is all many users
    need. `keyring` allows more options, outlined below under
    *Nomenclature*.

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
keyring_locked()        # checks if keyring is locked
unlock_keyring()        # prompts for master password, unlocks keyring

list_keys()             # lists keys
set_key("system_name")  # prompts for individual password, sets key
has_key("system_name")  # checks for existence of key for a given system
get_key("system_name")  # returns individual password
drop_key("system_name") # forgets individual password

drop_keyring()          # e.g. if you forgot your master password
```

## Package Name Inspiration

`speakfriend` is named after a scene [in J.R.R. Tolkien’s The Fellowship
of the
Ring](http://ae-lib.org.ua/texts-c/tolkien__the_lord_of_the_rings_1__en.htm).
The party comes upon an enormous stone door with an elven inscription:

> The Doors of Durin, Lord of Moria. Speak, friend, and enter.

They tried several passwords, spells, and gestures, until finally it
occurred to Gandalf that it was a simple riddle. They needed only to say
the elven word for “friend” and the door would open.

`speakfriend` aims for a similar level of simplicity; one might say you
type `speakfriend`, and `enter`. And as the Doors of Durin once [allowed
unfettered trade](http://tolkiengateway.net/wiki/Doors_of_Durin#History)
between the words of the Dwarves and the Elves, hopefully this package
will help you develop a thriving community of R users.

I considered and avoided using Tolkien analogies in a more heavy-handed
way, beyond perhaps the preceding paragraph. For clarity I instead
retained the original `keyring` analogy (see below).

## Nomenclature

In the `keyring` analogy, a **key** stores one username-password
combination. You might need more than one key per system, if you use
more than one username to access it. A **keyring** is a store for one or
more keys. So, conceivably, you could have multiple personas on your
machine, each with their own keyring, each accessing multiple systems.

`keyring` allows other possibilities as well. You could have multiple
keys for a given system, all on the same keyring. Or you could use no
keyring at all; this would allow you to keep any number of keys, just
the same, but without a master password to lock them.

`speakfriend` requires users to use a keyring. You can still use
multiple keyrings with `options(keyring_keyring = "your_keyring")`, but
you can use the package without specifying anything about keyrings.
`speakfriend` does not currently allow multiple usernames per system,
again as a bid for simplicity. For any given system, you simply call
`get_key("system_name")` to get the user’s one password for that sytem.

## Font Attribution

The `speakfriend` hex logo uses the [Party
Business](https://www.fontspace.com/nancy-lorenz/party-business) font by
Nancy Lorenz. A die-hard LotR fan might note (and do well in noting)
that the font is inspired by the handwriting of Bilbo Baggins, a humble
hobbit, rather than that of the legendary elves who forged the Doors of
Durin. On that note, though, this package really should be for the
Bilbos of the world. Besides, elvish fonts are hard to come by, and this
one is license-free.

I did make one modification to the original font. Lorenz’s “k” has a
crossbar that makes it look a bit like an “r.” And “spearfriend” would
have made for a rather imposing R package.
