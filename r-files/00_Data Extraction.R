# Data Extraction R-Script
install.packages("readxl")

#Load Libraries
library(httr)
library(jsonlite)
library(readxl)

# Set the API
url <- "https://ckan.opendata.swiss/api/3/action/package_show?id=schweizer-tourismusstatistik-2022"

# Make a GET request to the API
response <- GET(url)

# Check status
status_code(response)

# Parse JSON data from the response
data <- content(response, "parsed")

# Print the entire JSON to understand its structure
print(data)

# Access specific parts of the JSON, e.g., to find the URL of the actual data files
resources <- data$result$resources  # This path might change based on the actual JSON structure

# Extract URLs for downloadable files
urls <- sapply(resources, function(x) x$url)
print(urls)

# URL of the Excel file
url <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/30405414/appendix"

# Destination file path on your local machine
file_destination <- file.path(getwd(), "data_orig", "data_original.xlsx")

# Download the file and save to "data_orig" folder
download.file(url, file_destination, mode="wb")
