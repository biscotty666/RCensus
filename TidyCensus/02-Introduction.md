# Tidycensus Basics

## Decenial census

``` r
library(tidycensus)
```

``` r
api_key <- Sys.getenv("CENSUS_API_KEY")
```

``` r
total_population_10 <- get_decennial(
  geography = "state", 
  variables = "P001001", 
  year = 2010
)
```

    ## Getting data from the 2010 decennial Census

    ## Using Census Summary File 1

``` r
total_population_10
```

    ## # A tibble: 52 × 4
    ##    GEOID NAME        variable    value
    ##    <chr> <chr>       <chr>       <dbl>
    ##  1 01    Alabama     P001001   4779736
    ##  2 02    Alaska      P001001    710231
    ##  3 04    Arizona     P001001   6392017
    ##  4 05    Arkansas    P001001   2915918
    ##  5 06    California  P001001  37253956
    ##  6 22    Louisiana   P001001   4533372
    ##  7 21    Kentucky    P001001   4339367
    ##  8 08    Colorado    P001001   5029196
    ##  9 09    Connecticut P001001   3574097
    ## 10 10    Delaware    P001001    897934
    ## # ℹ 42 more rows

## Decenial summary

2020 Decennial Census data are available from the PL 94-171
Redistricting summary file, which is specified with `sumfile = "pl"` and
is also available for 2010. The Redistricting summary files include a
limited subset of variables from the decennial US Census to be used for
legislative redistricting. These variables include total population and
housing units; race and ethnicity; voting-age population; and group
quarters population. For example, the code below retrieves information
on the American Indian & Alaska Native population by state from the 2020
decennial Census.

The argument `sumfile = "pl"` is assumed (and in turn not required) when
users request data for 2020 and will remain so until the main
Demographic and Housing Characteristics File is released in mid-to-late
2022

``` r
aian <- get_decennial(
  geography = "state", 
  variables = "P1_005N", 
  year = 2020, 
  sumfile = "pl"
)
```

    ## Getting data from the 2020 decennial Census

    ## Using the PL 94-171 Redistricting Data Summary File

    ## Note: 2020 decennial Census data use differential privacy, a technique that
    ## introduces errors into data to preserve respondent confidentiality.
    ## ℹ Small counts should be interpreted with caution.
    ## ℹ See https://www.census.gov/library/fact-sheets/2021/protecting-the-confidentiality-of-the-2020-census-redistricting-data.html for additional guidance.
    ## This message is displayed once per session.

``` r
aian
```

    ## # A tibble: 52 × 4
    ##    GEOID NAME                 variable  value
    ##    <chr> <chr>                <chr>     <dbl>
    ##  1 42    Pennsylvania         P1_005N   31052
    ##  2 06    California           P1_005N  631016
    ##  3 54    West Virginia        P1_005N    3706
    ##  4 49    Utah                 P1_005N   41644
    ##  5 36    New York             P1_005N  149690
    ##  6 11    District of Columbia P1_005N    3193
    ##  7 02    Alaska               P1_005N  111575
    ##  8 12    Florida              P1_005N   94795
    ##  9 45    South Carolina       P1_005N   24303
    ## 10 38    North Dakota         P1_005N   38914
    ## # ℹ 42 more rows

## American Community Survey

The example below fetches data on the number of residents born in Mexico
by state.

``` r
born_in_mexico <- get_acs(
  geography = "state", 
  variables = "B05006_150",
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

``` r
born_in_mexico
```

    ## # A tibble: 52 × 5
    ##    GEOID NAME                 variable   estimate   moe
    ##    <chr> <chr>                <chr>         <dbl> <dbl>
    ##  1 01    Alabama              B05006_150    46927  1846
    ##  2 02    Alaska               B05006_150     4181   709
    ##  3 04    Arizona              B05006_150   510639  8028
    ##  4 05    Arkansas             B05006_150    60236  2182
    ##  5 06    California           B05006_150  3962910 25353
    ##  6 08    Colorado             B05006_150   215778  4888
    ##  7 09    Connecticut          B05006_150    28086  2144
    ##  8 10    Delaware             B05006_150    14616  1065
    ##  9 11    District of Columbia B05006_150     4026   761
    ## 10 12    Florida              B05006_150   257933  6418
    ## # ℹ 42 more rows

`survey` defaults to the 5-year ACS; however this can be changed to the
1-year ACS by using the argument `survey = "acs1"`. For example, the
following code will fetch data from the 1-year ACS for 2019:

``` r
born_in_mexico_1yr <- get_acs(
  geography = "state", 
  variables = "B05006_150", 
  survey = "acs1", 
  year = 2019
)
```

    ## Getting data from the 2019 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

``` r
born_in_mexico_1yr
```

    ## # A tibble: 52 × 5
    ##    GEOID NAME                 variable   estimate   moe
    ##    <chr> <chr>                <chr>         <dbl> <dbl>
    ##  1 01    Alabama              B05006_150       NA    NA
    ##  2 02    Alaska               B05006_150       NA    NA
    ##  3 04    Arizona              B05006_150   516618 15863
    ##  4 05    Arkansas             B05006_150       NA    NA
    ##  5 06    California           B05006_150  3951224 40506
    ##  6 08    Colorado             B05006_150   209408 12214
    ##  7 09    Connecticut          B05006_150    26371  4816
    ##  8 10    Delaware             B05006_150       NA    NA
    ##  9 11    District of Columbia B05006_150       NA    NA
    ## 10 12    Florida              B05006_150   261614 17571
    ## # ℹ 42 more rows

Variables from the ACS detailed tables, data profiles, summary tables,
comparison profile, and supplemental estimates are available through
**tidycensus**’s
[`get_acs()`](https://walker-data.com/tidycensus/reference/get_acs.html)
function; the function will auto-detect from which dataset to look for
variables based on their names. Alternatively, users can supply a table
name to the table parameter in get_acs(); this will return data for
every variable in that table. For example, to get all variables
associated with table B01001, which covers sex broken down by age, from
the 2016-2020 5-year ACS:

``` r
age_table <- get_acs(
  geography = "state", 
  table = "B01001", 
  year = 2020, 
  cache_table = T
)
```

    ## Getting data from the 2016-2020 5-year ACS

    ## Loading ACS5 variables for 2020 from table B01001 and caching the dataset for faster future access.

``` r
age_table
```

    ## # A tibble: 2,548 × 5
    ##    GEOID NAME    variable   estimate   moe
    ##    <chr> <chr>   <chr>         <dbl> <dbl>
    ##  1 01    Alabama B01001_001  4893186    NA
    ##  2 01    Alabama B01001_002  2365734  1090
    ##  3 01    Alabama B01001_003   149579   672
    ##  4 01    Alabama B01001_004   150937  2202
    ##  5 01    Alabama B01001_005   160287  2159
    ##  6 01    Alabama B01001_006    96832   565
    ##  7 01    Alabama B01001_007    65459   961
    ##  8 01    Alabama B01001_008    36705  1467
    ##  9 01    Alabama B01001_009    33089  1547
    ## 10 01    Alabama B01001_010    93871  2045
    ## # ℹ 2,538 more rows

## Geography and variables

For core-based statistical areas and zip code tabulation areas, two
heavily-requested geographies, the aliases `"cbsa"` and `"zcta"` can be
used, respectively, to fetch data for those geographies.

``` r
cbsa_population <- get_acs(
  geography = "cbsa", 
  variables = "B01003_001", 
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

``` r
cbsa_population
```

    ## # A tibble: 939 × 5
    ##    GEOID NAME                             variable   estimate   moe
    ##    <chr> <chr>                            <chr>         <dbl> <dbl>
    ##  1 10100 Aberdeen, SD Micro Area          B01003_001    42864    NA
    ##  2 10140 Aberdeen, WA Micro Area          B01003_001    73769    NA
    ##  3 10180 Abilene, TX Metro Area           B01003_001   171354    NA
    ##  4 10220 Ada, OK Micro Area               B01003_001    38385    NA
    ##  5 10300 Adrian, MI Micro Area            B01003_001    98310    NA
    ##  6 10380 Aguadilla-Isabela, PR Metro Area B01003_001   295172    NA
    ##  7 10420 Akron, OH Metro Area             B01003_001   703286    NA
    ##  8 10460 Alamogordo, NM Micro Area        B01003_001    66804    NA
    ##  9 10500 Albany, GA Metro Area            B01003_001   147431    NA
    ## 10 10540 Albany-Lebanon, OR Metro Area    B01003_001   127216    NA
    ## # ℹ 929 more rows

## Geographic subsets

``` r
nm_income <- get_acs(
  geography = "county", 
  variables = "B19013_001", 
  state = "NM", 
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

``` r
nm_income
```

    ## # A tibble: 33 × 5
    ##    GEOID NAME                          variable   estimate   moe
    ##    <chr> <chr>                         <chr>         <dbl> <dbl>
    ##  1 35001 Bernalillo County, New Mexico B19013_001    54308   929
    ##  2 35003 Catron County, New Mexico     B19013_001    36607  8958
    ##  3 35005 Chaves County, New Mexico     B19013_001    46254  2393
    ##  4 35006 Cibola County, New Mexico     B19013_001    44731  3783
    ##  5 35007 Colfax County, New Mexico     B19013_001    36937  4886
    ##  6 35009 Curry County, New Mexico      B19013_001    48903  2442
    ##  7 35011 De Baca County, New Mexico    B19013_001    31532 13343
    ##  8 35013 Doña Ana County, New Mexico   B19013_001    44024  2292
    ##  9 35015 Eddy County, New Mexico       B19013_001    65000  3898
    ## 10 35017 Grant County, New Mexico      B19013_001    37453  3245
    ## # ℹ 23 more rows

Smaller geographies like Census tracts can also be subsetted by county.
Given that Census tracts nest neatly within counties (and do not cross
county boundaries), we can request all Census tracts for a given county
by using the optional `county` parameter.

``` r
bernalillo_income <- get_acs(
  geography = "tract", 
  variables = "B19013_001", 
  state = "NM", 
  county = "Bernalillo", 
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

``` r
bernalillo_income
```

    ## # A tibble: 176 × 5
    ##    GEOID       NAME                                      variable estimate   moe
    ##    <chr>       <chr>                                     <chr>       <dbl> <dbl>
    ##  1 35001000107 Census Tract 1.07, Bernalillo County, Ne… B19013_…    84861 24992
    ##  2 35001000108 Census Tract 1.08, Bernalillo County, Ne… B19013_…    49970 28594
    ##  3 35001000109 Census Tract 1.09, Bernalillo County, Ne… B19013_…    74813 35105
    ##  4 35001000110 Census Tract 1.10, Bernalillo County, Ne… B19013_…    45761 17783
    ##  5 35001000111 Census Tract 1.11, Bernalillo County, Ne… B19013_…   112250 24958
    ##  6 35001000112 Census Tract 1.12, Bernalillo County, Ne… B19013_…    91318  4610
    ##  7 35001000113 Census Tract 1.13, Bernalillo County, Ne… B19013_…    58750 23453
    ##  8 35001000114 Census Tract 1.14, Bernalillo County, Ne… B19013_…    51625 15708
    ##  9 35001000115 Census Tract 1.15, Bernalillo County, Ne… B19013_…    39148 13330
    ## 10 35001000116 Census Tract 1.16, Bernalillo County, Ne… B19013_…    77375 17811
    ## # ℹ 166 more rows

``` r
nrow(nm_income)
```

    ## [1] 33

``` r
nm_income_1yr <- get_acs(
  geography = "county", 
  variables = "B19013_001", 
  state = "NM", 
  year = 2019, 
  survey = "acs1"
)
```

    ## Getting data from the 2019 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

``` r
nm_income_1yr
```

    ## # A tibble: 10 × 5
    ##    GEOID NAME                          variable   estimate   moe
    ##    <chr> <chr>                         <chr>         <dbl> <dbl>
    ##  1 35001 Bernalillo County, New Mexico B19013_001    56115  2291
    ##  2 35005 Chaves County, New Mexico     B19013_001    42003  4911
    ##  3 35013 Doña Ana County, New Mexico   B19013_001    43038  3303
    ##  4 35025 Lea County, New Mexico        B19013_001    68457  9074
    ##  5 35031 McKinley County, New Mexico   B19013_001    37153  4875
    ##  6 35035 Otero County, New Mexico      B19013_001    39371  6361
    ##  7 35043 Sandoval County, New Mexico   B19013_001    71997  4398
    ##  8 35045 San Juan County, New Mexico   B19013_001    44321  3487
    ##  9 35049 Santa Fe County, New Mexico   B19013_001    61298  4088
    ## 10 35061 Valencia County, New Mexico   B19013_001    60601  7102

## Searching for variables

> [`load_variables()`](https://walker-data.com/tidycensus/reference/load_variables.html)

``` r
v16 <- load_variables(2016, "acs5", cache = T)
v16
```

    ## # A tibble: 22,816 × 4
    ##    name        label                                  concept          geography
    ##    <chr>       <chr>                                  <chr>            <chr>    
    ##  1 B00001_001  Estimate!!Total                        UNWEIGHTED SAMP… block gr…
    ##  2 B00002_001  Estimate!!Total                        UNWEIGHTED SAMP… block gr…
    ##  3 B01001A_001 Estimate!!Total                        SEX BY AGE (WHI… tract    
    ##  4 B01001A_002 Estimate!!Total!!Male                  SEX BY AGE (WHI… tract    
    ##  5 B01001A_003 Estimate!!Total!!Male!!Under 5 years   SEX BY AGE (WHI… tract    
    ##  6 B01001A_004 Estimate!!Total!!Male!!5 to 9 years    SEX BY AGE (WHI… tract    
    ##  7 B01001A_005 Estimate!!Total!!Male!!10 to 14 years  SEX BY AGE (WHI… tract    
    ##  8 B01001A_006 Estimate!!Total!!Male!!15 to 17 years  SEX BY AGE (WHI… tract    
    ##  9 B01001A_007 Estimate!!Total!!Male!!18 and 19 years SEX BY AGE (WHI… tract    
    ## 10 B01001A_008 Estimate!!Total!!Male!!20 to 24 years  SEX BY AGE (WHI… tract    
    ## # ℹ 22,806 more rows

``` r
View(v16)
```

By default, **tidycensus** returns a tibble of ACS or decennial Census
data in “tidy” format. For decennial Census data, this will include four
columns:

-   `GEOID`, representing the Census ID code that uniquely identifies
    the geographic unit;
-   `NAME`, which represents a descriptive name of the unit;
-   `variable`, which contains information on the Census variable name
    corresponding to that row;
-   `value`, which contains the data values for each unit-variable
    combination. For ACS data, two columns replace the `value` column:
    `estimate`, which represents the ACS estimate, and `moe`,
    representing the margin of error around that estimate.

## Data structures

``` r
hhinc <- get_acs(
  geography = "state", 
  table = "B19001", 
  survey = "acs1",
  year = 2016
)
```

    ## Getting data from the 2016 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Loading ACS1 variables for 2016 from table B19001. To cache this dataset for faster access to ACS tables in the future, run this function with `cache_table = TRUE`. You only need to do this once per ACS dataset.

``` r
hhinc
```

    ## # A tibble: 884 × 5
    ##    GEOID NAME    variable   estimate   moe
    ##    <chr> <chr>   <chr>         <dbl> <dbl>
    ##  1 01    Alabama B19001_001  1852518 12189
    ##  2 01    Alabama B19001_002   176641  6328
    ##  3 01    Alabama B19001_003   120590  5347
    ##  4 01    Alabama B19001_004   117332  5956
    ##  5 01    Alabama B19001_005   108912  5308
    ##  6 01    Alabama B19001_006   102080  4740
    ##  7 01    Alabama B19001_007   103366  5246
    ##  8 01    Alabama B19001_008    91011  4699
    ##  9 01    Alabama B19001_009    86996  4418
    ## 10 01    Alabama B19001_010    74864  4210
    ## # ℹ 874 more rows

``` r
hhinc_wide <- get_acs(
  geography = "state", 
  table = "B19001", 
  survey = "acs1",
  year = 2016, 
  output = "wide"
)
```

    ## Getting data from the 2016 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Loading ACS1 variables for 2016 from table B19001. To cache this dataset for faster access to ACS tables in the future, run this function with `cache_table = TRUE`. You only need to do this once per ACS dataset.

``` r
hhinc_wide
```

    ## # A tibble: 52 × 36
    ##    GEOID NAME        B19001_001E B19001_001M B19001_002E B19001_002M B19001_003E
    ##    <chr> <chr>             <dbl>       <dbl>       <dbl>       <dbl>       <dbl>
    ##  1 28    Mississippi     1091245        8803      113124        4835       87136
    ##  2 29    Missouri        2372190       10844      160615        6705      122649
    ##  3 30    Montana          416125        4426       26734        2183       24786
    ##  4 31    Nebraska         747562        4452       45794        3116       33266
    ##  5 32    Nevada          1055158        6433       68507        4886       42720
    ##  6 33    New Hampsh…      520643        5191       20890        2566       15933
    ##  7 34    New Jersey      3194519       10274      170029        6836      118862
    ##  8 35    New Mexico       758364        6296       66983        4439       48930
    ##  9 36    New York        7209054       17665      543763       12132      352029
    ## 10 37    North Caro…     3882423       16063      282491        7816      228088
    ## # ℹ 42 more rows
    ## # ℹ 29 more variables: B19001_003M <dbl>, B19001_004E <dbl>, B19001_004M <dbl>,
    ## #   B19001_005E <dbl>, B19001_005M <dbl>, B19001_006E <dbl>, B19001_006M <dbl>,
    ## #   B19001_007E <dbl>, B19001_007M <dbl>, B19001_008E <dbl>, B19001_008M <dbl>,
    ## #   B19001_009E <dbl>, B19001_009M <dbl>, B19001_010E <dbl>, B19001_010M <dbl>,
    ## #   B19001_011E <dbl>, B19001_011M <dbl>, B19001_012E <dbl>, B19001_012M <dbl>,
    ## #   B19001_013E <dbl>, B19001_013M <dbl>, B19001_014E <dbl>, …

## GEOIDs

``` r
bernalillo_blocks <- get_decennial(
  geography = "block", 
  variables = "H1_001N",
  state = "NM", 
  county = "Bernalillo", 
  year = 2020, 
  sumfile = "pl"
)
```

    ## Getting data from the 2020 decennial Census

    ## Using the PL 94-171 Redistricting Data Summary File

``` r
bernalillo_blocks
```

    ## # A tibble: 11,943 × 4
    ##    GEOID           NAME                                           variable value
    ##    <chr>           <chr>                                          <chr>    <dbl>
    ##  1 350010001071000 Block 1000, Block Group 1, Census Tract 1.07,… H1_001N    154
    ##  2 350010001071001 Block 1001, Block Group 1, Census Tract 1.07,… H1_001N     13
    ##  3 350010001071002 Block 1002, Block Group 1, Census Tract 1.07,… H1_001N     13
    ##  4 350010001071004 Block 1004, Block Group 1, Census Tract 1.07,… H1_001N     14
    ##  5 350010001071005 Block 1005, Block Group 1, Census Tract 1.07,… H1_001N    356
    ##  6 350010001071006 Block 1006, Block Group 1, Census Tract 1.07,… H1_001N     41
    ##  7 350010001071007 Block 1007, Block Group 1, Census Tract 1.07,… H1_001N     19
    ##  8 350010001071008 Block 1008, Block Group 1, Census Tract 1.07,… H1_001N     37
    ##  9 350010001071009 Block 1009, Block Group 1, Census Tract 1.07,… H1_001N     19
    ## 10 350010001071012 Block 1012, Block Group 1, Census Tract 1.07,… H1_001N     34
    ## # ℹ 11,933 more rows

The GEOID value breaks down as follows:

-   The first two digits, **40**, correspond to the [Federal Information
    Processing Series (FIPS)
    code](https://www.census.gov/library/reference/code-lists/ansi.html)
    for the state of Oklahoma. All states and US territories, along with
    other geographies at which the Census Bureau tabulates data, will
    have a FIPS code that can uniquely identify that geography.
-   Digits 3 through 5, **025**, are representative of Cimarron County.
    These three digits will uniquely identify Cimarron County within
    Oklahoma. County codes are generally combined with their
    corresponding state codes to uniquely identify a county within the
    United States, as three-digit codes will be repeated across states.
    Cimarron County’s code in this example would be **40025**.
-   The next six digits, **950300**, represent the block’s Census tract.
    The tract name in the `NAME` column is Census Tract 9503; the
    six-digit tract ID is right-padded with zeroes.
-   The twelfth digit, **1**, represents the parent block group of the
    Census block. As there are no more than nine block groups in any
    Census tract, the block group name will not exceed 9.
-   The last three digits, **110**, represent the individual Census
    block, though these digits are combined with the parent block group
    digit to form the block’s name.

## Renaming variables

``` r
nm <- get_acs(
  geography = "county", 
  state = "New Mexico", 
  variables = c(medinc = "B19013_001", 
                medage = "B01002_001"), 
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

``` r
nm
```

    ## # A tibble: 66 × 5
    ##    GEOID NAME                          variable estimate    moe
    ##    <chr> <chr>                         <chr>       <dbl>  <dbl>
    ##  1 35001 Bernalillo County, New Mexico medage       38      0.2
    ##  2 35001 Bernalillo County, New Mexico medinc    54308    929  
    ##  3 35003 Catron County, New Mexico     medage       59.4    2.6
    ##  4 35003 Catron County, New Mexico     medinc    36607   8958  
    ##  5 35005 Chaves County, New Mexico     medage       36.1    0.3
    ##  6 35005 Chaves County, New Mexico     medinc    46254   2393  
    ##  7 35006 Cibola County, New Mexico     medage       37.5    0.7
    ##  8 35006 Cibola County, New Mexico     medinc    44731   3783  
    ##  9 35007 Colfax County, New Mexico     medage       50.3    0.6
    ## 10 35007 Colfax County, New Mexico     medinc    36937   4886  
    ## # ℹ 56 more rows

``` r
nm_wide <- get_acs(
  geography = "county", 
  state = "New Mexico", 
  variables = c(medinc = "B19013_001", 
                medage = "B01002_001"), 
  output = "wide",
  year = 2020
)
```

    ## Getting data from the 2016-2020 5-year ACS

``` r
nm_wide
```

    ## # A tibble: 33 × 6
    ##    GEOID NAME                         medincE medincM medageE medageM
    ##    <chr> <chr>                          <dbl>   <dbl>   <dbl>   <dbl>
    ##  1 35003 Catron County, New Mexico      36607    8958    59.4     2.6
    ##  2 35005 Chaves County, New Mexico      46254    2393    36.1     0.3
    ##  3 35006 Cibola County, New Mexico      44731    3783    37.5     0.7
    ##  4 35007 Colfax County, New Mexico      36937    4886    50.3     0.6
    ##  5 35009 Curry County, New Mexico       48903    2442    31.7     0.3
    ##  6 35011 De Baca County, New Mexico     31532   13343    22.2     6.9
    ##  7 35013 Doña Ana County, New Mexico    44024    2292    33.3     0.2
    ##  8 35015 Eddy County, New Mexico        65000    3898    35.4     0.3
    ##  9 35017 Grant County, New Mexico       37453    3245    46.5     0.4
    ## 10 35019 Guadalupe County, New Mexico   31061    5288    43.7     4.6
    ## # ℹ 23 more rows

## Get estimates

One advantage of using the PEP to retrieve data is that allows you to
access the indicators used to produce the intercensal population
estimates. These indicators can be specified as variables direction in
the
[`get_estimates()`](https://walker-data.com/tidycensus/reference/get_estimates.html)
function in **tidycensus**, or requested in bulk by using the `product`
argument. The products available include `"population"`, `"components"`,
`"housing"`, and `"characteristics"`. For example, we can request all
components of change population estimates for 2019 for a specific county

``` r
library(tidyverse)

bernalillo_components <- get_estimates(
  geography = "county", 
  product = "components", 
  state = "NM", 
  county = "Bernalillo", 
  year = 2019
)
bernalillo_components
```

    ## # A tibble: 12 × 4
    ##    NAME                          GEOID variable              value
    ##    <chr>                         <chr> <chr>                 <dbl>
    ##  1 Bernalillo County, New Mexico 35001 BIRTHS            7130     
    ##  2 Bernalillo County, New Mexico 35001 DEATHS            5949     
    ##  3 Bernalillo County, New Mexico 35001 DOMESTICMIG       -824     
    ##  4 Bernalillo County, New Mexico 35001 INTERNATIONALMIG   773     
    ##  5 Bernalillo County, New Mexico 35001 NATURALINC        1181     
    ##  6 Bernalillo County, New Mexico 35001 NETMIG             -51     
    ##  7 Bernalillo County, New Mexico 35001 RBIRTH              10.5   
    ##  8 Bernalillo County, New Mexico 35001 RDEATH               8.77  
    ##  9 Bernalillo County, New Mexico 35001 RDOMESTICMIG        -1.21  
    ## 10 Bernalillo County, New Mexico 35001 RINTERNATIONALMIG    1.14  
    ## 11 Bernalillo County, New Mexico 35001 RNATURALINC          1.74  
    ## 12 Bernalillo County, New Mexico 35001 RNETMIG             -0.0752

The `product = "characteristics"` argument also has some unique options.
The argument `breakdown` lets users get breakdowns of population
estimates for the US, states, and counties by `"AGEGROUP"`, `"RACE"`,
`"SEX"`, or `"HISP"` (Hispanic origin). If set to `TRUE`, the
`breakdown_labels` argument will return informative labels for the
population estimates. For example, to get population estimates by sex
and Hispanic origin for metropolitan areas, we can use the following
code:

``` r
nm_sex_hisp <- get_estimates(
  geography = "state", 
  product = "characteristics", 
  breakdown = c("SEX", "HISP"), 
  breakdown_labels = T,
  state = "NM", 
  year = 2019
)
nm_sex_hisp
```

    ## # A tibble: 9 × 5
    ##   GEOID NAME         value SEX        HISP                 
    ##   <chr> <chr>        <dbl> <chr>      <chr>                
    ## 1 35    New Mexico 2096829 Both sexes Both Hispanic Origins
    ## 2 35    New Mexico 1063887 Both sexes Non-Hispanic         
    ## 3 35    New Mexico 1032942 Both sexes Hispanic             
    ## 4 35    New Mexico 1037432 Male       Both Hispanic Origins
    ## 5 35    New Mexico  525161 Male       Non-Hispanic         
    ## 6 35    New Mexico  512271 Male       Hispanic             
    ## 7 35    New Mexico 1059397 Female     Both Hispanic Origins
    ## 8 35    New Mexico  538726 Female     Non-Hispanic         
    ## 9 35    New Mexico  520671 Female     Hispanic

## Get flows

``` r
bernalillo_migration <- get_flows(
  geography = "county", 
  state = "NM", 
  county = "Bernalillo", 
  year = 2019
)
bernalillo_migration
```

    ## # A tibble: 2,316 × 7
    ##    GEOID1 GEOID2 FULL1_NAME                   FULL2_NAME variable estimate   moe
    ##    <chr>  <chr>  <chr>                        <chr>      <chr>       <dbl> <dbl>
    ##  1 35001  <NA>   Bernalillo County, New Mexi… Africa     MOVEDIN       124    94
    ##  2 35001  <NA>   Bernalillo County, New Mexi… Africa     MOVEDOUT       NA    NA
    ##  3 35001  <NA>   Bernalillo County, New Mexi… Africa     MOVEDNET       NA    NA
    ##  4 35001  <NA>   Bernalillo County, New Mexi… Asia       MOVEDIN       960   335
    ##  5 35001  <NA>   Bernalillo County, New Mexi… Asia       MOVEDOUT       NA    NA
    ##  6 35001  <NA>   Bernalillo County, New Mexi… Asia       MOVEDNET       NA    NA
    ##  7 35001  <NA>   Bernalillo County, New Mexi… Central A… MOVEDIN      1239   596
    ##  8 35001  <NA>   Bernalillo County, New Mexi… Central A… MOVEDOUT       NA    NA
    ##  9 35001  <NA>   Bernalillo County, New Mexi… Central A… MOVEDNET       NA    NA
    ## 10 35001  <NA>   Bernalillo County, New Mexi… Caribbean  MOVEDIN        39    48
    ## # ℹ 2,306 more rows

## Debugging errors

To assist with debugging errors, or more generally to help users
understand how **tidycensus** functions are being translated to Census
API calls, **tidycensus** offers a parameter `show_call` that when set
to `TRUE` prints out the actual API call that **tidycensus** is making
to the Census API.

``` r
cbsa_bachelors <- get_acs(
  geography = "cbsa",
  variables = "DP02_0068P",
  year = 2019,
  show_call = TRUE
)
```

    ## Getting data from the 2015-2019 5-year ACS

    ## Using the ACS Data Profile

    ## Census API call: https://api.census.gov/data/2019/acs/acs5/profile?get=DP02_0068PE%2CDP02_0068PM%2CNAME&for=metropolitan%20statistical%20area%2Fmicropolitan%20statistical%20area%3A%2A
