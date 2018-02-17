#' Prints Explainer Summary
#'
#' @param explainer a model exapliner created with the `explain` function
#'
#' @export
#' @import ggplot2
#'
#' @examples
#'
print.explainer <- function(explainer, ...) {
  cat("Model label: ", explainer$label, "\n")
  cat("Model class: ", paste(explainer$class, collapse = ","), "\n")
  cat("Data head  :\n")
  print(head(explainer$data,2))
  return(invisible(NULL))
}

