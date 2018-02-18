#' Plots Marginal Responses
#'
#' Function 'plot.single_variable_explainer' plots marginal responses for one or more explainers.
#'
#' @param x a single variable exlainer produced with the 'single_variable' function
#' @param ... other explainers that shall be plotted together
#'
#' @return a ggplot2 object
#' @export
#' @import ggplot2
#' @importFrom grDevices dev.off pdf
#'
#' @examples
#'
plot.single_variable_explainer <- function(x, ...) {
  df <- x
  class(df) <- "data.frame"

  dfl <- list(...)
  if (length(dfl) > 0) {
    for (resp in dfl) {
      class(resp) <- "data.frame"
      df <- rbind(df, resp)
      }
  }

  variable_name <- head(df$var, 1)
  ggplot(df, aes_string(x = "x", y = "y", color = "label", shape = "type")) +
    geom_point() +
    geom_line() +
    theme_mi2() +
    scale_color_brewer(name = "Model", type = "qual", palette = "Dark2") +
    scale_shape_discrete(name = "Type") +
    ggtitle("Single variable conditional responses") +
    xlab(variable_name) + ylab(expression(hat("y")))

}

