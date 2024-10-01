# master-thesis

I'm conducting research for my Master's Thesis in Financial Econometrics at the University of Amsterdam. The topic of my research is the relationship between market sentiment and bubbles on cryptocurrency markets. By performing NLP on crypto related news articles, I will work out a sentiment-driven market bubble detection model. 

I perform webscraping to collect crypto related news articles using NewsCatcherAPI https://newscatcherapi.com/ . Subsequently, I use pre-trained NLP models from https://huggingface.co to construct a sentiment index for certain cryptocurrencies. Using this sentiment index, I use ML approaches to work out a model that detects market bubbles based on shifts in the sentiment index and market activity.
