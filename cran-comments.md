## New submission

## Message: `Package has FOSS license, installs .class/.jar but has no 'java' directory.`

This package provides a single JAR file that contains the open source
and highly popular Bayesian Evolutionary Analysis by Sampling Trees (BEAST)
software library.  By placing the BEAST JAR in this package, we offer an
efficient distribution system for BEAST use by other R packages using
CRAN.  See `inst/COPYRIGHTS` for source file information about BEAST.

## Test environments
* local OS X install, R 4.0.0
* ubuntu 14.04 (on travis-ci), R 3.6.3, gcc 4.8.4 and gcc 6.0
* win-builder (devel and release)

## R CMD check results
* There were no ERRORs or WARNINGs
* There is 1 occasional NOTE:
  checking installed package size ... NOTE
    installed size is  7.8Mb
    sub-directories of 1Mb or more:
      java   7.7Mb

## Downstream dependencies
There are currently no downstream dependencies.
