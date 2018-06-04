library("DALEX")
head(apartments)

# create a linear model
apartments_lm_model <- lm(m2.price ~ construction.year + surface + floor +
                            no.rooms + district, data = apartments)
summary(apartments_lm_model)

# create a random forest model
library("randomForest")
set.seed(3)

apartments_rf_model <- randomForest(m2.price ~ construction.year + surface + floor +
                                      no.rooms + district, data = apartments)

apartments_rf_model

# 1. To use DALEX you need an explainer

explainer_lm <- explain(apartments_lm_model,
                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)
explainer_lm

explainer_rf <- explain(apartments_rf_model,
                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)
explainer_rf


#
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

## for surface

sv_rf  <- variable_response(explainer_rf,
                            variable =  "surface", type = "pdp")
sv_lm  <- variable_response(explainer_lm,
                            variable =  "surface", type = "pdp")
plot(sv_rf, sv_lm)

#
# Model explainers - Discrete variable response
#
## for district

svd_rf  <- variable_response(explainer_rf,
                           variable = "district", type = "factor")
svd_lm  <- variable_response(explainer_lm,
                           variable = "district", type = "factor")

plot(svd_rf, svd_lm)

#
# Model explainers - Performance
#

# root mean square
predicted_mi2_lm <- predict(apartments_lm_model, apartmentsTest)
sqrt(mean((predicted_mi2_lm - apartmentsTest$m2.price)^2))
## [1] 283.0865

# root mean square
predicted_mi2_rf <- predict(apartments_rf_model, apartmentsTest)
sqrt(mean((predicted_mi2_rf - apartmentsTest$m2.price)^2))
## [1] 283.3479


# Model performance

mp_lm <- model_performance(explainer_lm)
mp_lm

mp_rf <- model_performance(explainer_rf)
mp_rf

plot(mp_lm, mp_rf, geom = "boxplot")
plot(mp_lm, mp_rf)

mp_rf <- model_performance(explainer_rf)

library(ggplot2)
ggplot(mp_rf, aes(observed, diff)) + geom_point() + geom_smooth(se = FALSE) +
  xlab("Observed") + ylab("Predicted - Observed") +
  ggtitle("Diagnostic plot for the random forest model") + theme_mi2()

ggplot(mp_lm, aes(observed, diff)) + geom_point() + geom_smooth(se = FALSE) +
  xlab("Observed") + ylab("Predicted - Observed") +
  ggtitle("Diagnostic plot for the linear model") + theme_mi2()


# with auditor

isFALSE <- function(x) x == FALSE

library(auditor)
audit_rf <- audit(explainer_rf)
plotResidual(audit_rf, variable = "construction.year")

audit_lm <- audit(explainer_lm)
plotResidual(audit_lm, variable = "construction.year")


#
# Model explainers - variable importance
#

vi_rf <- variable_importance(explainer_rf, loss_function = loss_root_mean_square)
vi_rf

plot(vi_rf)

vi_lm <- variable_importance(explainer_lm, loss_function = loss_root_mean_square)
vi_lm

plot(vi_lm, vi_rf)



# 5. Outlier detection

mp_rf <- model_performance(explainer_rf)

library("ggplot2")
ggplot(mp_rf, aes(observed, diff)) + geom_point() +
  xlab("Observed") + ylab("Predicted - Observed") +
  ggtitle("Diagnostic plot for the random forest model") + theme_mi2()

# 6. break Down

which.min(mp_rf$diff)
## 1161
new_apartment <- apartmentsTest[which.min(mp_rf$diff), ]
new_apartment


new_apartment_rf <- single_prediction(explainer_rf,
                        observation = new_apartment)
new_apartment_lm <- single_prediction(explainer_lm,
                        observation = new_apartment)
plot(new_apartment_lm, new_apartment_rf)


#
# Excercises
# Try this yourself!
#

library("DALEX")
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

library("e1071")
apartments_svm_model <- svm(m2.price ~ construction.year + surface + floor +
                              no.rooms + district, data = apartments)

explainer_svm <- explain(apartments_svm_model,
                         data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)

library("caret")
mapartments <- model.matrix(m2.price ~ ., data = apartments)
mapartmentsTest <- model.matrix(m2.price ~ ., data = apartmentsTest)
apartments_knn_model <- knnreg(mapartments, apartments[,1], k = 5)

explainer_knn <- explain(apartments_knn_model,
                         data = mapartmentsTest, y = apartmentsTest$m2.price)

# Model performance

mp_knn <- model_performance(explainer_knn)
mp_svm <- model_performance(explainer_svm)
mp_gbm <- model_performance(explainer_gbm)
mp_nnet <- model_performance(explainer_nnet)
plot(mp_gbm, mp_nnet, mp_svm, mp_knn, geom = "boxplot")

# all models

plot(mp_gbm, mp_nnet, mp_svm, mp_knn, mp_lm, mp_rf, geom = "boxplot")
plot(mp_gbm, mp_nnet, mp_svm, mp_knn, mp_lm, mp_rf)
plot(mp_svm, mp_lm, mp_rf)

