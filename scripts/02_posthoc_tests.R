# ============================================================================
# Day 9: Post-Hoc Tests - Which Groups Differ?
# ============================================================================

library(ggplot2)

# Reload data
set.seed(123)
mediterranean <- rnorm(30, mean = 4.5, sd = 0.6)
western <- rnorm(30, mean = 3.2, sd = 0.7)
vegetarian <- rnorm(30, mean = 4.0, sd = 0.5)

microbiome_data <- data.frame(
  diversity = c(mediterranean, western, vegetarian),
  diet = rep(c("Mediterranean", "Western", "Vegetarian"), each = 30)
)

# Re-run ANOVA
anova_result <- aov(diversity ~ diet, data = microbiome_data)

# ============================================================================
# TUKEY HSD POST-HOC TEST
# ============================================================================
tukey_result <- TukeyHSD(anova_result)

# Display results in console
cat("\n=== TUKEY HSD RESULTS ===\n")
tukey_result

# Extract and format results
tukey_df <- as.data.frame(tukey_result$diet)
tukey_df$Comparison <- rownames(tukey_df)

cat("\n\n=== WHICH PAIRS DIFFER? ===\n")
cat("Comparison                    | Difference | P-value   | Significant?\n")
cat("------------------------------------------------------------------\n")

for(i in 1:nrow(tukey_df)) {
  sig <- ifelse(tukey_df$`p adj`[i] < 0.05, "YES ✓", "NO")
  cat(sprintf("%-30s| %8.2f   | %.2e | %s\n", 
              tukey_df$Comparison[i], 
              tukey_df$diff[i], 
              tukey_df$`p adj`[i],
              sig))
}

# Save to file
write.csv(tukey_df, "outputs/02_tukey_results.csv", row.names = FALSE)

cat("\n✅ Results saved to outputs/02_tukey_results.csv\n")
# Create outputs folder
dir.create("outputs", showWarnings = FALSE)

# Now save the results
write.csv(tukey_df, "outputs/02_tukey_results.csv", row.names = FALSE)

cat("\n✅ File saved successfully!\n")

# Create outputs folder
dir.create("outputs", showWarnings = FALSE)

# Now save the results
write.csv(tukey_df, "outputs/02_tukey_results.csv", row.names = FALSE)

cat("\n✅ File saved successfully!\n")

# Better Tukey plot with ggplot2
library(ggplot2)

# Convert to dataframe for ggplot
tukey_plot_data <- data.frame(
  comparison = c("Vegetarian-Mediterranean", "Western-Mediterranean", "Western-Vegetarian"),
  difference = tukey_df$diff,
  lower = tukey_df$lwr,
  upper = tukey_df$upr,
  p_value = tukey_df$`p adj`
)

# Create clean plot
ggplot(tukey_plot_data, aes(x = difference, y = comparison)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.2, size = 1, color = "blue") +
  geom_point(size = 3, color = "darkblue") +
  labs(
    title = "Tukey HSD: Pairwise Diet Comparisons",
    subtitle = "All pairs significantly different (none cross zero)",
    x = "Difference in Mean Diversity",
    y = "Comparison"
  ) +
  theme_minimal()

# Save it
ggsave("outputs/02_tukey_professional.png", width = 8, height = 5, dpi = 300)

cat("\n✅ Better plot saved!\n")
