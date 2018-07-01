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

# create an SVM model
library(e1071)
apartments_svm_model <- svm(m2.price ~ construction.year + surface + floor +
                              no.rooms + district, data = apartments)

# Create DALEX explainer
explainer_lm <- explain(apartments_lm_model,
                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)
explainer_lm

explainer_rf <- explain(apartments_rf_model,
                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)
explainer_rf

explainer_svm <- explain(apartments_svm_model,
                         data = apartmentsTest[, 2:6], y = apartmentsTest$m2.price)

# Create single prediction explainers

single_explainer_lm <- prediction_breakdown(explainer_lm, apartmentsTest[10, ])
plot(single_explainer_lm)

single_explainer_rf <- prediction_breakdown(explainer_rf, apartmentsTest[10, ])
plot(single_explainer_rf)

single_explainer_svm <- prediction_breakdown(explainer_svm, apartmentsTest[10, ])
plot(single_explainer_svm)

plot(single_explainer_lm, single_explainer_rf, single_explainer_svm)

single_explainer_lm <- prediction_breakdown(explainer_lm, apartmentsTest[2000, ])
single_explainer_rf <- prediction_breakdown(explainer_rf, apartmentsTest[2000, ])
single_explainer_svm <- prediction_breakdown(explainer_svm, apartmentsTest[2000, ])
plot(single_explainer_lm, single_explainer_rf, single_explainer_svm)

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
live_svm <- add_predictions2(simulated_dataset, apartments_svm_model)

live_expl_rf <- fit_explanation2(live_rf)
live_expl_lm <- fit_explanation2(live_lm)
live_expl_svm <- fit_explanation2(live_svm)

# plot(live_expl_rf, type = "forest")
# plot(live_expl_lm, type = "forest")
# plot(live_expl_svm, type = "forest")

plot(live_expl_rf, type = "waterfall")
plot(live_expl_lm, type = "waterfall")
plot(live_expl_svm, type = "waterfall")

# Other possible models

library("gbm")
apartments_gbm_model <- gbm(m2.price ~ construction.year + surface + floor +
                              no.rooms + district, data = apartments, n.trees = 1000)

explainer_gbm <- explain(apartments_gbm_model,
                         data = apartmentsTest[,2:6], y = apartmentsTest$m2.price,
                         predict_function = function(m, d) predict(m, d, n.trees = 1000))

library("nnet")
apartments_nnet_model <- nnet(m2.price ~ construction.year + surface + floor +
                                no.rooms + district, data = apartments,
                              linout=TRUE,
                              size = 50, maxit=100)

explainer_nnet <- explain(apartments_nnet_model,
                          data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)

library("caret")
mapartments <- model.matrix(m2.price ~ ., data = apartments)
mapartmentsTest <- model.matrix(m2.price ~ ., data = apartmentsTest)
apartments_knn_model <- knnreg(mapartments, apartments[,1], k = 5)

explainer_knn <- explain(apartments_knn_model,
                         data = mapartmentsTest, y = apartmentsTest$m2.price)

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

mp_svm <- model_performance(explainer_svm)
mp_svm

plot(mp_lm, mp_rf, mp_svm)
plot(mp_lm, mp_rf, mp_svm, geom = "boxplot")

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


vi_svm <- variable_importance(explainer_svm, loss_function = loss_root_mean_square)
vi_svm

plot(vi_lm, vi_rf, vi_svm)

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

sv_svm <- variable_response(explainer_svm,
                            variable = "construction.year", type = "pdp")
plot(sv_rf, sv_lm, sv_svm)

plot(variable_response(explainer_rf, variable = "construction.year", type = "ale"),
     variable_response(explainer_lm, variable = "construction.year", type = "ale"),
     variable_response(explainer_svm, variable = "construction.year", type = "ale"))

# Model explainers - Discrete variable response
#
## for district

svd_rf  <- variable_response(explainer_rf,
                             variable = "district", type = "factor")
svd_lm  <- variable_response(explainer_lm,
                             variable = "district", type = "factor")

plot(svd_rf, svd_lm)

svd_svm <- variable_response(explainer_svm,
                             variable = "district", type = "factor")

plot(svd_rf, svd_lm, svd_svm)

# Auditor
library(auditor)

audit_rf <- audit(explainer_rf)
audit_lm <- audit(explainer_lm)

plotResidual(audit_rf, variable = "construction.year")
plotResidual(audit_lm, variable = "construction.year")

plotResidualDensity(audit_rf, variable = "district")
plotResidualDensity(audit_lm, variable = "district")

audit_svm <- audit(explainer_svm)

plotResidual(audit_svm, variable = "construction.year")
plotResidualDensity(audit_svm, variable = "district")

plotResidual(audit_rf, audit_lm, audit_svm)

plotPrediction(audit_rf, audit_lm)
plotPrediction(audit_rf, audit_lm, audit_svm)

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
