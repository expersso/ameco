AMECO Dataset
=============

[![Travis-CI Build
Status](https://travis-ci.org/expersso/ameco.svg?branch=master)](https://travis-ci.org/expersso/ameco)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/ameco)](https://cran.r-project.org/package=ameco)
[![CRAN\_Logs\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/ameco)](https://cran.r-project.org/package=ameco)

This package contains the entire [European Commission Annual
macro-economic (AMECO)
database](http://ec.europa.eu/economy_finance/db_indicators/ameco/index_en.htm)
in a format amenable to analysis in R.

Install it from either CRAN or Github:

``` r
# From CRAN
install.packages("ameco")

# From Github
devtools::install_github("expersso/ameco")
```

Simple example
--------------

The dataset is in a clean, long format:

``` r
library(dplyr)
library(ameco)
head(ameco)
```

    ## # A tibble: 6 x 8
    ##   code              country   sub.chapter  title  unit  cntry  year  value
    ##   <chr>             <chr>     <chr>        <chr>  <chr> <chr> <dbl>  <dbl>
    ## 1 EU28.1.0.0.0.NPTD European~ 01 Populati~ Total~ 1000~ EU28   1960 409118
    ## 2 EU15.1.0.0.0.NPTD European~ 01 Populati~ Total~ 1000~ EU15   1960 316765
    ## 3 EA19.1.0.0.0.NPTD Euro area 01 Populati~ Total~ 1000~ EA19   1960 265029
    ## 4 EA12.1.0.0.0.NPTD Euro are~ 01 Populati~ Total~ 1000~ EA12   1960 252350
    ## 5 DU15.1.0.0.0.NPTD EU15 (in~ 01 Populati~ Total~ 1000~ DU15   1960 299421
    ## 6 DA12.1.0.0.0.NPTD EA12 (in~ 01 Populati~ Total~ 1000~ DA12   1960 235006

Filtering with the `sub.chapter` variable allows you to easily find the
variable of interest:

``` r
ameco %>% 
  filter(sub.chapter == "01 Population") %>% 
  .$title %>% 
  unique()
```

    ## [1] "Total population (National accounts)"
    ## [2] "Total population"                    
    ## [3] "Population: 0 to 14 years"           
    ## [4] "Population: 15 to 64 years"          
    ## [5] "Population: 65 years and over"

Being interested in the total population of a few countries, we can
easily subset the data and plot the results:

``` r
library(ggplot2)

ameco %>% 
  filter(title == "Total population",
         year == 2015,
         cntry %in% c("USA", "JPN", "DEU", "FRA", "ESP", "ITA")) %>% 
  ggplot(aes(x = reorder(country, -value), y = value / 1000)) +
  geom_bar(stat = "identity") +
  theme_bw() +
  labs(x = NULL, y = "Population (millions)", title = "Total population")
```

![](example-1.png)

Disclaimer
----------

This package is not affiliated with, nor endorsed by, the European
Commission. I aim to update it whenever the AMECO database is updated.
If you ever see that it is out-of-date, don’t hesitate to send a pull
request and/or remind me to update it.
