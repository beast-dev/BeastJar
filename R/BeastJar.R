

#' BeastJar
#'
#' Convenient packaging of the Bayesian Evolutionary Analysis Sampling Trees (BEAST) software package
#' to facilitate Markov chain Monte Carlo sampling techniques including Hamiltonian Monte Carlo,
#' boucy particle sampling and zig-zag sampling.
#'
#' @docType package
#' @name BeastJar
#' @import rJava
NULL

.onLoad <- function(libname, pkgname) {
  rJava::.jpackage(pkgname, lib.loc = libname)
}

#' Example MCMC simulation using BEAST
#'
#' This function generates a Markov chain to sample from a simple normal distribution.
#' It uses a random walk Metropolis kernel that is auto-tuning.
#'
#' @param mean  Mean of target normal distribution
#' @param sd  Standard deviation of target normal distribution
#' @param chainLength Markov chain length to simulate
#' @param subSampleFrequency Frequency at which to retain samples from the Markov chain
#' @param seed Pseudo-random number generator seed (`NULL` sets based on current time)

#' @export
simulateNormalDistribution <- function(mean = 0,
                                       sd = 1,
                                       chainLength = 10000,
                                       subSampleFrequency = 10,
                                       seed = NULL) {

  if (!is.null(seed)) {
    rJava::J("dr.math.MathUtils")$setSeed(rJava::.jlong(seed));
  }

  distribution <- rJava::.jnew("dr.math.distributions.NormalDistribution",
                               as.numeric(mean), as.numeric(sd))
  model <- rJava::.jnew("dr.inference.distribution.DistributionLikelihood",
                        rJava::.jcast(distribution, "dr.math.distributions.Distribution"))
  parameter <- rJava::.jnew("dr.inference.model.Parameter$Default", "p", 1.0,
                            as.numeric(-1.0 / 0.0), as.numeric(1.0 / 0.0))
  model$addData(parameter)

  dummy <- rJava::.jnew("dr.inference.model.DefaultModel",
                        rJava::.jcast(parameter, "dr.inference.model.Parameter"))

  joint <- rJava::.jnew("java.util.ArrayList")
  joint$add(rJava::.jcast(model, "dr.inference.model.Likelihood"))
  joint$add(rJava::.jcast(dummy, "dr.inference.model.Likelihood"))

  joint <- rJava::new(rJava::J("dr.inference.model.CompoundLikelihood"), joint)

  operator <- rJava::.jnew("dr.inference.operators.RandomWalkOperator",
                           rJava::.jcast(parameter, "dr.inference.model.Parameter"),
                           0.75,
                           rJava::J("dr.inference.operators.RandomWalkOperator")$BoundaryCondition$reflecting,
                           1.0,
                           rJava::J("dr.inference.operators.AdaptationMode")$DEFAULT
  )

  schedule <- rJava::.jnew("dr.inference.operators.SimpleOperatorSchedule",
                           as.integer(1000), as.numeric(0.0))

  schedule$addOperator(operator)

  memoryFormatter <- rJava::.jnew("dr.inference.loggers.ArrayLogFormatter", FALSE)
  memoryLogger <-
    rJava::.jnew("dr.inference.loggers.MCLogger",
                 rJava::.jcast(memoryFormatter, "dr.inference.loggers.LogFormatter"),
                 rJava::.jlong(subSampleFrequency), FALSE)
  memoryLogger$add(parameter)

  mcmc <- rJava::.jnew("dr.inference.mcmc.MCMC", "mcmc1")
  mcmc$setShowOperatorAnalysis(FALSE)

  mcmcOptions <- rJava::.jnew("dr.inference.mcmc.MCMCOptions",
                              rJava::.jlong(chainLength),
                              rJava::.jlong(10),
                              as.integer(1),
                              as.numeric(0.1),
                              TRUE,
                              rJava::.jlong(chainLength/100),
                              as.numeric(0.234),
                              FALSE,
                              as.numeric(1.0))

  mcmc$init(mcmcOptions,
            joint,
            schedule,
            rJava::.jarray(memoryLogger, contents.class = "dr.inference.loggers.Logger"))

  mcmc$run()

  traces <- memoryFormatter$getTraces()
  trace <- traces$get(as.integer(1))

  obj <- trace$getValues(as.integer(0),
                  as.integer(trace$getValueCount()))

  sample <- rJava::J("dr.inference.trace.Trace")$toArray(obj)

  outputStream <- rJava::.jnew("java.io.ByteArrayOutputStream")
  printStream <- rJava::.jnew("java.io.PrintStream",
                              rJava::.jcast(outputStream, "java.io.OutputStream"))

  rJava::J("dr.inference.operators.OperatorAnalysisPrinter")$showOperatorAnalysis(
    printStream, schedule, TRUE)

  operatorAnalysisString <- outputStream$toString("UTF8")

  attr(sample, "operatorAnalysis") <- operatorAnalysisString

  return(sample)
}
