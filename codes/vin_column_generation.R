## Loading libraries
library(tidyverse)
library(janitor)
library(lubridate)
library(skimr)
library(knitr)
library(naniar)
library(GGally)
library(styler)
library(ggtext)
library(data.table)
library(grid)
library(timeDate)
library(ggplot2)
library(plotly)

## Lets read in our data 

df <-  read.csv("nyt-articles-2020.csv")

## Lets calculate the number of keywords in the keywords column

df$Number_keywords <- lengths(lapply(strsplit(as.character(df$keywords),
                                              "[][']|,\\s*"), function(x) x[nzchar(x)])) 

## Checking our df
head(df)

## Writing this to a csv

write.csv(df,"number_keywords_column.csv")