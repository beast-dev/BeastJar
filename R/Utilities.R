#' Determine if Java virtual machine supports Java
#'
#' Tests Java virtal machine (JVM) java.version system property to check if version >= 8.
#'
#' @return
#' Returns TRUE if JVM supports Java >= 8.
#'
#' @examples
#' supportsJava8()
#'
#' @export
supportsJava8 <- function() {
  javaVersionText <-
    rJava::.jcall("java/lang/System", "S", "getProperty", "java.version")
  majorVersion <- as.integer(regmatches(
    javaVersionText,
    regexpr(pattern = "^\\d+", text = javaVersionText)
  ))
  if (majorVersion == 1) {
    twoDigitVersion <- regmatches(javaVersionText,
                                  regexpr(pattern = "^\\d+\\.\\d+", text = javaVersionText))
    majorVersion <- as.integer(regmatches(twoDigitVersion,
                                          regexpr("\\d+$", text = twoDigitVersion)))
  }
  support <- majorVersion >= 8
  message(paste0("Using JVM version ",
                 javaVersionText,
                 " (>= 8? ", support, ")"))
  return (support)
}
