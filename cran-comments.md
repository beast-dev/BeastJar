## Re-submission following email from Swetlana Herbrandt requesting fixes:

* PLEASE READ

* Message: Size of tarball: 7274204 bytes
           Not more than 5 MB for a CRAN package, please.
  - We are aware the package size exceeds the maximum. We have tried our
    best to reduce the size, for example by dropping code normally used
    for a graphical user interface. However, we cannot reduce the size
    further without removing functionality that is required by some of
    our users.

  - This package is a data-only package, similar to 'XlsxJars' and
    'DatabaseConnectorJars'. Other R packages will be released shortly to
    CRAN that depend on 'BeastJar' whose function is solely to be a
    repository of shared (Java) code to be used by those other packages,
    and is not expected to require frequent updates.

* Message: Please write package names, software names and API names in single quotes
           (e.g. 'BEAST') in Title and Description.
  - Fixed.

* Message:  If there are references describing the (theoretical
            background of) methods in your package, please add these in the
            Description field of your DESCRIPTION file in the [appropriate] form
   - Fixed.  Now included in DESCRIPTION is:
     Suchard et al (2018) <doi:10.1093/ve/vey016>

* Message: Please add small executable examples in your Rd-files.
   - We now include a small executable example.

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



