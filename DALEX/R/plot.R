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

  ggplot(df, aes(x, y, color=type, shape=label)) +
    geom_point() +
    geom_line() +
    xlab(df$var[1])

}

