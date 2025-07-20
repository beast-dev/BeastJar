## Minor patch to BEAST X (July, 2025 in Nature Methods)

* This submission packages the latest release of the popular phylogenetics
  software BEAST X to make it available to R users

* occasional NOTE: installed size is  7.8Mb
  - We are aware the package size exceeds the maximum. We have tried our
    best to reduce the size, for example by dropping code normally used
    for a graphical user interface. However, we cannot reduce the size
    further without removing functionality that is required by some of
    our users.

  - BEAST is updated at most annually, so we expected very rare updates.

  - This package is a data-only package, similar to 'XlsxJars' and
    'DatabaseConnectorJars'. Other R packages will be released shortly to
    CRAN that depend on 'BeastJar' whose function is solely to be a
    repository of shared (Java) code to be used by those other packages.

## Test environments
* local OS X install, R 4.5.1
* win-builder (devel and release)
* rhub, solaris-x86-patched

## R CMD check results
* There were no ERRORs or WARNINGs
* There is 1 occasional NOTE:
  checking installed package size ... NOTE
    installed size is  7.8Mb
    sub-directories of 1Mb or more:
      java   7.7Mb

## Downstream dependencies
There are currently no downstream dependencies.
