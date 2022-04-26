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
library(plotly)


# Reading in data set
nyt_sentiment <- read_csv("./data/avi_munging.csv")

# Top 20 sections
top_section <- c("U.S.",
                 "Opinion",
                 "World",
                 "Arts",
                 "New York",
                 "Business Day",
                 "The Learning Network",
                 "Real Estate",
                 "Well",
                 "Food",
                 "Sports",
                 "Magazine",
                 "Crosswords & Games",
                 "Health",
                 "Style",
                 "Books",
                 "Science",
                 "Podcasts",
                 "The Upshot",
                 "Technology")


# Get avg sentiment for top 20 sections
sentiment_plot1 <- nyt_sentiment |> 
  group_by(section,is_popular) |> summarise(avg_sentiment = mean(compound)) |> 
  filter(section %in% top_section)



sentiment_plot <- sentiment_plot1 |>   ggplot()+
  geom_bar(mapping = aes(
    y = avg_sentiment,
    x = reorder(section,avg_sentiment),
    fill = is_popular
  ),stat = "identity",
  position = "stack",
  show.legend = FALSE
  )+geom_rect(mapping=aes
              (xmin=0, 
                xmax=14.5, 
                ymin=-1, 
                ymax=0), 
              fill="#fcae91", alpha=0.02) +
  geom_rect(mapping=aes
            (xmin=0, 
              xmax=14.5, 
              ymin=0, 
              ymax=1), 
            fill="#66c2a4", alpha=0.02) +
  theme_light()+
  scale_fill_manual(values = c(Yes = "#fdc086", No = "#beaed4"))+
  labs(
    x = "Number of Features",
    y = "Section",
    title = paste0("<span style='font-size:14pt'>Average
    <span style='color:#66c2a4;'>Positive</span> and
    <span style='color:#fb6a4a;'>Negative</span> sentiment score
    </span><br><span style='font-size:11pt'>For
    <span style='color:#fdc086;'>Popular</span> and
    <span style='color:#beaed4;'>Not Popular</span> articles
    </span>"))+
  theme(
    plot.title = element_markdown(lineheight = 1.1,hjust = 0.5),
    plot.caption = element_markdown(lineheight = 1.1),
    legend.text = element_markdown(size = 11),
    axis.title = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    axis.text.y = element_blank(),
    panel.border = element_blank())+ coord_polar()
ggsave("./images/sentiment_plot_avi.png", plot = sentiment_plot)
sentiment_plot
