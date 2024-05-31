## Data Preparation Residents

# Load libraries
library(readxl)
library(dplyr)
library(readr)

# Load the data
resident_data <- read_excel("data_orig/data_original_residents.xlsx")

# Check the structure of the data
head(resident_data, n=20)

# Check the column names to ensure you're referencing them correctly in the next steps
colnames(resident_data)

## Extract data from each sheet
# Get sheet names
sheet_names <- excel_sheets("data_orig/data_original_residents.xlsx")
print(sheet_names)

# Load the data 2021
resident_data_2021 <- read_excel("data_orig/data_original_residents.xlsx", sheet = "2021")

# Load the data 2020
resident_data_2020 <- read_excel("data_orig/data_original_residents.xlsx", sheet = "2020")

# Load the data 2019
resident_data_2019 <- read_excel("data_orig/data_original_residents.xlsx", sheet = "2019")

# Load the data 2018
resident_data_2018 <- read_excel("data_orig/data_original_residents.xlsx", sheet = "2018")

# Load the data 2017
resident_data_2017 <- read_excel("data_orig/data_original_residents.xlsx", sheet = "2017")

# Load the data 2016
resident_data_2016 <- read_excel("data_orig/data_original_residents.xlsx", sheet = "2016")

# Load the data 2015
resident_data_2015 <- read_excel("data_orig/data_original_residents.xlsx", sheet = "2015")

# Load the data 2014
resident_data_2014 <- read_excel("data_orig/data_original_residents.xlsx", sheet = "2014")

# Check the structure of the data
print(head(resident_data_2021, n=35), n=35)
head(resident_data_2020, n=20)
head(resident_data_2019, n=20)
head(resident_data_2018, n=20)
head(resident_data_2017, n=20)
head(resident_data_2016, n=20)
head(resident_data_2015, n=20)
print(head(resident_data_2014, n=35),n=35)

# Select Data from each sheet and rename columns
# 2014
selected_resident_data_2014 <- resident_data_2014[-c(1:8, 35:nrow(resident_data_2014)), c(1, 4)]
colnames(selected_resident_data_2014) <- c("Canton", "2014_workers")

print(head(selected_resident_data_2014, n=30), n=30)

#2015
selected_resident_data_2015 <- resident_data_2015[-c(1:8, 35:nrow(resident_data_2015)), c(1, 4)]
colnames(selected_resident_data_2015) <- c("Canton", "2015_workers")

# 2016
selected_resident_data_2016 <- resident_data_2016[-c(1:8, 35:nrow(resident_data_2016)), c(1, 4)]
colnames(selected_resident_data_2016) <- c("Canton", "2016_workers")

# 2017
selected_resident_data_2017 <- resident_data_2017[-c(1:8, 35:nrow(resident_data_2017)), c(1, 4)]
colnames(selected_resident_data_2017) <- c("Canton", "2017_workers")

# 2018
selected_resident_data_2018 <- resident_data_2018[-c(1:8, 35:nrow(resident_data_2018)), c(1, 4)]
colnames(selected_resident_data_2018) <- c("Canton", "2018_workers")

# 2019
selected_resident_data_2019 <- resident_data_2019[-c(1:8, 35:nrow(resident_data_2019)), c(1, 4)]
colnames(selected_resident_data_2019) <- c("Canton", "2019_workers")

# 2020
selected_resident_data_2020 <- resident_data_2020[-c(1:8, 35:nrow(resident_data_2020)), c(1, 4)]
colnames(selected_resident_data_2020) <- c("Canton", "2020_workers")

# 2021
selected_resident_data_2021 <- resident_data_2021[-c(1:8, 35:nrow(resident_data_2021)), c(1, 4)]
colnames(selected_resident_data_2021) <- c("Canton", "2021_workers")

print(head(selected_resident_data_2021, n=30), n=30)


# Combine the selected data
resident_data_combined <- left_join(selected_resident_data_2014, selected_resident_data_2015, by = "Canton")
resident_data_combined <- left_join(resident_data_combined, selected_resident_data_2016, by = "Canton")
resident_data_combined <- left_join(resident_data_combined, selected_resident_data_2017, by = "Canton")
resident_data_combined <- left_join(resident_data_combined, selected_resident_data_2018, by = "Canton")
resident_data_combined <- left_join(resident_data_combined, selected_resident_data_2019, by = "Canton")
resident_data_combined <- left_join(resident_data_combined, selected_resident_data_2020, by = "Canton")
resident_data_combined <- left_join(resident_data_combined, selected_resident_data_2021, by = "Canton")

# Check
print(head(resident_data_combined, n=30), n=30)

# Create Regions from cantons mapping
canton_to_region <- data.frame(
  Canton = c("Zürich", "Bern / Berne", "Luzern", "Uri", "Schwyz", "Obwalden", "Nidwalden", "Glarus", "Zug", "Fribourg / Freiburg", "Solothurn", "Basel-Stadt", "Basel-Landschaft", "Schaffhausen", "Appenzell Ausserrhoden", "Appenzell Innerrhoden", "St. Gallen", "Graubünden / Grigioni / Grischun", "Aargau", "Thurgau", "Ticino", "Vaud", "Valais / Wallis", "Neuchâtel", "Genève", "Jura"),
  Region = c("Zürich Region", "Bern Region", "Zentralschweiz", "Zentralschweiz", "Zentralschweiz", "Zentralschweiz", "Zentralschweiz", "Ostschweiz", "Zentralschweiz", "Fribourg Region", "Aargau und Solothurn Region", "Basel Region", "Basel Region", "Ostschweiz", "Ostschweiz", "Ostschweiz", "Ostschweiz", "Graubünden", "Aargau und Solothurn Region", "Ostschweiz", "Tessin", "Waadt", "Wallis", "Jura & Drei-Seen-Land", "Genf", "Jura & Drei-Seen-Land")
)

# Join the GDP data with the region mapping
mapped_worker_data <- resident_data_combined %>%
  right_join(canton_to_region, by = c("Canton" = "Canton"))

# Check
print(head(mapped_worker_data, n = 30), n = 30)

# Convert character columns to numeric
mapped_worker_data[2:9] <- lapply(mapped_worker_data[2:9], as.numeric)

# Summarize GDP by region
workers_by_region <- mapped_worker_data %>%
  group_by(Region) %>%
  summarise(across(`2014_workers`:`2021_workers`, sum, na.rm = TRUE))

# View the summarized data
print(workers_by_region)

# Save to CSV
write.csv(workers_by_region, file.path(getwd(), "data_prep", "data_prep_workers.csv"))