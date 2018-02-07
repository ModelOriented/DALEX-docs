#' Title
#'
#' @param model
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
explain <- function(model, ..., label = tail(class(model), 1)) {
  explainer <- list(model = model, class = class(model), label = label)
  class(explainer) <- "explainer"
  explainer
}
