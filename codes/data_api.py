# Importing libraries
import os
import json
import time
import requests
import datetime
import dateutil
import pandas as pd
from dateutil.relativedelta import relativedelta


# Specify start and end of time
end = datetime.date.today()
start = end - relativedelta(years=3)

# Making a list of all the months and years that fall into that category
months_in_range = [x.split(' ') for x in pd.date_range(start, end, freq='MS').strftime("%Y %-m").tolist()]

# Checking if the list outputs correct values
print(months_in_range)


# Fetching API Key from a file where key is stored

api_key = pd.read_csv("./data/api_key.csv")
api_key = str(api_key['api_key'][0])

print(api_key)


# Sending Request to the API
def send_request(date):
    '''Sends a request to the NYT Archive API for given date.'''
    base_url = 'https://api.nytimes.com/svc/archive/v1/'
    url = base_url + '/' + date[0] + '/' + date[1] + '.json?api-key=' + api_key
    response = requests.get(url).json()
    time.sleep(6)
    return response

# Checking if that particular article exists
def is_valid(article, date):
    '''An article is only worth checking if it is in range, and has a headline.'''
    is_in_range = date > start and date < end
    has_headline = type(article['headline']) == dict and 'main' in article['headline'].keys()
    return is_in_range and has_headline

# Parsing the response from API into nice pandas data frame
def parse_response(response):
    '''Parses and returns response as pandas data frame.'''
    data = {'headline': [],  
        'date': [], 
        'doc_type': [],
        'material_type': [],
        'section': [],
        'keywords': [],
        'source': [],
        'news_desk':[],
        'word_count':[]
        }
    
    articles = response['response']['docs'] 

    for article in articles: # For each article, make sure it falls within our date range
        date = dateutil.parser.parse(article['pub_date']).date()
        if is_valid(article, date):
            data['date'].append(date)
            data['headline'].append(article['headline']['main']) 
            if 'section' in article:
                data['section'].append(article['section_name'])
            else:
                data['section'].append(None)

            if 'source' in article:
                data['source'].append(article['source'])
            else:
                data['source'].append(None)
            
            if 'news_desk' in article:
                data['news_desk'].append(article['news_desk'])
            else:
                data['news_desk'].append(None)

            data['doc_type'].append(article['document_type'])

            data['word_count'].append(article['word_count'])

            if 'type_of_material' in article: 
                data['material_type'].append(article['type_of_material'])
            else:
                data['material_type'].append(None)
            keywords = [keyword['value'] for keyword in article['keywords'] if keyword['name'] == 'subject']
            data['keywords'].append(keywords)
    return pd.DataFrame(data) 

# Storing  pandas dataframes of every month into separate csv file
def get_data(dates):
    '''Sends and parses request/response to/from NYT Archive API for given dates.'''
    total = 0
    print('Date range: ' + str(dates[0]) + ' to ' + str(dates[-1]))
    if not os.path.exists('./data/headlines'):
        os.mkdir('./data/headlines')
    for date in dates:
        response = send_request(date)
        df = parse_response(response)
        total += len(df)
        df.to_csv('./data/headlines/' + date[0] + '-' + date[1] + '.csv', index=False)
        print('Saving headlines/' + date[0] + '-' + date[1] + '.csv...')
    print('Number of articles collected: ' + str(total))



# Making function call
get_data(months_in_range)


# Citation:
# Code from :
#https://towardsdatascience.com/collecting-data-from-the-new-york-times-over-any-period-of-time-3e365504004