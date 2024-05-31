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

# Load the worker data
workers_data <- read_csv("data_prep/data_prep_workers.csv", col_types = cols(
  .default = col_double(),
  Region = col_character()
))

# Check the structure of the data
head(tourism_data, n=20)
head(gdp_data, n=20)
head(workers_data, n=20)

# Rename "Luzern / Vierwaldstättersee" to "Zentralschweiz" in tourism_data
tourism_data <- tourism_data %>%
  mutate(Region = case_when(
    Region == "Luzern / Vierwaldstättersee" ~ "Zentralschweiz",
    TRUE ~ Region
  ))


# Combine the datasets
combined_data_pre <- left_join(tourism_data, gdp_data, by = "Region")
combined_data <- left_join(combined_data_pre, workers_data, by = "Region")

# Check
print(combined_data)

# Rename year and gdp columns for clarity
combined_data <- combined_data %>%
  rename_with(~ gsub("(.*)\\.x", "\\1_Tourism_Nights", .x),
              .cols = ends_with(".x")) %>%
  rename_with(~ gsub("(.*)\\.y", "\\1_GDP", .x),
              .cols = ends_with(".y"))

# Drop Index column of added gdp data
data_final <- combined_data[,-c(1, 11,20)]
print(head(data_final, n=20),n=20)

# Save to CSV
write.csv(data_final, file.path(getwd(), "data_prep", "data_prep_combined_final.csv"))
