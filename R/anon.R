#' Anonymise factor columns across datasets in a consistent way
#'
#' `anonymise()` is a useful function for anonymising factor columns
#' across different datasets using consistent anonymised levels. In other
#' words, if the same factor level appears in more than one dataset, then
#' `anonymise()` will use the same anonymous factor for that level.
#'
#' @param data_list A list of data frames or tibbles.
#' @param prefix A character prefix to insert in front of the random labels.
#' @param return_original_levels Whether or not the resulting list should also include the original, non-anonymised levels. Default: FALSE.
#'
#' @returns A list containing the original data, but with consistently anonymised factors
#'
#' @example
#' rand_tbl_1 <- vroom::gen_tbl(10, 4, col_types = "fffd")
#' rand_tbl_2 <- vroom::gen_tbl(10, 2, col_types = "fd")
#' rand_tbl_2$X3 <- rand_tbl_1$X3
#'
#' # note:
#' # * rand_tbl_1 and rand_tbl_2 share three column names,
#' #   of which X2 is a factor in one but not the other.
#' # * X1 factors do not overlap, but their anonymisation
#' #   should still be consistent (ie, different levels should
#' #'#   have their own unique anonymised factors).
#' # * For X3, the anonymised factors should consider the levels
#' #   at both `rand_tbl_1$X3` and `rand_tbl_2$X3`.
#'
#' data_list <- list(rand_tbl_1, rand_tbl_2)
#' data_list
#'
#' data_list |> anonymise(return_original_levels = TRUE)
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
