#NewsBTC scraping

library(rvest)
library(dplyr)
library(lubridate)
library(stringr)

output_folder <- '/Users/gabo/Documents/Thesis/Data/Text/NewsBTC/Full'
input_folder <- '/Users/gabo/Documents/Thesis/Data/Text/NewsBTC/Titles'
setwd(input_folder)

get_article_body <- function(url){
  #Getting the html code of the url
  response <- read_html(url)
  #Extracting the title
  extracted_body <- response %>% html_nodes(".content-inner span") %>% html_text()
  if (length(extracted_body)==0){
    extracted_body <- response %>% html_nodes(".content-inner p") %>% html_text()
  }
  combined_body <- paste(extracted_body, collapse = " ")
  return(combined_body)
}

file_names <- list.files(path = input_folder)

for (file_name in file_names){
  input_df <- read.csv(file_name,row.names=1)
  input_df$body <- ''
  max_row <- nrow(input_df)
  for (i in 1:max_row){
    print(paste0(file_name," | ",i,':',max_row))
    url <- input_df$link[i]
    body <- get_article_body(url)
    input_df$body[i] <- body
  }
  output_name <- paste0(output_folder,'/',file_name)
  write.csv(input_df,output_name)

}

