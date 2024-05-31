## Analysis

library(readr)
library(tidyverse)
library(ggplot2)
library(ggrepel)
library(lme4)
library(tidyr)

install.packages("lattice")

# Load the combined data
combined_data <- read_csv("data_prep/data_prep_combined_final.csv", col_types = cols(
  .default = col_double(),
  Region = col_character()
))

## Prepare Analysis
# Check the structure and summary of the data
str(combined_data)
summary(combined_data)
head(combined_data, n=20)

# Check for any NA values and decide how to handle them
sum(is.na(combined_data))

# Remove unwanted columns
combined_data <- combined_data %>%
  select(-c(...1))


# Check
head(combined_data, n=20)

# Convert tourism and GDP columns from character to numeric
#tourism_columns <- names(combined_data)[grep("Tourism_Nights", names(combined_data))]
#gdp_columns <- names(combined_data)[grep("GDP", names(combined_data))]

#combined_data[tourism_columns] <- lapply(combined_data[tourism_columns], as.numeric)
#combined_data[gdp_columns] <- lapply(combined_data[gdp_columns], as.numeric)

# Reshapte the data from wide to long format
combined_data_long <- combined_data %>%
  pivot_longer(cols = -c(Region), 
               names_to = c("Year", ".value"), 
               names_pattern = "(\\d{4})_(.*)") %>%
  mutate(Year = as.numeric(Year))

# Check
head(combined_data_long, n=20)
colnames(combined_data_long)

# Standarize the variables
combined_data_long <- combined_data_long %>%
  mutate(
    GDP = scale(GDP),
    Tourism_Nights = scale(Tourism_Nights),
    workers = scale(workers)
  )

## Analyze Correlation between Tourism Nights and GDP
# Calculate correlation for each year
correlations <- data.frame(Year = numeric(), Correlation = numeric())

for(year in 2014:2021) {
  correlation <- cor(combined_data[[paste0(year, "_Tourism_Nights")]], combined_data[[paste0(year, "_GDP")]], use = "complete.obs")
  correlations <- rbind(correlations, data.frame(Year = year, Correlation = correlation))
}

print(correlations)

# Model
# Fit the linear mixed-effects model
model <- lmer(GDP ~ Tourism_Nights + workers + (1 | Region) + (1 | Year), data = combined_data_long)

# Summary of the model
summary(model)

# Calculate partial residuals for Tourism_Nights
partial_residuals <- resid(model) + model.matrix(model)[, "Tourism_Nights"] * fixef(model)["Tourism_Nights"]

# Add partial residuals to the data frame
combined_data_long$partial_residuals <- partial_residuals

# Plot the partial residuals showing the relationship between Tourism Nights and GDP
ggplot(combined_data_long, aes(x = Tourism_Nights, y = partial_residuals)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Effect of Tourism Nights on GDP (Controlled for Number of Workers)",
       x = "Standardized Tourism Nights",
       y = "Partial Residuals of GDP") +
  theme_classic()

# Save plot to output folder
ggsave("output/Effect of Tourism Nights on GDP (control for workers).png")


# Plot scatter plot for 2021 with labeled points using ggplot2 and "combined_data" dataset
ggplot(combined_data, aes(x = `2021_Tourism_Nights`, y = `2021_GDP`, label = Region)) +
  geom_point() +
  geom_text_repel() +
  labs(title = "Scatter Plot of Tourism Nights vs GDP in 2021", x = "Tourism Nights", y = "GDP")

# Save scatter plot to output folder
ggsave("output/scatter_plot_2021_gdp__vs_tourism.png")




# Extract fixed effects
fixed_effects <- fixef(model)

# Predict values
combined_data_long$predicted_GDP <- predict(model)

# Plot actual vs. predicted GDP
ggplot(combined_data_long, aes(x = predicted_GDP, y = GDP)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  labs(title = "Actual vs. Predicted GDP",
       x = "Predicted GDP",
       y = "Actual GDP")

# Visualize random effects
ranef_model <- ranef(model)
print(ranef_model)

# Plot random effects for Cantons
dotplot(ranef_model$Region, main = "Random Effects for Cantons")

# Plot random effects for Years
dotplot(ranef_model$Year, main = "Random Effects for Years")








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

# Save scatter plot to output folder
ggsave("output/scatter_plot_2021_gdp__vs_tourism.png")

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

