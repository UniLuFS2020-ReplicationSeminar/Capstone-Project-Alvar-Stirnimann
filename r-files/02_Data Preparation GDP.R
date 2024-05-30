## Data Preparation GDP

# Load libraries
library(readxl)
library(dplyr)
library(readr)

# 2. GDP Data
# Load the data
gdp_data <- read_excel("data_orig/data_original_gdp.xlsx")

# Check the structure of the data
head(gdp_data)

# Check the column names to ensure you're referencing them correctly in the next steps
colnames(gdp_data)

# Select Data
selected_data_tourism <- tourism_data[-c(1,2,3), c(1, 4, 7, 10, 13)]