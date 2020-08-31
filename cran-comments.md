## Re-submission following email from Uwe Ligges requesting fixes:

* Message: `Package has FOSS license, installs .class/.jar but has no 'java' directory.`
  - Fixed with the inclusion of a `java` directory and example source code.

* Message: `Found the following (possibly) invalid URLs:` in `README.md`
  - Fixed and apologies for missing this typo.

* Message: `Size of tarball: 7273946 bytes`
  - This package is a data package, similar to `xlsxjars` and `DatabaseConnectorJars`.
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
