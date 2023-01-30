
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simplanonym <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->
<!-- badges: end -->

The goal of simplanonym is to easily anonymise individuals that appear
in multiple datasets, in a consistent way.

Consistent anonymisation means that:

-   each unique individual gets the same single anonymised factor, even
    if appearing in more than one dataset;
-   the same anonymised factor always refers back to the same
    individual.

## Installation

You can install the development version of simplanonym from
[CRAN](https://cran.r-project.org/package=simplanonym) with:

``` r
install.packages("simplanonym")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(simplanonym)

rand_tbl_1 <- vroom::gen_tbl(10, 4, col_types = "fffd")
rand_tbl_2 <- vroom::gen_tbl(10, 2, col_types = "fd")
rand_tbl_2$X3 <- rand_tbl_1$X3

# note:
# * rand_tbl_1 and rand_tbl_2 share three column names,
#   of which X2 is a factor in one but not the other.
# * X1 factors do not overlap, but their anonymisation
#   should still be consistent (ie, different levels should
#   have their own unique anonymised factors).
# * For X3, the anonymised factors should consider the levels
#   at both `rand_tbl_1$X3` and `rand_tbl_2$X3`.

data_list <- list(rand_tbl_1, rand_tbl_2)
data_list
#> [[1]]
#> # A tibble: 10 × 4
#>    X1                X2              X3                     X4
#>    <fct>             <fct>           <fct>               <dbl>
#>  1 different_gorilla thankful_pony   scary_mustang     1.53   
#>  2 different_gorilla own_leopard     beautiful_marten  0.204  
#>  3 purring_donkey    witty_tiger     straight_deer     1.05   
#>  4 itchy_badger      own_leopard     adorable_panther  0.00518
#>  5 young_snake       calm_finch      white_rhinoceros -1.37   
#>  6 chubby_rabbit     public_lizard   scary_mustang     1.16   
#>  7 hot_bunny         loose_eagle     glamorous_puma   -1.83   
#>  8 gentle_hare       deep_goat       hissing_puppy    -1.09   
#>  9 brief_weasel      green_impala    adorable_panther -1.28   
#> 10 cool_gazelle      nutritious_bird beautiful_marten -1.70   
#> 
#> [[2]]
#> # A tibble: 10 × 3
#>    X1                   X2 X3              
#>    <fct>             <dbl> <fct>           
#>  1 good_chinchilla -0.461  scary_mustang   
#>  2 defeated_cougar -0.0267 beautiful_marten
#>  3 sweet_kangaroo   0.152  straight_deer   
#>  4 good_chinchilla -0.883  adorable_panther
#>  5 good_chinchilla  2.36   white_rhinoceros
#>  6 sweet_kangaroo  -0.570  scary_mustang   
#>  7 rotten_bee       0.297  glamorous_puma  
#>  8 huge_eagle      -0.0890 hissing_puppy   
#>  9 rotten_bee      -1.06   adorable_panther
#> 10 good_chinchilla -0.308  beautiful_marten

data_list |> anonymise(return_original_levels = TRUE)
#> Joining, by = c("X1", "X2", "X3")
#> Joining, by = c("X1", "X3")
#> [[1]]
#> # A tibble: 10 × 7
#>    X1                X2              X3         X1_anon X2_anon X3_anon       X4
#>    <fct>             <fct>           <fct>      <fct>   <fct>   <fct>      <dbl>
#>  1 different_gorilla thankful_pony   scary_mus… 19      12      12       1.53   
#>  2 different_gorilla own_leopard     beautiful… 19      09      04       0.204  
#>  3 purring_donkey    witty_tiger     straight_… 05      02      16       1.05   
#>  4 itchy_badger      own_leopard     adorable_… 26      09      19       0.00518
#>  5 young_snake       calm_finch      white_rhi… 21      08      06      -1.37   
#>  6 chubby_rabbit     public_lizard   scary_mus… 02      19      12       1.16   
#>  7 hot_bunny         loose_eagle     glamorous… 30      11      03      -1.83   
#>  8 gentle_hare       deep_goat       hissing_p… 25      21      01      -1.09   
#>  9 brief_weasel      green_impala    adorable_… 13      16      19      -1.28   
#> 10 cool_gazelle      nutritious_bird beautiful… 12      07      04      -1.70   
#> 
#> [[2]]
#> # A tibble: 10 × 5
#>    X1              X3               X1_anon X3_anon      X2
#>    <fct>           <fct>            <fct>   <fct>     <dbl>
#>  1 good_chinchilla scary_mustang    04      12      -0.461 
#>  2 defeated_cougar beautiful_marten 33      04      -0.0267
#>  3 sweet_kangaroo  straight_deer    23      16       0.152 
#>  4 good_chinchilla adorable_panther 04      19      -0.883 
#>  5 good_chinchilla white_rhinoceros 04      06       2.36  
#>  6 sweet_kangaroo  scary_mustang    23      12      -0.570 
#>  7 rotten_bee      glamorous_puma   01      03       0.297 
#>  8 huge_eagle      hissing_puppy    11      01      -0.0890
#>  9 rotten_bee      adorable_panther 01      19      -1.06  
#> 10 good_chinchilla beautiful_marten 04      04      -0.308
```

## Acknowledgements

The hex sticker for the package is based on an icon provided free of charge by www.flaticon.com.
<a href="https://www.flaticon.com/free-icons/rene-magritte" title="rené magritte icons">René magritte icons created by Freepik - Flaticon</a>
