#' Title
#'
#' @param response1
#' @param ...
#' @param color
#' @param shape
#'
#' @return
#' @export
#'
#' @examples
#'
plot.single_variable_explainer <- function(response1, ..., color = "label", shape = "type") {
  df <- response1
  class(df) <- "data.frame"

  dfl <- list(...)
  if (length(dfl) > 0) {
    for (resp in dfl) {
      class(resp) <- "data.frame"
      df <- rbind(df, resp)
      }
  }

  variable_name <- head(df$var, 1)
  ggplot(df, aes(x, y), aes_string(color = color, shape = shape)) +
    geom_point() +
    geom_line() +
    xlab(variable_name) + ylab(expression(hat("y")))

}

