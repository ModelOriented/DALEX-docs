plot.explainer.feature <- function(response1, ...) {
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
  ggplot(df, aes(x, y, color = label, shape = type)) +
    geom_point() +
    geom_line() +
    xlab(variable_name) + ylab(expression(hat("y")))

}

