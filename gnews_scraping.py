from gnews import GNews
from datetime import datetime, timedelta
import pandas as pd

keywords =  ["Bitcoin","BTC","Ethereum", "ETH","Cardano","ADA","Solana"," SOL ","Ripple",
             " XRP ","Polkadot"," DOT ","Litecoin"," LTC ","Chainlink","Dogecoin"," DOGE ","Binance"," BNB "]

# Define the start and end dates
start_date = datetime(2017, 1, 1)
end_date = datetime(2024, 10, 1)
one_day = timedelta(days=1)

for keyword in keywords:
    #Start of keyword loop
    current_start_date = start_date
    df = pd.DataFrame(columns=['date', 'title','encoded_url','source','keyword'])

    while current_start_date < end_date:
        print(keyword + ' | ' + str(current_start_date))
        current_end_date = current_start_date + one_day
        google_news = GNews(max_results = 100,start_date = current_start_date, end_date = current_end_date,language='english')

        json_resp = google_news.get_news(keyword)

        df_daily = pd.DataFrame(columns=['date', 'title','encoded_url','keyword'])
        df_daily = df_daily.reindex(range(len(json_resp)))
        df_daily['keyword'] = keyword
        encoded_urls = []

        for i in range(len(json_resp)):
            df_daily['date'][i] = json_resp[i]['published date']
            df_daily['title'][i] = json_resp[i]['title']
            df_daily['encoded_url'] = json_resp[i]['url']
            df_daily['source'] = json_resp[i]['publisher']['href']
            #encoded_urls.append(json_resp[i]['url'])
        #articles_params = [get_decoding_params(urlparse(url).path.split("/")[-1]) for url in encoded_urls]
        #decoded_urls = decode_urls(articles_params)
        #df_daily['decoded_url'] = decoded_urls

        df = pd.concat([df, df_daily], ignore_index=True)  
        current_start_date += one_day

    file_path = f'/Users/gabo/Documents/Thesis/Data/Text/GNews/{keyword}_GNews_headlines.csv'
    df.to_csv(file_path, index=False)
