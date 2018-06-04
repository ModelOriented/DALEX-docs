# R code from eRum 2018 Workshop DALEX: Descriptive mAchine Learning EXplanations .
# Tools for exploration, validation and explanation of complex machine learning models
## Read and look and the data, train random forest model. ---
library(tidyverse)
library(randomForest)
load(url("https://github.com/pbiecek/DALEX_docs/raw/master/workshops/eRum2018/houses.rda"))
houses
hrf <- randomForest(sqm_price ~., data = houses)
## Model diagnostics: fitted vs observed. ----
library(DALEX)
library(auditor)
rf_explainer <- DALEX::explain(hrf, data = houses, y = houses$sqm_price)
rf_audit <- audit(rf_explainer)
plotPrediction(rf_audit)
## Model performance - boxplots o residuals
rf_perf <- model_performance(rf_explainer)
plot(rf_perf, geom = "boxplot")
## Break Down for linear models ----
linear_model <- lm(sqm_price ~., data = houses)
lm_explainer <- DALEX::explain(linear_model, data = houses, y = houses$sqm_price)
breakdown_linear <- single_prediction(lm_explainer, houses[4036, -3])
plot(breakdown_linear)
## Model-agnostic Break Down ----
breakdown_explanation <- single_prediction(rf_explainer, houses[4036, -3])
plot(breakdown_explanation)
## Global feature importance ----
global_feat_imp <- DALEX::variable_importance(rf_explainer)
plot(global_feat_imp)
### Compared to local
plot(single_prediction(rf_explainer, houses[5147, -3]))
## Shapley values ----
library(shapleyr)
library(mlr)
house_task <- makeRegrTask(data = houses, target = "sqm_price")
house_rf_mlr <- train("regr.randomForest", house_task)

shapley_explanation <- shapley(4036,
                               task = house_task,
                               model = house_rf_mlr)
class(shapley_explanation) <- c("shapley.singleValue", "list")
gather(shapley_explanation$values, "feature", "shapley.score")
plot(shapley_explanation)
## LIME ----
library(lime)
explained_prediction <- houses[4036, ]
lime_explainer <- lime(houses,
                       model = house_rf_mlr)
lime_explanation <- lime::explain(houses[4036, ],
                                  explainer = lime_explainer,
                                  n_features = 5)
plot_features(lime_explanation)
## LIVE ----
library(live)
library(mlr)
set.seed(33)
new_dataset <- sample_locally2(data = houses,
                               explained_instance = houses[4036, ],
                               explained_var = "sqm_price",
                               size = 1500)
with_predictions <- add_predictions2(new_dataset, hrf)
live_explanation <- fit_explanation2(with_predictions, "regr.lm")
live_explanation
plot_explanation2(live_explanation, "forest")
plot_explanation2(live_explanation, "waterfall")
