## Analysis

library(readr)
library(tidyverse)
library(ggplot2)
library(ggrepel)

# Load the combined data
combined_data <- read_csv("data_prep/data_prep_combined_final.csv", col_types = cols(
  .default = col_double(),
  Region = col_character()
))

# Check the structure and summary of the data
str(combined_data)
summary(combined_data)
head(combined_data, n=20)

# Check for any NA values and decide how to handle them
sum(is.na(combined_data))

# Remove unwanted columns and rename year columns for clarity
combined_data <- combined_data %>%
  select(-c(...1, ...2)) %>%
  rename_with(~ gsub("(.*)\\.x", "\\1_Tourism_Nights", .x),
              .cols = ends_with(".x")) %>%
  rename_with(~ gsub("(.*)\\.y", "\\1_GDP", .x),
              .cols = ends_with(".y"))

# Check
head(combined_data, n=20)

# Convert tourism and GDP columns from character to numeric
tourism_columns <- names(combined_data)[grep("Tourism_Nights", names(combined_data))]
gdp_columns <- names(combined_data)[grep("GDP", names(combined_data))]

combined_data[tourism_columns] <- lapply(combined_data[tourism_columns], as.numeric)
combined_data[gdp_columns] <- lapply(combined_data[gdp_columns], as.numeric)

## Analyze Correlation
# Calculate correlation for each year
correlations <- data.frame(Year = numeric(), Correlation = numeric())

for(year in 2014:2021) {
  correlation <- cor(combined_data[[paste0(year, "_Tourism_Nights")]], combined_data[[paste0(year, "_GDP")]], use = "complete.obs")
  correlations <- rbind(correlations, data.frame(Year = year, Correlation = correlation))
}

print(correlations)

# Plot correlations
ggplot(correlations, aes(x = Year, y = Correlation)) +
  geom_line() +
  geom_point() +
  labs(title = "Yearly Correlation between Tourism Nights and GDP", x = "Year", y = "Correlation Coefficient")

# Plot scatter plot for 2021 with labeled points using ggplot2
ggplot(combined_data, aes(x = `2021_Tourism_Nights`, y = `2021_GDP`, label = Region)) +
  geom_point() +
  geom_text_repel() +
  labs(title = "Scatter Plot of Tourism Nights vs GDP in 2021", x = "Tourism Nights", y = "GDP")

## Regression Analysis
# Fit a linear model for each year and gather coefficients
results <- data.frame(Year = integer(), Intercept = numeric(), Slope = numeric(), R_squared = numeric())

for(year in 2014:2021) {
  lm_fit <- lm(formula = paste0("`", year, "_GDP` ~ `", year, "_Tourism_Nights`"), data = combined_data)
  intercept <- coef(lm_fit)[1]
  slope <- coef(lm_fit)[2]
  r_squared <- summary(lm_fit)$r.squared
  results <- rbind(results, data.frame(Year = year, Intercept = intercept, Slope = slope, R_squared = r_squared))
}

# Display regression results
print(results)

