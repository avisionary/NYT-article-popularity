#import the library
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
import pandas as pd
from tqdm import tqdm


# Connect tqdm to pandas
tqdm.pandas()


#calculate the negative, positive, neutral and compound scores, plus verbal evaluation
def sentiment_vader(sentence):

    # Create a SentimentIntensityAnalyzer object.
    sid_obj = SentimentIntensityAnalyzer()

    sentiment_dict = sid_obj.polarity_scores(sentence['text'])
    sentence['negative'] = sentiment_dict['neg']
    sentence['neutral'] = sentiment_dict['neu']
    sentence['positive'] = sentiment_dict['pos']
    sentence['compound'] = sentiment_dict['compound']

    if sentiment_dict['compound'] >= 0.05 :
        sentence['overall_sentiment'] = "Positive"

    elif sentiment_dict['compound'] <= - 0.05 :
        sentence['overall_sentiment'] = "Negative"

    else :
        sentence['overall_sentiment'] = "Neutral"
  
    return sentence

nyt_articles = pd.read_csv("./data/avi_munging.csv")

nyt_articles = nyt_articles.progress_apply(sentiment_vader, axis=1)

print(nyt_articles.head())

# Saving data frame with sentiment
nyt_articles.to_csv('./data/avi_munging.csv', index=False)

