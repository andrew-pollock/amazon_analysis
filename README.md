# Amazon Reviews Web Scraping
## Summary
Creating a simple R function using [rvest](https://github.com/hadley/rvest) to scrape the Date, Title, Text, Score and Country of all reviews for a given Amazon product ID from both Amazon US and Amazon UK.

## Function Overview
The extract_reviews function can be used by sourcing [func_scrape_amazon_reviews.R](func_scrape_amazon_reviews.R). It takes two arguments – the first is a text string containing the unique product ID for the product you’re interested in (this is the alphanumeric string immediately following “/dp/” in the product’s URL). The second argument is optional with a default value of 5 – it specifies how long (in seconds) to pause between scraping each page of reviews.

## Exploratory Analysis
To test out the function I've used it to extract all reviews for the Thrawn trilogy of Star Wars novels. The first of these, Heir to the Empire, is probably the most popular Star Wars EU book ever written, so I was interested in how the new Star Wars movies impacted it's popularity and average rating.

### Getting the Data
Step one is sourcing the function and using it to extract the review data from all 1,045 reviews for Heir to the Empire (product ID 0553296124).

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

