# Data Extraction R-Script
install.packages("readxl")

#Load Libraries
library(httr)
library(jsonlite)
library(readxl)

## Download Toursim Data
# URL of the XLS file of Tourism Activity in Switzerland
url <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/29045003/master"

# Destination file path on your local machine
file_destination <- file.path(getwd(), "data_orig", "data_original_tourism.xlsx")

# Download the file and save to "data_orig" folder
download.file(url, file_destination, mode="wb")

## Download GDP Data
# URL of the XLS file of GDP in Switzerland
url_gdp <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/28405424/master"

# Destination file path on your local machine
file_destination_gdp <- file.path(getwd(), "data_orig", "data_original_gdp.xlsx")

# Download the file and save to "data_orig" folder
download.file(url_gdp, file_destination_gdp, mode="wb")

## Download detailed Tourism Data
# URL of the Excel file
url_tourism_2022 <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/30405413/appendix"

# Destination file path on your local machine
file_destination_tourism_2022 <- file.path(getwd(), "data_orig", "data_original_tourism_2022.xlsx")

# Download the file and save to "data_orig" folder
download.file(url_tourism_2022, file_destination_tourism_2022, mode="wb")

## Download Population Data
