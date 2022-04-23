import datetime as dt
from nytimes_scraper import run_scraper, scrape_month
import pandas as pd



# Fetching API Key from a file where key is stored

api_key = pd.read_csv("./data/api_key.csv")
api_key = str(api_key['api_key'][0])

print(api_key)

# scrape Jan of 2020
article_df, comment_df = scrape_month(api_key, date=dt.date(2020, 1, 1))