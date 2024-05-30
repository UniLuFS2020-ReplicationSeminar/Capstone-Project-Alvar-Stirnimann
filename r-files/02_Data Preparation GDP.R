## Data Preparation GDP

# Load libraries
library(readxl)
library(dplyr)
library(readr)

# 2. GDP Data
# Load the data
gdp_data <- read_excel("data_orig/data_original_gdp.xlsx")

# Check the structure of the data
head(gdp_data, n=20)

# Check the column names to ensure you're referencing them correctly in the next steps
colnames(gdp_data)

# Select Data
selected_gdp_data <- gdp_data[-c(1,3), c(1, 8:15)]

# Print the first 30 entries of the DataFrame
print(head(selected_gdp_data, n = 30), n = 30)

# Rename columns appropriately, assuming the first column is 'Canton'
colnames(selected_gdp_data) <- c("Canton", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021")

# Drop unused rows
selected_gdp_data <- selected_gdp_data[-c(1,28:nrow(selected_gdp_data)),]
print(head(selected_gdp_data, n = 30), n = 30)

# Create Regions from cantons mapping
canton_to_region <- data.frame(
  Canton = c("Zürich", "Bern", "Luzern", "Uri", "Schwyz", "Obwalden", "Nidwalden", "Glarus", "Zug", "Freiburg", "Solothurn", "Basel-Stadt", "Basel-Landschaft", "Schaffhausen", "Appenzell A. Rh.", "Appenzell I. Rh.", "St. Gallen", "Graubünden", "Aargau", "Thurgau", "Tessin", "Waadt", "Wallis", "Neuenburg", "Genf", "Jura"),
  Region = c("Zürich Region", "Bern Region", "Zentralschweiz", "Zentralschweiz", "Zentralschweiz", "Zentralschweiz", "Zentralschweiz", "Ostschweiz", "Zentralschweiz", "Fribourg Region", "Aargau und Solothurn Region", "Basel Region", "Basel Region", "Ostschweiz", "Ostschweiz", "Ostschweiz", "Ostschweiz", "Graubünden", "Aargau und Solothurn Region", "Ostschweiz", "Tessin", "Waadt", "Wallis", "Jura & Drei-Seen-Land", "Genf", "Jura & Drei-Seen-Land")
)

# Check
head(canton_to_region, n = 20)
colnames(selected_gdp_data)

# Join the GDP data with the region mapping
mapped_gdp_data <- selected_gdp_data %>%
  right_join(canton_to_region, by = c("Canton" = "Canton"))

# Check
print(head(mapped_gdp_data, n = 30), n = 30)

# Convert character columns to numeric
mapped_gdp_data[2:9] <- lapply(mapped_gdp_data[2:9], as.numeric)

# Summarize GDP by region
gdp_by_region <- mapped_gdp_data %>%
  group_by(Region) %>%
  summarise(across(`2014`:`2021`, sum, na.rm = TRUE))

# View the summarized data
print(gdp_by_region)

# Save to CSV
write.csv(gdp_by_region, file.path(getwd(), "data_prep", "data_prep_gdp.csv"))

