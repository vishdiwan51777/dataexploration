#Libraries
library(tidyverse)
library(jtools)
library(car)
library(readr)
library(purrr)
library(lubridate)
library(ggplot2)
library(dplyr)


'The College Scorecard was released at the start of September 2015. 
Among colleges that predominantly grant bachelor’s degrees, did it result in 
more student interest in high-earnings colleges relative to low-earnings ones 
(as proxied by Google searches for keywords associated with those colleges)?'

#Data
Latest_Scorecard <- read_csv("Lab3_Rawdata/Most+Recent+Cohorts+(Scorecard+Elements).csv")

name_link <- read_csv("Lab3_Rawdata/id_name_link.csv") %>% rename(OPEID = opeid) %>%
  rename(UNITID = unitid) %>% distinct(schname, .keep_all = TRUE)


files <- list.files(path = 'Lab3_Rawdata', pattern = 'trends_up_to_')

prepend <- function(fname) {
  paste('Lab3_Rawdata/', fname, sep = '')
}

trends <- files %>%
  map(prepend) %>%
  map(read_csv) %>%
  reduce(rbind)


#Cleaning up data
ID_Scorecard <- merge(x = name_link, y = Latest_Scorecard, by = c('UNITID', 'OPEID'), all.x = TRUE)

scorecard_all <- merge(x = ID_Scorecard, y = trends, by = 'schname', all.x = TRUE)

scorecard_all <- scorecard_all %>% select(-INSTNM)

scorecard_all <- scorecard_all %>% na.omit()

clean_data <- scorecard_all %>%
  rename(med_earnings = 'md_earn_wne_p10-REPORTED-EARNINGS') %>%
  filter(PREDDEG == 3) %>%
  filter(med_earnings != 'NULL') %>%
  filter(med_earnings != 'PrivacySuppressed') %>%
  mutate(med_earnings = as.numeric(med_earnings))

clean_data <- clean_data %>%
  select('UNITID', 'OPEID', 'schname', 'PREDDEG', 'keyword', 'monthorweek', 'keynum', 'index',
         'med_earnings', 'CONTROL')

median_earnings <- median(clean_data$med_earnings)

#Gives us the median of 41,800 which will be used to filter through high and low earnings.

standard_scorecard <- clean_data %>%
  group_by(keynum) %>%
  summarise(sd_index = (index - mean(index)) / sd(index), schname, CONTROL, keyword, monthorweek, keynum, med_earnings, sd_index)

#High earnings vs Low Earnings

standard_scorecard$High_Earn <- ifelse(standard_scorecard$med_earnings >= median_earnings, 1, 0)

preSept15 <- standard_scorecard %>% 
  mutate(DATE = substr(monthorweek, 1, 10)) %>%
  mutate(DATE = as.Date(DATE)) %>%
  filter(DATE < '2015-09-01')


postSept15 <- standard_scorecard %>% 
  mutate(DATE = substr(monthorweek, 1, 10)) %>%
  mutate(DATE = as.Date(DATE)) %>%
  filter(DATE >= '2015-09-01')  

#Regressions of models, pre and post 2015
m1 <- lm(data = preSept15, med_earnings ~ sd_index + High_Earn + factor(CONTROL))
m2 <- lm(data = postSept15, med_earnings ~ sd_index + High_Earn + factor(CONTROL))

export_summs(m1, m2)

#plot coefs:
plot_coefs(m1, m2)

histogram <- ggplot(data = standard_scorecard) +  
  geom_histogram(mapping = aes(x = med_earnings), binwidth = 1000) +
  labs(x = "Median Earnings", title = "Distribution of Median Earnings")
histogram

