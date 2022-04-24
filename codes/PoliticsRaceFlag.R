### Script used to generate flags on whether or not an article is discusses race or politics
## This will be based on the keywords present for each articles

# Libraries
library(ggplot2)
library(ggthemes)

# Load in default dataset
data = read.csv('../data/nyt-articles-2020.csv')

# Generate list of key words we are searching for that will identify if an article discusses race
race_keywords = c('Race ','Minorities','Black People','Asian-Americans','Ethnicity')
political_keywords = c('Trump','Biden','Democratic Party','Sanders','Warren','Buttigieg','Politics','Government','Impeachment','Republican Party')

# Initialize new columns
data['is_racial'] = 0
data['is_political'] = 0

# Loop through the data, and update the flagging variables = 0 to = 1 if they contain a marked keyword
for(i in 1:nrow(data)){
  #check for race
  for(raceKW in race_keywords){
    if(grepl(raceKW, data$keywords[i])){
      data$is_racial[i] = 1
    }
  }
  #check for politics
  for(politicsKW in political_keywords){
    if(grepl(politicsKW, data$keywords[i])){
      data$is_political[i] = 1
    }
  }
}

# Let's make some visualizations to better understand the data now!
# generate new DF to plot some visualizations
counts = table(data$is_racial, data$is_political)
counts = data.frame(counts)
colnames(counts)[1] = 'is_racial'
colnames(counts)[2] = 'is_political'

### Let's make a Bar Graph showing Racial and Political Presence
Race_Politics_Barplot = ggplot(data = counts, aes(x = is_political, y = Freq, fill = is_racial)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  xlab('is_political') +
  ylab('Frequency') +
  scale_fill_manual(values=c("darkred",
                             "black",
                             "red",
                             "darkblue")) +
  ggtitle('Frequency of Political and Racial NYT articles') +
  theme(text = element_text(family = 'mono'),
        axis.text.y = element_text(size = 7, angle = 0),
        axis.text.x = element_text(size = 11),
        axis.title.y = element_text(size = 14),
        axis.title.x = element_text(size = 12),
        plot.title = element_text(size = 18),
        plot.background = element_rect(fill = '#fff1d4'),
        panel.background = element_rect(fill = '#fff1d4'),
        panel.grid.major = element_line(colour ='#e3d5b8'),
        panel.grid.minor = element_line(colour ='#e3d5b8'),
        legend.background = element_rect(fill = '#fff1d4'))

ggsave('../images/Race_Politics_BarPlot.png', plot = Race_Politics_Barplot)
# plot(Race_Politics_Barplot)

# Write new CSV to dir
# write.csv(data, file = '../data/oli_munging.csv')
