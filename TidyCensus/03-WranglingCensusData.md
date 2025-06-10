# Wrangling Census Data

``` r
library(tidycensus)
library(tidyverse)
```

## Sorting and filtering

-   `arrange(df, column)`, `arrange(df, desc(column))`
-   `filter()`

``` r
median_age <- get_acs(
  geography = "county", 
  variables = "B01002_001",
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

``` r
median_age
```

    ## # A tibble: 3,221 × 5
    ##    GEOID NAME                     variable   estimate   moe
    ##    <chr> <chr>                    <chr>         <dbl> <dbl>
    ##  1 01001 Autauga County, Alabama  B01002_001     38.6   0.6
    ##  2 01003 Baldwin County, Alabama  B01002_001     43.2   0.4
    ##  3 01005 Barbour County, Alabama  B01002_001     40.1   0.6
    ##  4 01007 Bibb County, Alabama     B01002_001     39.9   1.2
    ##  5 01009 Blount County, Alabama   B01002_001     41     0.5
    ##  6 01011 Bullock County, Alabama  B01002_001     39.7   1.9
    ##  7 01013 Butler County, Alabama   B01002_001     41.2   0.6
    ##  8 01015 Calhoun County, Alabama  B01002_001     39.5   0.4
    ##  9 01017 Chambers County, Alabama B01002_001     41.9   0.7
    ## 10 01019 Cherokee County, Alabama B01002_001     46.8   0.5
    ## # ℹ 3,211 more rows

> Which counties are the *youngest* and *oldest* in the United States as
> measured by median age?

``` r
arrange(median_age, estimate)[1,]
```

    ## # A tibble: 1 × 5
    ##   GEOID NAME                       variable   estimate   moe
    ##   <chr> <chr>                      <chr>         <dbl> <dbl>
    ## 1 35011 De Baca County, New Mexico B01002_001     22.2   6.9

``` r
arrange(median_age, desc(estimate))[1,]
```

    ## # A tibble: 1 × 5
    ##   GEOID NAME                   variable   estimate   moe
    ##   <chr> <chr>                  <chr>         <dbl> <dbl>
    ## 1 12119 Sumter County, Florida B01002_001       68   0.3

How many counties in the US have a median age of 50 or older?

``` r
filter(median_age, estimate >= 50) |> 
  nrow()
```

    ## [1] 218

## Splitting columns

-   `separate()`

``` r
separate(
  median_age, 
  NAME, 
  into = c("county", "state"), 
  sep = ", "
)
```

    ## # A tibble: 3,221 × 6
    ##    GEOID county          state   variable   estimate   moe
    ##    <chr> <chr>           <chr>   <chr>         <dbl> <dbl>
    ##  1 01001 Autauga County  Alabama B01002_001     38.6   0.6
    ##  2 01003 Baldwin County  Alabama B01002_001     43.2   0.4
    ##  3 01005 Barbour County  Alabama B01002_001     40.1   0.6
    ##  4 01007 Bibb County     Alabama B01002_001     39.9   1.2
    ##  5 01009 Blount County   Alabama B01002_001     41     0.5
    ##  6 01011 Bullock County  Alabama B01002_001     39.7   1.9
    ##  7 01013 Butler County   Alabama B01002_001     41.2   0.6
    ##  8 01015 Calhoun County  Alabama B01002_001     39.5   0.4
    ##  9 01017 Chambers County Alabama B01002_001     41.9   0.7
    ## 10 01019 Cherokee County Alabama B01002_001     46.8   0.5
    ## # ℹ 3,211 more rows

## Summary variables

Use `summary_var` to get the “total” values for a given table. Useful
for normalizing across geographies.

``` r
race_vars <- c(
  White = "B03002_003",
  Black = "B03002_004",
  Native = "B03002_005",
  Asian = "B03002_006",
  HIPI = "B03002_007",
  Hispanic = "B03002_012"
)
nm_race <- get_acs(
  geography = "county", 
  state = "NM", 
  variables = race_vars, 
  summary_var = "B03002_001", 
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

``` r
nm_race
```

    ## # A tibble: 198 × 7
    ##    GEOID NAME                    variable estimate   moe summary_est summary_moe
    ##    <chr> <chr>                   <chr>       <dbl> <dbl>       <dbl>       <dbl>
    ##  1 35001 Bernalillo County, New… White      256847  1497      679037          NA
    ##  2 35001 Bernalillo County, New… Black       16355   664      679037          NA
    ##  3 35001 Bernalillo County, New… Native      26898   684      679037          NA
    ##  4 35001 Bernalillo County, New… Asian       17338   690      679037          NA
    ##  5 35001 Bernalillo County, New… HIPI          369   134      679037          NA
    ##  6 35001 Bernalillo County, New… Hispanic   341790    NA      679037          NA
    ##  7 35003 Catron County, New Mex… White        2931   193        3547          NA
    ##  8 35003 Catron County, New Mex… Black          14    31        3547          NA
    ##  9 35003 Catron County, New Mex… Native          0    13        3547          NA
    ## 10 35003 Catron County, New Mex… Asian           0    13        3547          NA
    ## # ℹ 188 more rows

``` r
nm_race_percent <- nm_race |> 
  mutate(percent = 100 * estimate / summary_est) |> 
  select(NAME, variable, percent)
nm_race_percent
```

    ## # A tibble: 198 × 3
    ##    NAME                          variable percent
    ##    <chr>                         <chr>      <dbl>
    ##  1 Bernalillo County, New Mexico White    37.8   
    ##  2 Bernalillo County, New Mexico Black     2.41  
    ##  3 Bernalillo County, New Mexico Native    3.96  
    ##  4 Bernalillo County, New Mexico Asian     2.55  
    ##  5 Bernalillo County, New Mexico HIPI      0.0543
    ##  6 Bernalillo County, New Mexico Hispanic 50.3   
    ##  7 Catron County, New Mexico     White    82.6   
    ##  8 Catron County, New Mexico     Black     0.395 
    ##  9 Catron County, New Mexico     Native    0     
    ## 10 Catron County, New Mexico     Asian     0     
    ## # ℹ 188 more rows

## Grouping

Identify the largest racial or ethnic group in each county.

``` r
largest_group <- nm_race_percent |> 
  group_by(NAME) |> 
  filter(percent == max(percent))
largest_group
```

    ## # A tibble: 33 × 3
    ## # Groups:   NAME [33]
    ##    NAME                          variable percent
    ##    <chr>                         <chr>      <dbl>
    ##  1 Bernalillo County, New Mexico Hispanic    50.3
    ##  2 Catron County, New Mexico     White       82.6
    ##  3 Chaves County, New Mexico     Hispanic    57.6
    ##  4 Cibola County, New Mexico     Native      39.0
    ##  5 Colfax County, New Mexico     Hispanic    49.5
    ##  6 Curry County, New Mexico      White       46.7
    ##  7 De Baca County, New Mexico    Hispanic    64.2
    ##  8 Doña Ana County, New Mexico   Hispanic    68.6
    ##  9 Eddy County, New Mexico       Hispanic    50.0
    ## 10 Grant County, New Mexico      Hispanic    50.4
    ## # ℹ 23 more rows

Identify the median percentage for each of the racial & ethnic groups in
the dataset across counties

``` r
nm_race_percent |> 
  group_by(variable) |> 
  summarise(median_pct = median(percent))
```

    ## # A tibble: 6 × 2
    ##   variable median_pct
    ##   <chr>         <dbl>
    ## 1 Asian         0.678
    ## 2 Black         1.21 
    ## 3 HIPI          0    
    ## 4 Hispanic     50.0  
    ## 5 Native        1.30 
    ## 6 White        38.1

## New groups

1.  recode the ACS variables into wider income bands
2.  group the data by the wider income bands
3.  calculate grouped sums to generate new estimates.

``` r
nm_hh_income <- get_acs(
  geography = "county", 
  table = "B19001", 
  state = "NM", 
  year = 2016
)
```

    ## Getting data from the 2012-2016 5-year ACS

``` r
print(nm_hh_income[1:10,])
```

    ## # A tibble: 10 × 5
    ##    GEOID NAME                          variable   estimate   moe
    ##    <chr> <chr>                         <chr>         <dbl> <dbl>
    ##  1 35001 Bernalillo County, New Mexico B19001_001   262520  1518
    ##  2 35001 Bernalillo County, New Mexico B19001_002    22480   996
    ##  3 35001 Bernalillo County, New Mexico B19001_003    15112   906
    ##  4 35001 Bernalillo County, New Mexico B19001_004    16054  1015
    ##  5 35001 Bernalillo County, New Mexico B19001_005    15622   941
    ##  6 35001 Bernalillo County, New Mexico B19001_006    14103   792
    ##  7 35001 Bernalillo County, New Mexico B19001_007    14424   761
    ##  8 35001 Bernalillo County, New Mexico B19001_008    12523   884
    ##  9 35001 Bernalillo County, New Mexico B19001_009    11897   747
    ## 10 35001 Bernalillo County, New Mexico B19001_010    10978   719

However, let’s say we only need three income categories for purposes of
analysis: below $35,000/year, between $35,000/year and $75,000/year, and
$75,000/year and up.

``` r
nm_hh_income_recode <- nm_hh_income |> 
  filter(variable != "B19001_001") |> 
  mutate(incgroup = case_when(
    variable < "B19001_008" ~ "below35k", 
    variable < "b19001_013" ~ "bs35land75k", 
    TRUE ~ "above75k"
  ))
nm_hh_income_recode
```

    ## # A tibble: 528 × 6
    ##    GEOID NAME                          variable   estimate   moe incgroup   
    ##    <chr> <chr>                         <chr>         <dbl> <dbl> <chr>      
    ##  1 35001 Bernalillo County, New Mexico B19001_002    22480   996 below35k   
    ##  2 35001 Bernalillo County, New Mexico B19001_003    15112   906 below35k   
    ##  3 35001 Bernalillo County, New Mexico B19001_004    16054  1015 below35k   
    ##  4 35001 Bernalillo County, New Mexico B19001_005    15622   941 below35k   
    ##  5 35001 Bernalillo County, New Mexico B19001_006    14103   792 below35k   
    ##  6 35001 Bernalillo County, New Mexico B19001_007    14424   761 below35k   
    ##  7 35001 Bernalillo County, New Mexico B19001_008    12523   884 bs35land75k
    ##  8 35001 Bernalillo County, New Mexico B19001_009    11897   747 bs35land75k
    ##  9 35001 Bernalillo County, New Mexico B19001_010    10978   719 bs35land75k
    ## 10 35001 Bernalillo County, New Mexico B19001_011    20832   891 bs35land75k
    ## # ℹ 518 more rows

``` r
nm_group_sums <- nm_hh_income_recode |> 
  group_by(NAME, incgroup) |> 
  summarise(estimate = sum(estimate))
```

    ## `summarise()` has grouped output by 'NAME'. You can override using the
    ## `.groups` argument.

``` r
nm_group_sums
```

    ## # A tibble: 99 × 3
    ## # Groups:   NAME [33]
    ##    NAME                          incgroup    estimate
    ##    <chr>                         <chr>          <dbl>
    ##  1 Bernalillo County, New Mexico above75k       83169
    ##  2 Bernalillo County, New Mexico below35k       97795
    ##  3 Bernalillo County, New Mexico bs35land75k    81556
    ##  4 Catron County, New Mexico     above75k         197
    ##  5 Catron County, New Mexico     below35k         632
    ##  6 Catron County, New Mexico     bs35land75k      596
    ##  7 Chaves County, New Mexico     above75k        6122
    ##  8 Chaves County, New Mexico     below35k       10061
    ##  9 Chaves County, New Mexico     bs35land75k     6970
    ## 10 Cibola County, New Mexico     above75k        1662
    ## # ℹ 89 more rows

## Estimates over time

> caveats:
>
> -   names, eg. county names, can change
> -   variable ids are unique to the year and may be different across
>     datasets

The safest option for time-series analysis in the ACS is to use the
Comparison Profile Tables.

``` r
nm_income_compare <- get_acs(
  geography = "county", 
  variables = c(
    income15 = "CP03_2015_062",
    income20 = "CP03_2020_062"
  ), 
  state = "NM", 
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

    ## Using the ACS Comparison Profile

``` r
nm_income_compare
```

    ## # A tibble: 52 × 4
    ##    GEOID NAME                          variable estimate
    ##    <chr> <chr>                         <chr>       <dbl>
    ##  1 35001 Bernalillo County, New Mexico income15    52176
    ##  2 35001 Bernalillo County, New Mexico income20    54308
    ##  3 35005 Chaves County, New Mexico     income15    44363
    ##  4 35005 Chaves County, New Mexico     income20    46254
    ##  5 35006 Cibola County, New Mexico     income15    37430
    ##  6 35006 Cibola County, New Mexico     income20    44731
    ##  7 35007 Colfax County, New Mexico     income15    35645
    ##  8 35007 Colfax County, New Mexico     income20    36937
    ##  9 35009 Curry County, New Mexico      income15    44660
    ## 10 35009 Curry County, New Mexico      income20    48903
    ## # ℹ 42 more rows

Let’s re-engineer the analysis above on educational attainment in
Colorado counties, which below will be computed for a time series from
2010 to 2019. Information on “bachelor’s degree or higher” is split by
sex and across different tiers of educational attainment in the detailed
tables, found in ACS table 15002. Given that we only need a few
variables (representing estimates of populations age 25+ who have
finished a 4-year degree or graduate degrees, by sex), we’ll request
those variables directly rather than the entire B15002 table.

``` r
college_vars <- c("B15002_015",
                  "B15002_016",
                  "B15002_017",
                  "B15002_018",
                  "B15002_032",
                  "B15002_033",
                  "B15002_034",
                  "B15002_035")
```

## Iterating across years

``` r
years <- 2010:2019
names(years) <- years

college_by_year <- map_dfr(years, ~{
  get_acs(
    geography = "county", 
    variables = college_vars, 
    state = "NM", 
    summary_var = "B15002_001", 
    year = .x
  )
}, .id = "year")
```

    ## Getting data from the 2006-2010 5-year ACS

    ## Getting data from the 2007-2011 5-year ACS

    ## Getting data from the 2008-2012 5-year ACS

    ## Getting data from the 2009-2013 5-year ACS

    ## Getting data from the 2010-2014 5-year ACS

    ## Getting data from the 2011-2015 5-year ACS

    ## Getting data from the 2012-2016 5-year ACS

    ## Getting data from the 2013-2017 5-year ACS

    ## Getting data from the 2014-2018 5-year ACS

    ## Getting data from the 2015-2019 5-year ACS

``` r
college_by_year |> 
  arrange(NAME, variable, year)
```

    ## # A tibble: 2,640 × 8
    ##    year  GEOID NAME              variable estimate   moe summary_est summary_moe
    ##    <chr> <chr> <chr>             <chr>       <dbl> <dbl>       <dbl>       <dbl>
    ##  1 2010  35001 Bernalillo Count… B15002_…    35156  1093      423230         106
    ##  2 2011  35001 Bernalillo Count… B15002_…    35940  1192      429831          87
    ##  3 2012  35001 Bernalillo Count… B15002_…    36498  1090      435547          71
    ##  4 2013  35001 Bernalillo Count… B15002_…    37433  1371      441184          91
    ##  5 2014  35001 Bernalillo Count… B15002_…    37454  1074      446795          69
    ##  6 2015  35001 Bernalillo Count… B15002_…    37355  1241      451402          84
    ##  7 2016  35001 Bernalillo Count… B15002_…    38441  1154      455336          71
    ##  8 2017  35001 Bernalillo Count… B15002_…    39195  1415      458214          74
    ##  9 2018  35001 Bernalillo Count… B15002_…    39960  1394      463080          86
    ## 10 2019  35001 Bernalillo Count… B15002_…    41122  1382      466135          85
    ## # ℹ 2,630 more rows

``` r
percent_college_by_year <- college_by_year |> 
  group_by(NAME, year) |> 
  summarise(numerator = sum(estimate), 
            denominator = first(summary_est)) |> 
  mutate(pct_college = 100 * numerator / denominator) |> 
  pivot_wider(id_cols = NAME, 
              names_from = year, 
              values_from = pct_college)
```

    ## `summarise()` has grouped output by 'NAME'. You can override using the
    ## `.groups` argument.

``` r
percent_college_by_year
```

    ## # A tibble: 34 × 11
    ## # Groups:   NAME [34]
    ##    NAME    `2010` `2011` `2012` `2013` `2014` `2015` `2016` `2017` `2018` `2019`
    ##    <chr>    <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
    ##  1 Bernal…   31.5  31.6    31.8   32.1   32.3  32.6   32.8    33.4  33.9    34.4
    ##  2 Catron…   21.3  18.8    16.1   18.5   20.7  26.0   24.8    25.8  22.2    15.7
    ##  3 Chaves…   15.7  16.4    17.3   18.4   18.4  18.1   19.3    19.0  17.8    18.0
    ##  4 Cibola…   11.5   9.24   10.2   10.4   11.7  12.0   12.4    12.4  13.4    14.2
    ##  5 Colfax…   19.9  19.6    20.5   19.8   20.6  21.5   22.1    20.5  20.5    21.7
    ##  6 Curry …   18.2  19.2    19.7   20.4   20.4  20.8   19.7    19.9  19.8    19.2
    ##  7 De Bac…   19.7  20.0    21.0   17.9   11.6   9.68   9.54   10.4   9.81   13.0
    ##  8 Do?a A…   25.4  NA      NA     NA     NA    NA     NA      NA    NA      NA  
    ##  9 Doña A…   NA    25.5    26.0   26.6   27.4  27.7   27.5    27.4  27.5    27.1
    ## 10 Eddy C…   15.1  15.7    15.4   16.7   16.8  17.8   17.0    16.2  15.9    16.2
    ## # ℹ 24 more rows

## Margins of error

By default, MOEs are returned at a 90 percent confidence level.

``` r
get_acs(
  geography = "county",
  state = "Rhode Island",
  variables = "B19013_001",
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

    ## # A tibble: 5 × 5
    ##   GEOID NAME                            variable   estimate   moe
    ##   <chr> <chr>                           <chr>         <dbl> <dbl>
    ## 1 44001 Bristol County, Rhode Island    B19013_001    85413  6122
    ## 2 44003 Kent County, Rhode Island       B19013_001    75857  2022
    ## 3 44005 Newport County, Rhode Island    B19013_001    84282  2629
    ## 4 44007 Providence County, Rhode Island B19013_001    62323  1270
    ## 5 44009 Washington County, Rhode Island B19013_001    86970  3651

``` r
get_acs(
  geography = "county",
  state = "Rhode Island",
  variables = "B19013_001",
  year = 2020, 
  moe_level = 99
)
```

    ## Getting data from the 2016-2020 5-year ACS

    ## # A tibble: 5 × 5
    ##   GEOID NAME                            variable   estimate   moe
    ##   <chr> <chr>                           <chr>         <dbl> <dbl>
    ## 1 44001 Bristol County, Rhode Island    B19013_001    85413 9587.
    ## 2 44003 Kent County, Rhode Island       B19013_001    75857 3166.
    ## 3 44005 Newport County, Rhode Island    B19013_001    84282 4117.
    ## 4 44007 Providence County, Rhode Island B19013_001    62323 1989.
    ## 5 44009 Washington County, Rhode Island B19013_001    86970 5717.

The variables that represent estimates for populations age 65 and up;
this includes `B01001_020` through `B01001_025` for males, and
`B01001_044` through `B01001_049` for females.

``` r
vars <- paste0("B01001_0", c(20:25, 44:49))
vars
```

    ##  [1] "B01001_020" "B01001_021" "B01001_022" "B01001_023" "B01001_024"
    ##  [6] "B01001_025" "B01001_044" "B01001_045" "B01001_046" "B01001_047"
    ## [11] "B01001_048" "B01001_049"

``` r
nola <- get_acs(
  geography = "tract", 
  variables = vars, 
  state = "Louisiana", 
  county = "Orleans",
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

We will now want to examine the margins of error around the estimates in
the returned data. Let’s focus on a specific Census tract in Salt Lake
County using
[`filter()`](https://dplyr.tidyverse.org/reference/filter.html):

``` r
example_tract <- nola |> 
  filter(GEOID == "22071000100")

example_tract |> select(-NAME)
```

    ## # A tibble: 12 × 4
    ##    GEOID       variable   estimate   moe
    ##    <chr>       <chr>         <dbl> <dbl>
    ##  1 22071000100 B01001_020       47    49
    ##  2 22071000100 B01001_021       45    33
    ##  3 22071000100 B01001_022       46    44
    ##  4 22071000100 B01001_023        9    12
    ##  5 22071000100 B01001_024       33    52
    ##  6 22071000100 B01001_025        9    14
    ##  7 22071000100 B01001_044       27    25
    ##  8 22071000100 B01001_045      125   112
    ##  9 22071000100 B01001_046       33    27
    ## 10 22071000100 B01001_047        0    14
    ## 11 22071000100 B01001_048      131   163
    ## 12 22071000100 B01001_049        7    11

A potential solution to large margins of error for small estimates in
the ACS is to aggregate data upwards until a satisfactory margin of
error to estimate ratio is reached. The US Census Bureau publishes
formulas for appropriately calculating margins of error around such
derived estimates, which are included in tidycensus with the following
functions:

    moe_sum(): calculates a margin of error for a derived sum;
    moe_product(): calculates a margin of error for a derived product;
    moe_ratio(): calculates a margin of error for a derived ratio;
    moe_prop(): calculates a margin of error for a derived proportion.

In their most basic form, these functions can be used with constants.
For example, let’s say we had an ACS estimate of 25 with a margin of
error of 5 around that estimate. The appropriate denominator for this
estimate is 100 with a margin of error of 3. To determine the margin of
error around the derived proportion of 0.25, we can use moe_prop():

``` r
moe_prop(25, 100, 5, 3)
```

    ## [1] 0.0494343

Given that the smaller age bands in the Salt Lake City dataset are
characterized by too much uncertainty for our analysis, we decide in
this scenario to aggregate our data upwards to represent populations
aged 65 and older by sex.

``` r
nola_grouped <- nola |> 
  mutate(sex = case_when(
    str_sub(variable, start = -2) < "26" ~ "Male", 
    TRUE ~ "Female"
  )) |> 
  group_by(GEOID, sex) |> 
  summarize(sum_est = sum(estimate), 
            sum_moe = moe_sum(moe, estimate))
```

    ## `summarise()` has grouped output by 'GEOID'. You can override using the
    ## `.groups` argument.

``` r
nola_grouped
```

    ## # A tibble: 368 × 4
    ## # Groups:   GEOID [184]
    ##    GEOID       sex    sum_est sum_moe
    ##    <chr>       <chr>    <dbl>   <dbl>
    ##  1 22071000100 Female     323   202. 
    ##  2 22071000100 Male       189    92.0
    ##  3 22071000200 Female      84    36.5
    ##  4 22071000200 Male        29    28.8
    ##  5 22071000300 Female      65    37.9
    ##  6 22071000300 Male        62    45.1
    ##  7 22071000400 Female     113    67.4
    ##  8 22071000400 Male        71    43.1
    ##  9 22071000601 Female      73    61.5
    ## 10 22071000601 Male        91    50.3
    ## # ℹ 358 more rows
