## Analysis

library(readr)
library(tidyverse)
library(ggplot2)
library(ggrepel)
library(lme4)
library(tidyr)

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

# Reshape the data from wide to long format
combined_data_long <- combined_data %>%
  pivot_longer(cols = -c(Region), 
               names_to = c("Year", ".value"), 
               names_pattern = "(\\d{4})_(.*)") %>%
  mutate(Year = as.numeric(Year),
         Region = as.factor(Region))

# Check
head(combined_data_long, n=20)
colnames(combined_data_long)
str(combined_data_long)

# Standarize the variables
combined_data_long <- combined_data_long %>%
  mutate(
    GDP = scale(GDP),
    Tourism_Nights = scale(Tourism_Nights),
    workers = scale(workers)
  )



## Model

### Analyze Correlation between Tourism Nights and GDP
# Calculate correlation for each year
correlations <- data.frame(Year = numeric(), Correlation = numeric())

for(year in 2014:2021) {
  correlation <- cor(combined_data[[paste0(year, "_Tourism_Nights")]], combined_data[[paste0(year, "_GDP")]], use = "complete.obs")
  correlations <- rbind(correlations, data.frame(Year = year, Correlation = correlation))
}

print(correlations)

### Linear Mixed-Effects Model with interaction
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
       y = "Partial Residuals of GDP", 
      color = "Region") +
  theme_classic()

# Save plot to output folder
ggsave("output/Effect of Tourism Nights on GDP (control for workers).png")


### Linear Mixed-Effects Model by Region
# Plot the partial residuals showing the relationship between Tourism Nights and GDP per Region
ggplot(combined_data_long, aes(x = Tourism_Nights, y = partial_residuals)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  facet_wrap(~ Region, scales = "free_y") +
  labs(title = "Effect of Tourism Nights on GDP per Region (Controlled for Workers)",
       x = "Standardized Tourism Nights",
       y = "Partial Residuals of GDP") +
  theme_classic() +
  theme(
    panel.background = element_rect(fill = "white"),
    plot.background = element_rect(fill = "white"),
    legend.background = element_rect(fill = "white"),
    legend.key = element_rect(fill = "white")
  )

# Save plot to output folder
ggsave("output/Effect of Tourism Nights on GDP per Region (control for workers).png")

## Check Residuals
# Fitted values from the model
fitted_values <- fitted(model)

# Add fitted values to the data frame
combined_data_long$fitted_values <- fitted_values

# Residuals vs. Fitted Values Plot
ggplot(combined_data_long, aes(x = fitted_values, y = partial_residuals)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  labs(title = "Residuals vs. Fitted Values",
       x = "Fitted Values",
       y = "Residuals") +
  theme_classic()

# Save residuals vs. fitted values plot to output folder
ggsave("output/Residuals vs. Fitted Values.png")


### Polynomial model
# Adding polynomial terms to the model
model_poly <- lmer(GDP ~ poly(Tourism_Nights, 2) + workers + (1 | Region) + (1 | Year), data = combined_data_long)

# Summary of the polynomial model
summary(model_poly)

# Diagnostic plots for the polynomial model
residuals_poly <- resid(model_poly)
fitted_values_poly <- fitted(model_poly)
combined_data_long$residuals_poly <- residuals_poly
combined_data_long$fitted_values_poly <- fitted_values_poly

# Residuals vs. Fitted Values Plot for the polynomial model
ggplot(combined_data_long, aes(x = fitted_values_poly, y = residuals_poly)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  labs(title = "Residuals vs. Fitted Values (Polynomial Model)",
       x = "Fitted Values",
       y = "Residuals") +
  theme_classic()

# Save residuals vs. fitted values plot for polynomial model to output folder
ggsave("output/Residuals vs. Fitted Values (Polynomial Model).png")


### Scatter Plot of 2021 GDP vs Tourism Nights
# Plot scatter plot for 2021 with labeled points using ggplot2 and "combined_data" dataset
ggplot(combined_data, aes(x = `2021_Tourism_Nights`, y = `2021_GDP`, label = Region)) +
  geom_point() +
  geom_text_repel() +
  labs(title = "Scatter Plot of Tourism Nights vs GDP in 2021", x = "Tourism Nights", y = "GDP")

# Save scatter plot to output folder
ggsave("output/scatter_plot_2021_gdp__vs_tourism.png")







