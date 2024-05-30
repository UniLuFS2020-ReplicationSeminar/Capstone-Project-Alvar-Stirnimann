## Combine Datasets

library(readr)
library(dplyr)

# Load the tourism data
tourism_data <- read_csv("data_prep/data_prep_tourism_2014-2022.csv", col_types = cols(
  .default = col_double(),
  Region = col_character()
))

# Load the GDP data
gdp_data <- read_csv("data_prep/data_prep_gdp.csv", col_types = cols(
  .default = col_double(),
  Region = col_character()
))

# Check the structure of the data
head(tourism_data, n=20)
head(gdp_data, n=20)

# Rename "Luzern / Vierwaldstättersee" to "Zentralschweiz" in tourism_data
tourism_data <- tourism_data %>%
  mutate(Region = case_when(
    Region == "Luzern / Vierwaldstättersee" ~ "Zentralschweiz",
    TRUE ~ Region
  ))


# Combine the datasets
combined_data <- left_join(tourism_data, gdp_data, by = "Region")

# Alternatively, to merge on Region and Year
# Ensure there is a 'Year' column in both datasets
combined_data <- left_join(tourism_data, gdp_data, by = c("Region", "Year"))

# Check
print(combined_data)

# Drop Index column of added gdp data
data_final <- combined_data[,-c(11)]
head(data_final)

# Save to CSV
write.csv(data_final, file.path(getwd(), "data_prep", "data_prep_combined_final.csv"))
