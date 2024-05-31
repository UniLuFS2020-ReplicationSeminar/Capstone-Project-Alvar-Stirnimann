# Data Extraction R-Script

#Load Libraries
library(httr)
library(jsonlite)
library(readxl)

## Download GDP Data
# URL of the XLS file of GDP in Switzerland
url_gdp <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/28405424/master"

# Destination file path on your local machine
file_destination_gdp <- file.path(getwd(), "data_orig", "data_original_gdp.xlsx")

# Download the file and save to "data_orig" folder
download.file(url_gdp, file_destination_gdp, mode="wb")

## Download detailed Tourism Data 2022
# URL of the Excel file
url_tourism_2022 <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/30405413/appendix"

# Destination file path on your local machine
file_destination_tourism_2022 <- file.path(getwd(), "data_orig", "data_original_tourism_2022.xlsx")

# Download the file and save to "data_orig" folder
download.file(url_tourism_2022, file_destination_tourism_2022, mode="wb")

## Download detailed Tourism Data 2018
# URL of the Excel file
url_tourism_2018 <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/11507546/appendix"

# Destination file path on your local machine
file_destination_tourism_2018 <- file.path(getwd(), "data_orig", "data_original_tourism_2018.xlsx")

# Download the file and save to "data_orig" folder
download.file(url_tourism_2018, file_destination_tourism_2018, mode="wb")

## Download resident data per canton
url_resident <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/30148653/master"

# Destination file path on your local machine
file_destination_residents <- file.path(getwd(), "data_orig", "data_original_residents.xlsx")

# Download the file and save to "data_orig" folder
download.file(url_resident, file_destination_residents, mode="wb")
