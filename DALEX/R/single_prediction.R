#' Explanations for a Single Prediction
#'
#'
#'
#' @param explainer a model to be explained, preprocessed by the 'explain' function
#' @param observation a new observarvation for which predictions need to be explained
#' @param ... other parameters
#'
#' @return An object of the class 'single_prediction_explainer'.
#' It's a data frame with calculated average response.
#'
#' @export
#' @import breakDown
#' @examples
#'
single_prediction <- function(explainer, observation, ...) {
  stopifnot(class(explainer) == "explainer")

  # breakDown
  res <- broken(explainer$model,
                new_observation = observation,
                data = explainer$data,
                baseline = "Intercept")
  res$label <- rep(explainer$label, length(res$variable))

  class(res) <- c("single_prediction_explainer", "data.frame")
  res

}


