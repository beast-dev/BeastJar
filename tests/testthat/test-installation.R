
test_that("Find JAR", {
  fileName <- system.file("java/beast.jar", package = "BeastJar")
  expect_true(file.exists(fileName))
})

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

test_that("Simulate normal random variable", {
  if (supportsJava8()) {
    trace <- simulateNormalDistribution(mean = 1,
                                        sd = 2,
                                        chainLength = 1000,
                                        subSampleFrequency = 1,
                                        seed = 666)
    expect_equal(mean(trace), 1, tolerance = 1E-1)
    expect_equal(sqrt(var(trace)), 2, tolerance = 1E-1)
  }
})

test_that("Test supports function", {
  expect_true(is.logical(supportsJava8()))
})
