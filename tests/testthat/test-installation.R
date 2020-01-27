
test_that("Find JAR", {
  fileName <- system.file("java/beast.jar", package = "BeastJar")
  expect_true(file.exists(fileName))
})

test_that("Simulate normal random variable", {
  trace <- simulateNormalDistribution(mean = 1,
                                      sd = 2,
                                      chainLength = 1000,
                                      subSampleFrequency = 1,
                                      seed = 666)
  expect_equal(mean(trace), 1, tolerance = 1E-1)
  expect_equal(sqrt(var(trace)), 2, tolerance = 1E-1)
})
