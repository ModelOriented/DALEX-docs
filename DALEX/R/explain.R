#' Create Model Explainer
#'
#' Black-box models may have very different structures.
#' This function creates a unified representation of a model, which can be further processed by various explainers.
#'
#' @param model object - a model to be explained.
#' @param ... other parameters
#' @param label character - the name of the model. By default it's extracted from the 'class' attribute of the model.
#'
#' @return An object of the class 'explainer'.
#' It's a list with the model and additional meta-data, like model class, model name etc.
#'
#' @export
#'
#' @examples
#'
explain <- function(model, ..., label = tail(class(model), 1)) {
  explainer <- list(model = model, class = class(model), label = label)
  class(explainer) <- "explainer"
  explainer
}
