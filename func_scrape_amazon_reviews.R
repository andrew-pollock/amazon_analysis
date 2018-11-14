
### Creating a generalisable function to download all the reviews for a given product ID

extract_reviews <- function(product_id = NULL) {

  library(dplyr)
  library(rvest)
  library(purrr)
  library(lubridate)


# Find out how many pages of reviews there are
  uk_url <- paste0("https://www.amazon.co.uk/product-reviews/", product_id)
  us_url <- paste0("https://www.amazon.com/product-reviews/", product_id)

  num_of_pages_uk <- uk_url %>% 
    read_html() %>% 
    html_nodes('.totalReviewCount') %>%      
    html_text() %>% 
    as.integer() %>% `/`(10) %>% ceiling()

  num_of_pages_us <- us_url %>%
    read_html() %>%
    html_nodes('.totalReviewCount') %>%
    html_text() %>%
    as.integer() %>% `/`(10) %>% ceiling()
  
  
  datalist <- list()

  # Iterate through UK reviews
  for (page_number in 1:num_of_pages_uk) {
    
    loop_url <- paste0("https://www.amazon.co.uk/product-reviews/", product_id, "/?pageNumber=", page_number)

    Sys.sleep(runif(1, 3, 5)) ## Pause for 3 to 5 seconds

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

    df$Country <- "UK"
    df$Date <- dmy(df$Date)
    datalist[[page_number]] <- df
    
  }  

  # Iterate through US reviews
  for (page_number in 1:num_of_pages_us) {
    
    loop_url <- paste0("https://www.amazon.com/product-reviews/", product_id, "/?pageNumber=", page_number)
    
    Sys.sleep(runif(1, 3, 5)) ## Pause for 3 to 5 seconds
    
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
    
    df$Country <- "US"
    df$Date <- mdy(df$Date)
    datalist[[page_number+num_of_pages_uk]] <- df
    
  }
  
  combined_review_data <- bind_rows(datalist)

}