# ---------------------------------------------------------------------
# Loading in the libraries
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


# Reading in data set
nyt_articles <- read_csv("./data/nyt-articles-2020.csv")

# checking missing values
nyt_articles |> 
  miss_var_summary() |> 
  ggplot(aes(x = stats::reorder(variable, n_miss),
             y = n_miss)) +
  geom_bar(stat = "identity",
           position = "dodge",
           width = 0.05,
           show.legend = FALSE) + 
  geom_point() +
  coord_flip() +
  theme_classic()+
  labs(
    x = "Variables",
    y = "Count of missing values",
    title = paste0("**Initial plot of *missing* values**"),
    # caption = "<span style='font-size:8pt'>Data by:
    # <span style='color:#756bb1;'>Dr. Katsuhiko Takabayashi</span> <br> Graph by:
    # <span style='color:#756bb1;'>Avi Arora</span>
    # </span>"
      )+
    theme(
      plot.title = element_markdown(lineheight = 1.5),
      plot.caption = element_markdown(lineheight = 1.1))


# Since Subsection is almost empty, we remove it
nyt_articles <- nyt_articles |> select(-subsection)


# Generating Target variable

# To maintain class balance, we define popularity by something close to the median
median(nyt_articles$n_comments)


# Create the function.
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

getmode(nyt_articles$n_comments)



# Since the median comes out to be 87, we chose 100 as the cut off number
nyt_articles <- nyt_articles |> mutate(is_popular = case_when(
  n_comments >= 100 ~ "Yes",
  TRUE ~ "No"
))

# Check if the headline has a question or not
# In general, question marks could seem like an invitation to comment
nyt_articles <- nyt_articles |> mutate(contains_question = case_when(
  grepl("\\?",headline) ~ "Yes",
  TRUE ~ "No"
))


# Getting hour of the day

nyt_articles <- nyt_articles |> mutate(hour = format(pub_date,"%H"))
nyt_articles$hour <- as.numeric(nyt_articles$hour)   


# Getting month
nyt_articles <- nyt_articles |> mutate(month = format(pub_date,"%m"))
nyt_articles$month <- as.numeric(nyt_articles$month)


# Generating if article was published on weekend or weekday

nyt_articles <- nyt_articles |> mutate(is_weekend <- isWeekend(pub_date))




write.csv(nyt_articles,file = "./data/avi_munging.csv",row.names = FALSE)

