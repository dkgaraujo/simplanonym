#' Anonymise factor columns across datasets in a consistent way
#'
#' `anonymise()` is a useful function for anonymising factor columns
#' across different datasets using consistent anonymised levels. In other
#' words, if the same factor level appears in more than one dataset, then
#' `anonymise()` will use the same anonymous factor for that level.
#'
#' @param data_list A list of data frames or tibbles.
#' @param prefix A character prefix to insert in front of the random labels.
#' @param prefix A character prefix to insert in front of the random labels.
anonymise <- function(data_list, prefix = "", return_original_levels = FALSE) {
  post <- "_anon"
  fcts <- lapply(data_list, function(x) dplyr::select(x, tidyselect::where(is.factor))) |>
    dplyr::bind_rows() |>
    dplyr::mutate(dplyr::across(.cols = tidyselect::where(is.factor),
                                .fns = ~ forcats::fct_anon(f = .x, prefix = prefix),
                                .names = "{.col}{post}"))
  orig_colnames <- lapply(data_list, function(x) dplyr::select(x, tidyselect::where(is.factor)) |> colnames())
  new_colnames <- lapply(orig_colnames, function(x) c(x, paste0(x, post)))
  tofrom <-lapply(seq_along(new_colnames),
                  function(i)
                    fcts |>
                    dplyr::select(new_colnames[[i]]) |>
                    dplyr::right_join(data_list[[i]]))

  if (return_original_levels == TRUE) {
    return(tofrom)
  } else {
    return(tofrom |> seq_along() |> lapply(function(i) dplyr::select(tofrom[[i]], -orig_colnames[[i]])))
  }
}
