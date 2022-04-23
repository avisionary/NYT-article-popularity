import pandas as pd

api_key = pd.read_csv("./data/api_key.csv")

api_key = str(api_key['api_key'][0])

print(api_key)