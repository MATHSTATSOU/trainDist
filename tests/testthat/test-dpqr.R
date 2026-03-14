
context("trainDist: dpqr vs known values")

test_that("density integrates to ~1", {
  xs <- seq(-5, 5, length.out = 5001)
  dx <- xs[2] - xs[1]
  expect_true(abs(sum(dtrain(xs)) * dx - 1) < 5e-4)
})

test_that("cdf and quantile are consistent", {
  p <- c(0.001, 0.1, 0.5, 0.9, 0.999)
  q <- qtrain(p)
  expect_true(max(abs(ptrain(q) - p)) < 1e-8)
})
