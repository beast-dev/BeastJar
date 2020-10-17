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
  javaVersionText <- "1.8.4"

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

  return (majorVersion >= 8)
}
