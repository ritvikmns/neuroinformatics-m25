from scipy.io import loadmat
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

data = loadmat("power.mat")
data = np.array(data["Power"])

# Distribution of Differences

diff = data[0] - data[1]

plt.figure(figsize=(8, 5))
sns.histplot(diff, kde=True, bins=30, color='skyblue', edgecolor='black')
plt.axvline(0, color='red', linestyle='--', label='Zero Line (No Difference)')
plt.axvline(np.mean(diff), color='green', linestyle='-', label='Mean Difference')
plt.title("Distribution of Differences: Scenario 1 - Scenario 2")
plt.xlabel("Difference in Power")
plt.ylabel("Frequency")
plt.legend()
plt.grid(True)
plt.savefig("power_difference_distribution.png", dpi=300)
plt.show()

# Slight offset is present between the zero line and the mean difference,
# indicating a small systematic difference in power between the two scenarios.


# Box Plot of Power Values - side-by-side comparison of scenarios

df = pd.DataFrame({
    'Power': np.concatenate([data[0], data[1]]),
    'Scenario': ['Scenario 1'] * 300 + ['Scenario 2'] * 300
})

plt.figure(figsize=(8, 5))
sns.boxplot(x='Scenario', y='Power', data=df, palette="Set2")
plt.title("Power Comparison Between Two Scenarios")
plt.ylabel("Power")
plt.grid(axis='y')
plt.savefig("power_boxplot_comparison.png", dpi=300)
plt.show()

# Slightly higher median power in Scenario 2 compared to Scenario 1,
# indicating a potential increase in power output under the second scenario.

# Paired t-test for Power Values
from scipy.stats import ttest_rel
t_stat, p_value = ttest_rel(data[0], data[1])
print(f"Paired t-test results:\nT-statistic: {t_stat}\nP-value: {p_value}")

# Wilcoxon Signed-Rank Test for Power Values
from scipy.stats import wilcoxon
stat, p_value_wilcoxon = wilcoxon(data[0], data[1])
print(f"Wilcoxon Signed-Rank Test results:\nStatistic: {stat}\nP-value: {p_value_wilcoxon}")

# from the paired t-test, we reject the null hypothesis which states that there is no difference in power between the two scenarios.
# The p-value is less than the significance level of 0.05, indicating a statistically significant difference in power between the two scenarios.
# Scenario 2 has a higher power output compared to Scenario 1.

# We do not reject the null hypothesis in the Wilcoxon Signed-Rank Test, which suggests that the differences in power between the two scenarios are not statistically significant at the 0.05 level.
# However, as the distribution of differences is roughly normal, the paired t-test is more appropriate in this case, and it indicates a significant difference.