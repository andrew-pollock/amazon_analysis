# Amazon Reviews Web Scraping
## Summary
Creating a simple R function using [rvest](https://github.com/hadley/rvest) to scrape all reviews for a given Amazon product ID from their UK and US sites.



## Exploratory Analysis
To test out the function I used it to extract all reviews for the Thrawn trilogy of Star Wars novels. The first of these, Heir to the Empire, is probably the most popular Star Wars EU book ever written, so I was interested in how the new Star Wars movies impacted it's popularity and rating.


``` r
source("func_scrape_amazon_reviews.R")
library(dplyr)
library(ggplot2)

heir_data <- extract_reviews("0553296124", 8)
head(heir_data, 2) 

#>  Date        Title                            Review_Text                               Review_Score Country
#> 1 2017-01-09 a well-written Star Wars novel   This was the first novel of the Star War~            4 UK     
#> 2 2016-03-11 This trilogy is a must read for~ Timothy Zahn is a great writer and story~            5 UK  

```

