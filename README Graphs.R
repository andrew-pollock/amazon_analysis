
library(dplyr)
library(ggplot2)


## Creating the graphs for the README

heir_data <- read.csv("data/heir_data.csv")


## Graph 1 - When are the reviews from?

review_score_data <- heir_data[, c("Date", "Review_Score")]
review_score_data$Date <- as.Date(review_score_data$Date)

ggplot(review_score_data, aes(x=Date)) +
  geom_histogram() +
  theme_bw() +
  ## Add title, remove y grid lines, 
  scale_x_date(date_breaks = "1 year", date_labels = "%b %Y", limits = as.Date(c('2008-01-01','2018-12-31')))

# Reviews are quite sporadic prior to 2012, so going forward we'll focus on reviews from 2012 onwards



## Graph 2 - How has the average review score changed over time?

review_score_data <- arrange(review_score_data, Date)
review_score_data$avg_review <- round(cummean(review_score_data$Review_Score), 3)

## A date can have multiple reviews (thus multiple rows in the above table), here we take the last row for each date
cum_avg_review <- review_score_data %>% 
  group_by(Date) %>% 
  slice(n())

# Creating a DF of movies and their release dates
movie_releases <- data.frame("movies" = c("The Force Awakens", "Rogue One", "The Last Jedi", "Solo"),
                             "release_dates" = as.Date(c("2015-12-18", "2016-12-16", "2017-12-15", "2018-05-25")))


ggplot(cum_avg_review, aes(x=Date, y=avg_review)) +
  geom_line(size = 2) +
  theme_bw() +
  ylim(4.25,4.6) +  
  ylab("Average Review Score") +
  scale_x_date(date_breaks = "6 month", date_labels = "%b %Y", limits = as.Date(c('2010-01-01','2018-12-31')), expand=c(0,0)) +
  geom_vline(xintercept = movie_releases$release_dates) + 
  geom_text(data = movie_releases, aes(x=release_dates, y = 4.35), label=movie_releases$movies, vjust=-0.5, size=4, angle = 90) +
  geom_vline(xintercept = as.Date("2014-11-28"), linetype="longdash") +
  geom_text(x=as.Date("2014-11-28"), y = 4.35, label="Force Awakens Trailer", vjust=-0.5, size=4, angle = 90)

# The cumulative average review score is relatively stable... But it steadily increases in the build up to the release of 

# Can we overlay maths to fit this statistically??? In the meantime...

# Lets fit two linear models, seperated at the release of the Force Awakens to compare the trends
# Instead of calculating these manually, we'll make a group
cum_avg_review$TFA_Ind <- "Pre-Buyout"
cum_avg_review[cum_avg_review$Date >= '2012-10-30',]$TFA_Ind <- "Before TFA"
cum_avg_review[cum_avg_review$Date >= '2015-12-08',]$TFA_Ind <- "After TFA"

ggplot(cum_avg_review, aes(x=Date, y=avg_review)) +
  geom_line(size = 2) +
  theme_bw() +
  ylim(4.25,4.6) +  
  ylab("Average Review Score") +
  scale_x_date(date_breaks = "6 month", date_labels = "%b %Y", limits = as.Date(c('2010-01-01','2018-12-31')), expand=c(0,0)) +
  geom_vline(xintercept = movie_releases$release_dates) + 
  geom_text(data = movie_releases, aes(x=release_dates, y = 4.35), label=movie_releases$movies, vjust=-0.5, size=4, angle = 90) +
  geom_vline(xintercept = as.Date("2014-11-28"), linetype="longdash") +
  geom_text(x=as.Date("2014-11-28"), y = 4.35, label="Force Awakens Trailer", vjust=-0.5, size=4, angle = 90) +
  geom_vline(xintercept = as.Date("2012-10-30"), linetype="longdash") +
  geom_text(x=as.Date("2012-10-30"), y = 4.35, label="Disney Buyout Announced", vjust=-0.5, size=4, angle = 90) +
  geom_smooth(method='lm', aes(color = TFA_Ind), se=F, size = 1.5, linetype = "longdash")

# By manually fitting linear models we can look at the coefficients

pre_buyout <- lm(avg_review ~ Date, data = cum_avg_review[cum_avg_review$Date > '2010-01-01' & cum_avg_review$Date < '2012-10-30',])
before_TFA <- lm(avg_review ~ Date, data = cum_avg_review[cum_avg_review$Date > '2012-10-30' & cum_avg_review$Date < '2015-12-08',])
after_TFA  <- lm(avg_review ~ Date, data = cum_avg_review[cum_avg_review$Date >= '2015-12-08' & cum_avg_review$Date < '2018-12-31',])

format(pre_buyout$coefficients[2], scientific = F)
format(before_TFA$coefficients[2], scientific = F)
format(after_TFA$coefficients[2], scientific = F)










