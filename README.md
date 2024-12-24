# Google Play Store Apps Revenue Analysis

## Overview
This repository contains a comprehensive analysis of a dataset comprising economic and performance-related attributes of paid apps in the Google Play Store as of June 2023. The primary objective of the analysis is to identify key factors influencing app revenue and evaluate optimal strategies to maximize revenue for app developers. The analysis employs statistical and econometric methods, leveraging tools like Stata to derive actionable insights.

## Dataset
The dataset consists of 3173 observations, each representing a paid app with attributes described by 23 variables. These variables include app characteristics such as price, rating, revenue, monetization strategy, age target, number of languages supported, and main category. Missing values for certain attributes have been addressed during the analysis.

### Key Variables:
- **Dependent Variable**: App revenue (in USD, transformed using the natural logarithm for normality).
- **Independent Variables**:
  - App price (transformed using the natural logarithm).
  - App rating (ranging from 1 to 5).
  - Monetization strategy (Paid apps, In-app purchases, Ad purchases).
  - Age target (Everyone, Everyone 10+, Teen, Mature 17+).
- **Control Variables**:
  - Number of languages supported.
  - Main category (31 unique categories).

## Analysis Methodology
The analysis follows a structured step-by-step approach:

1. **Descriptive Statistics**:
   - Summary statistics for key numerical variables were calculated to understand data distribution and central tendencies.
   - ANOVA and t-tests were conducted to evaluate differences in mean revenues across app categories and between game and non-game apps.

2. **Correlation Analysis**:
   - Correlation coefficients were computed to assess relationships between variables and identify potential multicollinearity.

3. **Exploratory Analysis**:
   - Visualizations such as histograms, box plots, and scatter plots were used to examine variable distributions, outliers, and relationships.

4. **Regression Analysis**:
   - Ordinary Least Squares (OLS) regression was performed to evaluate the impact of independent variables on app revenue.
   - Interaction effects and quadratic effects were introduced to capture non-linear relationships and interactions between variables.

5. **Diagnostics and Robustness Analysis**:
   - Heteroskedasticity was tested and addressed using robust standard errors.
   - Endogeneity issues such as omitted variable bias and reverse causality were identified and discussed with recommendations for resolution.

## Key Insights
1. **Revenue Drivers**:
   - App rating and price have a significant positive impact on revenue.
   - Monetization strategies (in-app purchases and paid ads) and age target categories also significantly influence revenue.

2. **Optimal Pricing**:
   - A quadratic relationship between price and revenue suggests that mid-range prices are optimal for maximizing revenue.

3. **Monetization Strategies**:
   - High-quality apps (rated > 3.5) with in-app purchase strategies outperform other monetization strategies in revenue generation.
   - Apps relying on paid ads may see diminishing returns with higher ratings.

4. **Target Audience**:
   - Apps targeted at specific age groups (Everyone 10+, Teen) generate higher revenues compared to apps targeting all age groups (Everyone).

5. **Diagnostics**:
   - Heteroskedasticity and endogeneity issues were identified, suggesting potential for further model refinement using advanced regression techniques (e.g., 2SLS or fixed effects models).

## Future Work
To enhance the robustness of the analysis, the following improvements can be implemented:
- Addressing endogeneity through instrumental variable regression.
- Including additional variables such as app size and historical pricing.
- Expanding the dataset with time-series data for better insights into trends and causality.

## How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/google-apps-revenue-analysis.git
   ```

2. Review the code and data analysis scripts provided in the repository.

3. Explore the detailed findings in the analysis report.

## License
This analysis and its content are copyrighted by the author and are for educational and research purposes only. Redistribution or commercial use without permission is prohibited.

