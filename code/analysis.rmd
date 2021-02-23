---
title: "Analysis"
author: "Vishaal Diwan"
date: "2/21/2021"
output: html_document
---

```{r, echo=FALSE, results='hide', message=FALSE, warning=FALSE}
source('../Documents/R/omsba_5300/dataexploration/code/data_exploration.R', local = FALSE)
```

##Purpose
As people and organizations rely more and more on data for their decision making, more and more big sets of data have begun to be gathered for decision making. At the start of September 2015, the College Scorecard was released. The scorecard's function was to give prospective students all sorts of information about the universities they can and will be applying to so they can make the best decision on what university would be the best place for them to succeeed. In this assignment our objective was to determine the interest in colleges that predominantly grant bachelor's degrees and see if the scorecard has influenced students decisions and if that would result in more student interest in high-earnings college as opposed to those that are low earnings. In the data we combined and looked through, the college scorecard data was combined with data taken from Google Trends which showed keyword searches that were assocciated with those colleges. Personally, I think the scorecard is a great idea and heading into the assignment, I definitley thought that the data will show students looking more into schools that have high earnings averages/potential. 

##Median Earnings
First and foremost, median earnings needs to be calculated because that is how we will differentiate between high and low earning schools. That treshold number is $41,800. What that means for us is that 10 years after graduation, schools where students are making above $41,800 will be considered high earnings schools while conversely, those making below that average ammount will be low earnings schools. 

##Models


```{r}
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
