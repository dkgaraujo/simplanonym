test_that("`anonymise(return_original_levels = TRUE)` works without throwing errors if data inputs are correct", {
  rand_tbl_1 <- vroom::gen_tbl(10, 4, col_types = "fffd")
  rand_tbl_2 <- vroom::gen_tbl(10, 2, col_types = "fd")
  rand_tbl_2$X3 <- rand_tbl_1$X3

  data_list <- list(rand_tbl_1, rand_tbl_2)

  anon_data_list <- data_list |> anonymise(return_original_levels = TRUE)

  expect_type(anon_data_list, "list")
  expect_equal(length(data_list), length(anon_data_list))
})

test_that("`anonymise(return_original_levels = FALSE)` works without throwing errors if data inputs are correct", {
  rand_tbl_1 <- vroom::gen_tbl(10, 4, col_types = "fffd")
  rand_tbl_2 <- vroom::gen_tbl(10, 2, col_types = "fd")
  rand_tbl_2$X3 <- rand_tbl_1$X3

  data_list <- list(rand_tbl_1, rand_tbl_2)

  anon_data_list <- data_list |> anonymise(return_original_levels = FALSE)

  expect_type(anon_data_list, "list")
  expect_equal(length(data_list), length(anon_data_list))
})

test_that("anonymous factors are not recycled (ie, used by more than a single original level)", {
  rand_tbl_1 <- vroom::gen_tbl(10, 4, col_types = "fffd")
  rand_tbl_2 <- vroom::gen_tbl(10, 2, col_types = "fd")
  rand_tbl_2$X3 <- rand_tbl_1$X3

  data_list <- list(rand_tbl_1, rand_tbl_2)

  anon_data_list <- data_list |> anonymise(return_original_levels = TRUE)

  fct_colnames <- data_list |>
    lapply(function(x) x |> dplyr::select(tidyselect::where(is.factor))) |>
    dplyr::bind_rows() |>
    colnames()

  anon_cols <- data_list |>
    anonymise(return_original_levels = FALSE)|>
    lapply(function(x) x |> dplyr::select(tidyselect::where(is.factor))) |>
    dplyr::bind_rows() |>
    colnames()

  num_unique_lvls <- lapply(fct_colnames, function(x) {
    anon_colname <- paste0(x, "_anon")
    count_unique_lvls <- anon_data_list |>
      lapply(function(x) x |> dplyr::select(tidyselect::where(is.factor))) |>
      dplyr::bind_rows() |>
      dplyr::select(dplyr::all_of(c(x, anon_colname))) |>
      dplyr::group_by(.data[[anon_colname]]) |>
      dplyr::summarise(num_unique_orig_levels = dplyr::n_distinct(x)) |>
      dplyr::bind_rows()
  }) |>
    dplyr::bind_rows() |>
    dplyr::select("num_unique_orig_levels") |>
    unique()

  expect_equal(num_unique_lvls$num_unique_orig_levels, 1)
})
