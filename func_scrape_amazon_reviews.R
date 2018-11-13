
### Creating a generalisable function to download all the reviews for a given product ID

library(dplyr)
library(rvest)
library(purrr)


### Function inputs
product_id <- "0553296124"



# Find out how many pages of reviews there are
base_url <- paste0("https://www.amazon.co.uk/product-reviews/", product_id)

num_of_pages <- base_url %>% 
  read_html() %>% 
  html_nodes('.totalReviewCount') %>%      
  html_text() %>% 
  as.integer() %>% `/`(10) %>% round()



# Now iterate through each page of reviews, extracting the 10 reviews

#loop_url <- paste0("https://www.amazon.co.uk/product-reviews/", product_id, "/?pageNumber=", page_num)
loop_url <- paste0("https://www.amazon.co.uk/product-reviews/", product_id, "/?pageNumber=", "3")

df <- read_html(loop_url) %>% 
  html_nodes('.view-point .a-col-left') %>% 
  map_df(~list(Reviewer = html_nodes(.x, '.a-profile-name') %>% 
                 html_text(),
               Date = html_nodes(.x, '.review-date') %>% 
                 html_text(),
               Title = html_nodes(.x, '#cm_cr-review_list .a-color-base') %>% 
                 html_text(),
               Review_Text = html_nodes(.x, '.review-text') %>% 
                 html_text(),
               Review_Score = html_nodes(.x, 'span.a-icon-alt') %>% 
                 html_text() %>% substr(1, 3) %>% as.numeric()
              )
          )


