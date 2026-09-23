
# E-Commerce Customer Behavior Analysis
# Research Question 1: What customer characteristics are associated 
#                      with the likelihood of applying a discount?
# Research Question 2: What factors influence the frequency of 
#                      items purchased by a customer?



library(readr)
ecom <- read_csv("C:/Users/songu/Downloads/archive/E-commerce Customer Behavior - Sheet1.csv")
View(ecom)

# Convert Discount Applied to numeric (TRUE=1, FALSE=0)
ecom$`Discount Applied` <- as.integer(ecom$`Discount Applied`)

# ============================================================
# DESCRIPTIVE STATISTICS
# ============================================================

summary(ecom)



hist(ecom$Age, main = "Distribution of Age",
     xlab = "Age", col = "lightblue")

hist(ecom$`Items Purchased`, main = "Distribution of Items Purchased",
     xlab = "Items Purchased", col = "lightgreen")

hist(ecom$`Total Spend`, main = "Distribution of Total Spend",
     xlab = "Total Spend", col = "lightyellow")



# RESEARCH QUESTION 1: LOGISTIC REGRESSION
# What customer characteristics are associated with the likelihood of applying a discount?


# Model Fitting
logit_model <- glm(`Discount Applied` ~ Age + `Total Spend` + 
                     `Items Purchased` + `Days Since Last Purchase`,
                   data = ecom,
                   family = binomial)
summary(logit_model)

# Odds Ratios
exp(coef(logit_model))

# Store predicted probabilities
ecom$predicted_value <- predict(logit_model, type = "response")


#  Likelihood Ratio Test (Total Spend)
model_reduced <- glm(`Discount Applied` ~ Age + 
                       `Items Purchased` + `Days Since Last Purchase`,
                     family = binomial, data = ecom)

model_full <- glm(`Discount Applied` ~ Age + `Total Spend` + 
                    `Items Purchased` + `Days Since Last Purchase`,
                  family = binomial, data = ecom)

anova(model_reduced, model_full, test = "Chisq")


#  Hosmer-Lemeshow Goodness-of-Fit Test 
library(ResourceSelection)
hl_test <- hoslem.test(ecom$`Discount Applied`, fitted(logit_model), g = 10)
hl_test


#  Somer's D 
library(Hmisc)
somers2(ecom$predicted_value, ecom$`Discount Applied`)

ecom$pred_class <- ifelse(ecom$predicted_value > 0.5, 1, 0)

# Confusion Matrix
table(Predicted = ecom$pred_class, Actual = ecom$`Discount Applied`)

# ROC Curve and AUC
library(pROC)
roc_obj <- roc(ecom$`Discount Applied`, ecom$predicted_value)
plot(roc_obj, col = "blue", main = "ROC Curve for Logistic Regression")
auc(roc_obj)



# RESEARCH QUESTION 2: POISSON REGRESSION



# Model Fitting 
poisson_model <- glm(`Items Purchased` ~ Age + `Total Spend` + 
                       `Average Rating` + `Days Since Last Purchase`,
                     family = poisson, data = ecom)
summary(poisson_model)

# Rate Ratios
exp(coef(poisson_model))


# Overdispersion Test 
library(AER)
dispersiontest(poisson_model)


#  Quasi-Poisson 
poisson_quasi <- glm(`Items Purchased` ~ Age + `Total Spend` + 
                       `Average Rating` + `Days Since Last Purchase`,
                     family = quasipoisson, data = ecom)
summary(poisson_quasi)


#  Multicollinearity Check 
library(car)
vif(poisson_model)


# Pearson Residuals Plot 
log_fitted <- log(fitted(poisson_model))
pearson_resid <- residuals(poisson_model, type = "pearson")

plot(log_fitted, pearson_resid,
     xlab = "Log(Fitted Values)",
     ylab = "Pearson Residuals",
     main = "Pearson Residuals vs Log(Fitted)",
     pch = 19, col = "blue")
abline(h = 0, col = "red", lwd = 2)
