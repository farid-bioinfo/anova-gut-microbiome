# ============================================================================
# Day 9: Two-Way ANOVA - Diet × Probiotic Interaction
# Author: Farid
# Date: December 2025
# Purpose: Test if diet AND probiotic supplementation affect diversity
# ============================================================================

library(ggplot2)

set.seed(456)

# ============================================================================
# SIMULATE DATA: Two Factors
# ============================================================================
# Factor 1: Diet (3 levels: Mediterranean, Western, Vegetarian)
# Factor 2: Probiotic (2 levels: Yes, No)
# Total: 3 × 2 = 6 groups (n=15 per group = 90 total)

# Research Question: Do diet and probiotics INTERACT?
# Interaction = Does the effect of diet DEPEND ON whether you take probiotics?

data_two_way <- data.frame(
  diversity = c(
    # Mediterranean + Probiotic
    rnorm(15, mean = 5.2, sd = 0.5),
    # Mediterranean + No Probiotic
    rnorm(15, mean = 4.3, sd = 0.5),
    # Western + Probiotic
    rnorm(15, mean = 3.8, sd = 0.6),
    # Western + No Probiotic
    rnorm(15, mean = 3.0, sd = 0.6),
    # Vegetarian + Probiotic
    rnorm(15, mean = 4.6, sd = 0.5),
    # Vegetarian + No Probiotic
    rnorm(15, mean = 3.9, sd = 0.5)
  ),
  diet = rep(rep(c("Mediterranean", "Western", "Vegetarian"), each = 15), 2),
  probiotic = rep(c("Yes", "No"), each = 45)
)

# View structure
head(data_two_way, 10)

# ============================================================================
# DESCRIPTIVE STATISTICS
# ============================================================================
# Mean diversity for each combination
aggregate(diversity ~ diet + probiotic, data = data_two_way, FUN = mean)

# ============================================================================
# TWO-WAY ANOVA
# ============================================================================
# Tests THREE things:
# 1. Main effect of diet (ignoring probiotic)
# 2. Main effect of probiotic (ignoring diet)
# 3. INTERACTION: Does diet effect depend on probiotic status?

two_way_result <- aov(diversity ~ diet * probiotic, data = data_two_way)
summary(two_way_result)

# ============================================================================
# INTERPRETATION GUIDE
# ============================================================================
cat("\n=== HOW TO INTERPRET ===\n")
cat("Look at p-values (Pr(>F)):\n")
cat("1. 'diet' row: Does diet matter overall? (expect p < 0.05)\n")
cat("2. 'probiotic' row: Do probiotics matter overall? (expect p < 0.05)\n")
cat("3. 'diet:probiotic' row: INTERACTION - does diet effect depend on probiotics?\n")
cat("   - If p < 0.05: Yes! The effect of diet is DIFFERENT depending on probiotic use\n")
cat("   - If p > 0.05: No interaction, effects are independent\n\n")

# ============================================================================
# VISUALIZATION: Interaction Plot
# ============================================================================
ggplot(data_two_way, aes(x = diet, y = diversity, color = probiotic, group = probiotic)) +
  stat_summary(fun = mean, geom = "point", size = 3) +
  stat_summary(fun = mean, geom = "line", size = 1) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +
  labs(
    title = "Two-Way ANOVA: Diet × Probiotic Interaction",
    subtitle = "Parallel lines = No interaction | Crossing lines = Interaction present",
    x = "Diet Type",
    y = "Microbiome Diversity",
    color = "Probiotic Use"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

ggsave("outputs/03_interaction_plot.png", width = 8, height = 6, dpi = 300)

# ============================================================================
# SAVE RESULTS
# ============================================================================
sink("outputs/03_two_way_anova_results.txt")
cat("TWO-WAY ANOVA RESULTS\n")
cat("=====================\n\n")
cat("Research Question: Do diet and probiotics interact to affect diversity?\n\n")
cat("Group Means:\n")
print(aggregate(diversity ~ diet + probiotic, data = data_two_way, FUN = mean))
cat("\n\nANOVA Table:\n")
print(summary(two_way_result))
sink()

cat("\n✅ Two-Way ANOVA complete! Check outputs folder.\n")
cat("\n🎉 DAY 9 COMPLETE! You've learned:\n")
cat("   - One-Way ANOVA (comparing 3+ groups)\n")
cat("   - Post-hoc tests (which pairs differ)\n")
cat("   - Two-Way ANOVA (testing interactions)\n")
