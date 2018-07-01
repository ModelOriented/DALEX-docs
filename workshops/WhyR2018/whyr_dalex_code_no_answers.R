# R code for the Why R? 2018 workshop DALEX: Descriptive mAchine Learning EXplanations.
# Tools for exploration, validation and explanation of complex machine learning models

# Authors: Mateusz Staniak & Przemysław Biecek

# Install necessary packages:
install.packages(c("mlr", "DALEX", "live", "auditor", "randomForest", "e1071"))
devtools::install_github("pbiecek/ceterisParibus")
devtools::install_github("MI2DataLab/modelDown")

# Load the package
library("DALEX")
data("apartments")
head(apartments)

# create a random forest model
library("randomForest")
set.seed(3)

apartments_rf_model <- randomForest(m2.price ~ construction.year + surface + floor +
                                      no.rooms + district, data = apartments)
apartments_rf_model

# create a linear model
apartments_lm_model <- lm(m2.price ~ construction.year + surface + floor +
                            no.rooms + district, data = apartments)
summary(apartments_lm_model)

# Create DALEX explainer
explainer_lm <- explain(apartments_lm_model,
                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)
explainer_lm

explainer_rf <- explain(apartments_rf_model,
                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)
explainer_rf

# Create single prediction explainers

single_explainer_lm <- prediction_breakdown(explainer_lm, apartmentsTest[10, ])
plot(single_explainer_lm)

single_explainer_rf <- prediction_breakdown(explainer_rf, apartmentsTest[10, ])
plot(single_explainer_rf)

plot(single_explainer_lm, single_explainer_rf)

single_explainer_lm <- prediction_breakdown(explainer_lm, apartmentsTest[2000, ])
single_explainer_rf <- prediction_breakdown(explainer_rf, apartmentsTest[2000, ])
plot(single_explainer_lm, single_explainer_rf)

# Draw Ceteris Paribus Plots

library(ceterisParibus)

cp_rf <- ceteris_paribus(explainer_rf, apartmentsTest[10, ])
plot(cp_rf)

cp_lm <- ceteris_paribus(explainer_lm, apartmentsTest[10, ])
plot(cp_lm)

cp_svm <- ceteris_paribus(explainer_svm, apartmentsTest[10, ])
plot(cp_svm)

plot(cp_rf, cp_lm, cp_svm)

# Local explanations
library(live)
library(mlr)

set.seed(33)
simulated_dataset <- sample_locally2(apartmentsTest, apartmentsTest[10, ], "m2.price", 500)

live_rf <- add_predictions2(simulated_dataset, apartments_rf_model)
live_lm <- add_predictions2(simulated_dataset, apartments_lm_model)

live_expl_rf <- fit_explanation2(live_rf)
live_expl_lm <- fit_explanation2(live_lm)

# plot(live_expl_rf, type = "forest")
# plot(live_expl_lm, type = "forest")

plot(live_expl_rf, type = "waterfall")
plot(live_expl_lm, type = "waterfall")

# Performance

# root mean square
predicted_mi2_lm <- predict(apartments_lm_model, apartmentsTest)
sqrt(mean((predicted_mi2_lm - apartmentsTest$m2.price)^2))

# root mean square
predicted_mi2_rf <- predict(apartments_rf_model, apartmentsTest)
sqrt(mean((predicted_mi2_rf - apartmentsTest$m2.price)^2))

# Model performance explainers

mp_lm <- model_performance(explainer_lm)
mp_lm

mp_rf <- model_performance(explainer_rf)
mp_rf

plot(mp_lm, mp_rf)
plot(mp_lm, mp_rf, geom = "boxplot")

# Model explainers - Performance: some diagnostic plots

library(ggplot2)
ggplot(mp_rf, aes(observed, diff)) + geom_point() + geom_smooth(se = FALSE) +
  xlab("Observed") + ylab("Predicted - Observed") +
  ggtitle("Diagnostic plot for the random forest model") + theme_mi2()

ggplot(mp_lm, aes(observed, diff)) + geom_point() + geom_smooth(se = FALSE) +
  xlab("Observed") + ylab("Predicted - Observed") +
  ggtitle("Diagnostic plot for the linear model") + theme_mi2()

# Model explainers - variable importance
#

vi_rf <- variable_importance(explainer_rf, loss_function = loss_root_mean_square)
vi_rf

plot(vi_rf)

vi_lm <- variable_importance(explainer_lm, loss_function = loss_root_mean_square)
vi_lm

plot(vi_lm, vi_rf)

# Model explainers - Continuous variable response
#
# Variable effect
## for construction.year

sv_rf  <- variable_response(explainer_rf,
                            variable =  "construction.year", type = "pdp")
plot(sv_rf)

sv_lm  <- variable_response(explainer_lm,
                            variable =  "construction.year", type = "pdp")
plot(sv_rf, sv_lm)

# Model explainers - Discrete variable response
#
## for district

svd_rf  <- variable_response(explainer_rf,
                             variable = "district", type = "factor")
svd_lm  <- variable_response(explainer_lm,
                             variable = "district", type = "factor")

plot(svd_rf, svd_lm)

# Auditor
library(auditor)

audit_rf <- audit(explainer_rf)
audit_lm <- audit(explainer_lm)

plotResidual(audit_rf, variable = "construction.year")
plotResidual(audit_lm, variable = "construction.year")

plotResidualDensity(audit_rf, variable = "district")
plotResidualDensity(audit_lm, variable = "district")

# Archivist
library(archivist)
createLocalRepo(".")
setLocalRepo(".")
asave(apartments_rf_model, repoDir = ".", userTags = "model")

setLocalRepo(".")
summaryLocalRepo(".")
showLocalRepo(".")

showLocalRepo(".", method = "tags")

rf_model <- aread("f69df6958848383a66aec4f2fbcfd5a0")

# ModelDown
library(modelDown)

modelDown(explainer_rf)
