# ============================================================================
# Day 9: One-Way ANOVA - Gut Microbiome Diversity Across Diet Groups
# Author: Farid
# Date: December 2025
# Purpose: Compare microbiome diversity across 3 different diet interventions
# ============================================================================

# Load required packages
library(ggplot2)

# Set seed for reproducibility
set.seed(123)

# ============================================================================
# SIMULATE DATA: Gut Microbiome Shannon Diversity Index
# ============================================================================
# Research Question: Does diet type affect gut microbiome diversity?

# Create data for 3 diet groups (n=30 per group)
mediterranean <- rnorm(30, mean = 4.5, sd = 0.6)  # High diversity
western <- rnorm(30, mean = 3.2, sd = 0.7)        # Low diversity  
vegetarian <- rnorm(30, mean = 4.0, sd = 0.5)     # Medium diversity

# Combine into dataframe
microbiome_data <- data.frame(
  diversity = c(mediterranean, western, vegetarian),
  diet = rep(c("Mediterranean", "Western", "Vegetarian"), each = 30)
)

# View first rows
head(microbiome_data)
summary(microbiome_data)

# ============================================================================
# DESCRIPTIVE STATISTICS
# ============================================================================
# Calculate mean and SD for each group
aggregate(diversity ~ diet, data = microbiome_data, FUN = mean)
aggregate(diversity ~ diet, data = microbiome_data, FUN = sd)

# ============================================================================
# ONE-WAY ANOVA
# ============================================================================
# Null Hypothesis: All three diet groups have equal mean diversity
# Alternative: At least one group differs

anova_result <- aov(diversity ~ diet, data = microbiome_data)
summary(anova_result)

# ============================================================================
# INTERPRETATION GUIDE
# ============================================================================
# Look at the p-value (Pr(>F)):
# - If p < 0.05: Diet groups have significantly different diversity
# - If p > 0.05: No significant difference between groups

# ============================================================================
# VISUALIZATION
# ============================================================================
# Boxplot comparing groups
ggplot(microbiome_data, aes(x = diet, y = diversity, fill = diet)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, alpha = 0.3) +
  labs(
    title = "Gut Microbiome Diversity Across Diet Groups",
    subtitle = "Shannon Diversity Index (Higher = More Diverse)",
    x = "Diet Type",
    y = "Shannon Diversity Index",
    caption = "One-Way ANOVA Analysis | Day 9 Training"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Save plot
ggsave("outputs/01_diet_diversity_boxplot.png", width = 8, height = 6, dpi = 300)

# ============================================================================
# SAVE RESULTS
# ============================================================================
# Save ANOVA summary to text file
sink("outputs/01_anova_results.txt")
cat("ONE-WAY ANOVA RESULTS\n")
cat("====================\n\n")
cat("Research Question: Does diet type affect gut microbiome diversity?\n\n")
cat("Group Means:\n")
print(aggregate(diversity ~ diet, data = microbiome_data, FUN = mean))
cat("\n\nANOVA Table:\n")
print(summary(anova_result))
sink()

cat("\n✅ Analysis complete! Check outputs folder for results.\n")


