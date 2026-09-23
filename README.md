# E-commerce Customer Behavior Analysis

**MATH-2200 course project · R · Logistic and Poisson regression**

This project analyzes 350 customer records to study two questions: which customer characteristics are associated with discount use, and which factors are associated with the number of items purchased. The [R analysis](ecommerce_code%20%281%29%20%281%29.r) contains the models and diagnostics; the [presentation](Final%20project%20stat.pptx) summarizes the course findings.

## Project at a glance

- **Analyze customer behavior:** Summarize age, total spend, and items purchased in a 350-record e-commerce dataset.
- **Model two outcomes:** Fit a logistic regression for `Discount Applied` and a Poisson regression for `Items Purchased`. In the course analysis, purchase recency was associated with discount use (reported p = 0.019).
- **Check the models:** Examine odds and rate ratios, likelihood-ratio and goodness-of-fit tests, the confusion matrix and ROC/AUC, dispersion, variance inflation factors (VIF), and Pearson residuals.

These points correspond to the three project bullets on my resume.

## Data

Source: [E-commerce Customer Behavior Dataset on Kaggle](https://www.kaggle.com/datasets/uom190346a/e-commerce-customer-behavior-dataset). The analysis uses the CSV named `E-commerce Customer Behavior - Sheet1.csv`. Keep the original column names, including their spaces.

Place the file at:

```text
data/E-commerce Customer Behavior - Sheet1.csv
```

The script reads that relative path, so run it with the repository folder as the working directory. The data include `Age`, `Total Spend`, `Items Purchased`, `Average Rating`, `Discount Applied`, and `Days Since Last Purchase`.

## Analysis and results

### 1. Discount use

The binary logistic model uses age, total spend, items purchased, and days since last purchase to examine discount application. The presentation reports purchase recency as associated with discount use (p = 0.019). A nested-model likelihood-ratio test assesses the contribution of total spend. The script also computes odds ratios, a Hosmer–Lemeshow test, Somers' D, a confusion matrix, and an ROC curve with AUC.

The presentation reports 347/350 correctly classified observations and AUC = 0.9999 **on the same records used to fit the model**. These are descriptive, in-sample results, not evidence of performance on new customers.

### 2. Items purchased

The Poisson count model uses age, total spend, average rating, and purchase recency. The presentation reports associations for total spend and purchase recency in the Poisson model. The script calculates rate ratios, tests dispersion, fits a quasi-Poisson comparison, checks VIF, and plots Pearson residuals against log fitted values.

The presentation reports underdispersion and VIF values above 10 for total spend and average rating. Those diagnostics matter when interpreting uncertainty and individual coefficients.

## Run locally

1. Download the dataset from the source above and put the CSV at the stated `data/` path.
2. In R, install the packages used by the script:

   ```r
   install.packages(c("readr", "ResourceSelection", "Hmisc", "pROC", "AER", "car"))
   ```

3. Open the repository folder in RStudio and run:

   ```r
   source("ecommerce_code (1) (1).r")
   ```

The script prints model summaries and tests, and draws histograms, an ROC curve, and a residual plot.

## Interpretation limits

This is an exploratory course analysis of a small dataset. The script does not use a held-out test set or cross-validation. The near-perfect in-sample classification should be validated on independent data before any predictive claim. Associations in these observational records do not establish that recency or spending causes discount use or larger purchases.
