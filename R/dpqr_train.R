
#' Density for the Train Delay Distribution
#'
#' Implements d(x) for Y with pdf f(y) = c(25 - y^2) on (-5, 5), c = 3/500.
#'
#' @param x Numeric vector of quantiles.
#' @return Numeric vector of densities.
#' @examples
#' dtrain(0)
#' curve(dtrain, from = -10, to = 10)
#' @export
#' @family train-distribution
#' @seealso [ptrain()], [qtrain()], [rtrain()]
dtrain <- function(x) {
  mod <- reticulate::import("train", delay_load = TRUE, convert = TRUE)
  as.numeric(mod$dtrain(x))
}

#' CDF for the Train Delay Distribution
#'
#' @param q Numeric vector of quantiles.
#' @return Numeric vector with F(q).
#' @examples
#' ptrain(0)
#' curve(ptrain, from = -10, to = 10)
#' @export
#' @family train-distribution
ptrain <- function(q) {
  mod <- reticulate::import("train", delay_load = TRUE, convert = TRUE)
  as.numeric(mod$ptrain(q))
}

#' Quantile Function for the Train Delay Distribution
#'
#' Uses inverse transform computed in Python (robust bisection).
#'
#' @param p Numeric vector of probabilities in \[0, 1\].
#' @return Numeric vector of quantiles.
#' @examples
#' qtrain(0.75)
#' qtrain(c(0.25, 0.5, 0.75))
#' @export
#' @family train-distribution
qtrain <- function(p) {
  mod <- reticulate::import("train", delay_load = TRUE, convert = TRUE)
  as.numeric(mod$qtrain(p))
}

#' Random Generation for the Train Delay Distribution
#'
#' @param n Integer; number of observations to generate.
#' @param seed Optional integer seed for reproducibility (set in Python side).
#' @return Numeric vector of length n.
#' @examples
#' set.seed(123)
#' x <- rtrain(10000)
#' hist(x, prob = TRUE, breaks = 60, col = 'gray')
#' curve(dtrain, add = TRUE, n = 501, lwd = 2, col = 2)
#' @export
#' @family train-distribution
rtrain <- function(n, seed = NULL) {
  mod <- reticulate::import("train", delay_load = TRUE, convert = TRUE)
  as.numeric(mod$rtrain(as.integer(n), seed = seed))
}
