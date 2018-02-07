#' Title
#'
#' @param explainer
#' @param variable
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
marginal_response <- function(explainer, variable, type = "pdp", trans = I, ...) {
  if (type == "pdp") {
    part <- partial(explainer$model, variable)
    res <- data.frame(x = part[,1], y = trans(part$yhat), var = variable, type = type, label = explainer$label)
    class(res) <- c("explainer.feature", "pdp")
    return(res)
  }
  if (type == "ale") {

  }
  if (type == "ice") {

  }
}
