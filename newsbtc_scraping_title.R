#NewsBTC scraping

setwd('/Users/gabo/Documents/Thesis/Data/Text')

library(rvest)
library(dplyr)
library(lubridate)
library(stringr)


get_page_data <- function(url){
  #Getting the html code of the url
  response <- read_html(url)
  #Extracting the title
  title <- response %>% html_nodes(".u-0VdJpTxYZXx7XoFQiqBo26pXHWzz7LX0_close-link , .jeg_post_title a") %>% html_text()
  #Extracting the date
  date <- response %>% html_nodes(".jeg_meta_date a") %>% html_text() %>% mdy()
  link <- response %>% html_nodes(".u-0VdJpTxYZXx7XoFQiqBo26pXHWzz7LX0_close-link , .jeg_post_title a") %>% html_attr("href")
  #deleting unneccessary 
  df <- data.frame(date,title,link)
  return(df)
}

get_max_page <- function(url){
  #Getting the html code of the url
  response <- read_html(url)
  page_num <- response %>% html_nodes(".page_number") %>% html_text() %>% str_trim()
  max_page <- page_num[length(page_num)]
  max_page <- as.integer(gsub(",", "", max_page))
  return(max_page)
}
#c("Bitcoin","BTC","Ethereum","ETH","Ether","Cardano","ADA","Solana","SOL","Ripple","XRP","Polkadot","DOT","Litecoin","LTC","Chainlink","LINK","Dogecoin","DOGE",
keywords <- c("Binance","BNB")
url_base <- 'https://www.newsbtc.com/page/1/?s='

for (keyword in keywords){
  url <- paste0(url_base,keyword)
  i <- 1
  data0 <- get_page_data(url)
  data_merged <- data0
  page_max <- get_max_page(url)
  
  while (page_max>i){
    i<-i+1
    print(i)
    #Find the postion of the ? question mark in the url
    modified_url <- sub("/page/[0-9]+/", paste0("/page/", i, "/"), url)
    data <- get_page_data(modified_url)
    data_merged <- rbind(data_merged,data)
    #Sys.sleep(2)
  }
  
  file_name <- paste0('NewsBTC_titles_',keyword,'.csv')
  write.csv(data_merged,file_name)
}
# 
# keyword <- keywords[2]
# url <- paste0(url_base,keyword)
# i <- 766
# data0 <- get_page_data(url)
# data_merged <- data0
# page_max <- get_max_page(url)
# while (page_max>i){
#   i<-i+1
#   print(i)
#   modified_url <- sub("/page/[0-9]+/", paste0("/page/", i, "/"), url)
#   data <- get_page_data(modified_url)
#   data_merged <- rbind(data_merged,data)
#   #Sys.sleep(2)
# }
# 
# file_name <- paste0('NewsBTC_titles_',keyword,'1285.csv')
# write.csv(data_merged,file_name)
