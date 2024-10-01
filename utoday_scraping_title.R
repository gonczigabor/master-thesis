#NewsBTC scraping

setwd('/Users/gabo/Documents/Thesis/Data/Text/U_Today')

library(rvest)
library(dplyr)
library(lubridate)
library(stringr)

get_page_data <- function(url){
  #Getting the html code of the url
  response <- read_html(url)
  #Extracting the title
  title <- response %>% html_nodes(".search-result .news__item-title") %>% html_text()
  #Extracting the date
  type <- response %>% html_nodes(".search-result .humble__row a") %>% html_text()
  title <- title[!(type %in% c("Event", "Airdrops","Partners"))]
  dates <- response %>% html_nodes(".search-result .humble__row .humble") %>% html_text()
  dates
  date <- mdy_hm(gsub(" - ", " ", dates))
  link <- response %>% html_nodes(".search-result .news__item-body") %>% html_attr("href")
  link <- link[!(type %in% c("Event", "Airdrops","Partners"))]
  #deleting unneccessary 
  df <- data.frame(date,title,link,keyword)
  return(df)
}

get_max_page <- function(url){
  #Getting the html code of the url
  response <- read_html(url)
  page_num <- response %>% html_nodes(".pag-nav__btn") %>% html_text() %>% str_trim()
  max_page <- length(page_num)
  return(max_page)
}

keywords <- c("Bitcoin","BTC","Ethereum","ETH","Ether","Cardano","ADA","Solana","SOL","Ripple","XRP","Polkadot","DOT","Litecoin","LTC","Chainlink","LINK","Dogecoin","DOGE","Binance","BNB")
url_base <- 'https://u.today/search/node?keys=KEYWORD&_wrapper_format=html&page='

for (keyword in keywords){
  url <- gsub("KEYWORD",keyword,url_base)
  i <- 1
  page_max <- get_max_page(url)
  data_merged <- data.frame(
    date = as.POSIXct(character()),  # Empty POSIXct column
    title = character(),              # Empty character column
    link = character(),               # Empty character column
    keyword = character(),            # Empty character column
    stringsAsFactors = FALSE          # Avoid converting to factors
  )
  
  while (page_max>i){
    print(paste0(keyword," | ",i))
    page_num <- i-1
    #Find the postion of the ? question mark in the url
    modified_url <- paste0(url,page_num)
    data <- get_page_data(modified_url)
    data_merged <- rbind(data_merged,data)
    #Sys.sleep(2)
    i<-i+1
  }
  
  file_name <- paste0('U_Today_titles_',keyword,'.csv')
  write.csv(data_merged,file_name)
}
