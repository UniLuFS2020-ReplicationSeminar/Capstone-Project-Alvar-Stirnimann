### Data Preparation Tourism Data

# Load libraries
library(readxl)
library(dplyr)
library(readr)

## Tourism Data 2018 - 2022
# Load the data
tourism_data <- read_excel("data_orig/data_original_tourism_2022.xlsx", sheet = "T2.2.6")


# Check the structure of the data
head(tourism_data)

# Check the column names to ensure you're referencing them correctly in the next steps
colnames(tourism_data)

# Select Data
selected_data_tourism <- tourism_data[-c(1,2,3), c(1, 4, 7, 10, 13)]
head(selected_data_tourism)
colnames(selected_data_tourism)


# Rename columns
data_renamed_tourism <- selected_data_tourism %>%
  rename(
    "Region" = 1,
    "2018" = 2,
    "2019" = 3,
    "2020" = 4,
    "2021" = 5
  )

# Check
head(data_renamed_tourism, n = 20)

# Drop Columns after Aargau and Solothurn Region
data_tourism_final <- data_renamed_tourism[-c(15:26),]
head(data_tourism_final, n = 20)

# Save to CSV
write.csv(data_tourism_final, file.path(getwd(), "data_prep", "data_prep_tourism_2022.csv"))


## Tourism Data 2018
# Load the data
tourism_data_2018 <- read_excel("data_orig/data_original_tourism_2018.xlsx", sheet = "T2.2.8")


# Check the structure of the data
head(tourism_data_2018)

# Check the column names to ensure you're referencing them correctly in the next steps
colnames(tourism_data_2018)

# Select Data
selected_data_tourism_2018 <- tourism_data_2018[-c(1,2,3), c(1, 4, 7, 10, 13)]
head(selected_data_tourism_2018)
colnames(selected_data_tourism_2018)


# Rename columns
data_renamed_tourism_2018 <- selected_data_tourism_2018 %>%
  rename(
    "Region" = 1,
    "2018" = 2,
    "2019" = 3,
    "2020" = 4,
    "2021" = 5
  )

# Check
head(data_renamed_tourism_2018, n = 20)

# Drop Columns after Aargau and Solothurn Region
data_tourism_final_2018 <- data_renamed_tourism_2018[-c(15:26),]
head(data_tourism_final_2018, n = 20)

# Save to CSV
write.csv(data_tourism_final_2018, file.path(getwd(), "data_prep", "data_prep_tourism_2018.csv"))

          