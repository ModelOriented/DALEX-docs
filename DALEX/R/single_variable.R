#' Marginal Response for a Single Variable
#'
#' Calculates the average model response as a function of a single selected variable.
#' Use the 'type' parameter to select the type of marginal response to be calculated.
#' Currently we have Partial Dependency and Accumulated Local Effects implemented.
#'
#' @param explainer a model to be explained, preprocessed by the 'explain' function
#' @param variable character - name of a single variable
#' @param type character - type of the response to be calculated.
#' Currently following options are implemented: 'pdp' for Partial Dependency and 'ale' for Accumulated Local Effects
#' @param trans function - a transformation/link function that shall be applied to raw model predictions
#' @param ...
#'
#' @return An object of the class 'single_variable_explainer'.
#' It's a data frame with calculated average response.
#'
#' @export
#'
#' @examples
#'
single_variable <- function(explainer, variable, type = "pdp", trans = I, ...) {
  switch(type,
         pdp = {
           part <- partial(explainer$model, variable)
           res <- data.frame(x = part[,1], y = trans(part$yhat), var = variable, type = type, label = explainer$label)
           class(res) <- c("single_variable_explainer", "data.frame", "pdp")
           res
         },
         ale = {

         },
         stop("Currently only 'pdp' and 'ale' methods are implemented"))
}
