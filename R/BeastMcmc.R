

#' BeastMcmc
#'
#' @docType package
#' @name BeastMcmc
#' @import rJava
NULL

.onLoad <- function(libname, pkgname) {
  rJava::.jpackage(pkgname, lib.loc = libname)
}
