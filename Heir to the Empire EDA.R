
### Exploratory analysis of the average review score of Heir to the Empire over time

# Loading the required functions and libraries
source("func_scrape_amazon_reviews.R")
library(dplyr)
library(ggplot2)

## Extract the data from Amazon and save it down as a csv - this can be slow to run
# heir_data <- extract_reviews("0553296124", 8)
# write.csv(input, "data/heir_data.csv", row.names = FALSE)

# Loading in the data
heir_data <- read.csv("data/heir_data.csv")

cutdown_data <- heir_data[, c("Date", "Review_Score")]
cutdown_data$Date <- as.Date(cutdown_data$Date)

cutdown_data <- arrange(cutdown_data, Date)
cutdown_data$avg_review <- round(cummean(cutdown_data$Review_Score), 2)


# Lets create a dataframe of movie release dates to add to our graphs
movies <- c("The Force Awakens", "Rogue One", "The Last Jedi", "Solo")
release_dates <- as.Date(c("2015-12-18", "2016-12-16", "2017-12-15", "2018-05-25"))
movie_releases <- data.frame(movies, release_dates)


## Lets focus on reviews in the lead-up to the sequel trilogy's announcement
ggplot(cutdown_data, aes(x=Date, y=avg_review)) +
  geom_line(size = 2, color = "#E7B800") +
  geom_point() +
  theme_bw() +
  ylim(0,5) +  
  ylab("Average Review Score") +
  scale_x_date(date_breaks = "3 month", date_minor_breaks = "1 month", date_labels = "%b %Y", limits = as.Date(c('2014-01-01','2018-12-31'))) +
  geom_vline(xintercept = movie_releases$release_dates) + 
  geom_text(data = movie_releases, aes(x=release_dates, y = 3), label=movies, vjust=-0.5, size=4, angle = 90)


## Exploring review density over time, from 2014 onwards
my_plot <- ggplot(cutdown_data, aes(x=Date)) +
  geom_density(size = 2, color = "#E7B800") +
  theme_bw() +
  scale_x_date(date_breaks = "3 month", date_minor_breaks = "1 month", date_labels = "%b %Y", limits = as.Date(c('2014-01-01','2018-12-31'))) +
  geom_vline(xintercept = movie_releases$release_dates) 

text_position <- mean(ggplot_build(my_plot)$layout$panel_scales_y[[1]]$range$range)

my_plot + geom_text(data = movie_releases, 
            aes(x=release_dates, y = text_position), 
            label=movies, vjust=-0.5, size=4, angle = 90)



