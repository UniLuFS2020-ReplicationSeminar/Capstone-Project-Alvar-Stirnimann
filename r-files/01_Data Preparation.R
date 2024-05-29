### Data Preparation

# Load libraries
library(readxl)
library(dplyr)
library(readr)
install.packages("dplyr")

# Load the data
gdp_data <- read_excel("data_orig/data_original_gdp.xlsx")
tourism_data <- read_excel("data_orig/data_original_tourism_2022.xlsx", sheet = "T2.2.6")

# Check the structure of the data
head(gdp_data)
head(tourism_data)

# Check the column names to ensure you're referencing them correctly in the next steps
colnames(gdp_data)
colnames(tourism_data)

## Data Preparation Tourism
selected_data_tourism <- tourism_data[-c(1,2,3), c(1, 4, 7, 10, 13)]
head(selected_data_tourism)
colnames(selected_data_tourism)

# Drop columns with all NA values
selected_data_tourism <- selected_data_tourism

# Rename columns
data_renamed_tourism <- selected_data_tourism %>%
  rename(
    "Region" = 1,
    "2019" = 2,
    "2020" = 3,
    "2021" = 4,
    "2022" = 5
  )

# Check
head(data_renamed_tourism, n = 20)

# Drop Columns after Aargau and Solothurn Region
data_tourism_final <- data_renamed_tourism[-c(15:26),]
head(data_tourism_final, n = 20)

# Save to CSV
write.csv(data_tourism_final, file.path(getwd(), "data_prep", "data_prep_tourism_2022.csv"))


## Data Preparation GDP

          