# Scripts prepared for the DALEX workshop at UseR 2018
# Przemyslaw Biecek & Mateusz Staniak
# ----------------------------------------------------------------------
#
# The data
library("DALEX")
head(apartments)

#
# Two models
apartments_lm_model <- lm(m2.price ~ construction.year + surface + floor +
                            no.rooms + district, data = apartments)
summary(apartments_lm_model)

library("randomForest")
set.seed(3)

apartments_rf_model <- randomForest(m2.price ~ construction.year + surface + floor +
                            no.rooms + district, data = apartments)
apartments_rf_model

#
# Model performance as RMS calculated on validation data
predicted_mi2_lm <- predict(apartments_lm_model, apartmentsTest)
sqrt(mean((predicted_mi2_lm - apartmentsTest$m2.price)^2))

predicted_mi2_rf <- predict(apartments_rf_model, apartmentsTest)
sqrt(mean((predicted_mi2_rf - apartmentsTest$m2.price)^2))

# ----------------------------------------------------------------------

#
# DALEX architecture

# wrap model
explainer_rf <- explain(apartments_rf_model,
                        data = apartmentsTest[,2:6],
                        y    = apartmentsTest$m2.price)
# create explainer
sv_rf  <- single_variable(explainer_rf,
                        variable = "construction.year",
                        type     = "pdp")

# plot explainer
plot(sv_rf)

# other explainers
library("e1071")
apartments_svm_model <- svm(m2.price ~ construction.year + surface + floor +
                              no.rooms + district, data = apartments)

explainer_svm <- explain(apartments_svm_model,
                         data = apartmentsTest[,2:6],
                         y = apartmentsTest$m2.price)

apartments_lm_model <- lm(m2.price ~ construction.year + surface + floor +
                              no.rooms + district, data = apartments)

explainer_lm <- explain(apartments_lm_model,
                         data = apartmentsTest[,2:6],
                         y = apartmentsTest$m2.price)

# ----------------------------------------------------------------------

#
# Single continuous variable
# PDP, ALEPlot

sv_rf  <- single_variable(explainer_rf,
                          variable = "construction.year",
                          type     = "pdp")
# print explainer
sv_rf
# plot explainer
plot(sv_rf)


# create explainer
sv_svm  <- single_variable(explainer_svm,
                          variable = "construction.year",
                          type     = "pdp")

# print explainer
sv_svm
# compare explainers
plot(sv_rf, sv_svm)

#
# Single categorical variable
# Factor Merger Plots

sv_svm  <- single_variable(explainer_svm,
                           variable = "district",
                           type = "factor")

# print explainer
sv_svm
# plot explainer
plot(sv_svm)

# ----------------------------------------------------------------------
#
# Model performance

mp_svm <- model_performance(explainer_svm)
mp_svm

mp_rf <- model_performance(explainer_rf)
mp_rf

mp_lm <- model_performance(explainer_lm)
mp_lm

plot(mp_svm, mp_rf, mp_lm, geom = "boxplot")
plot(mp_svm, mp_rf, mp_lm)

#
# Model diagnostic

library("ggplot2")
ggplot(mp_rf, aes(observed, diff)) + geom_point() + geom_smooth(se = FALSE) +
  xlab("Observed") + ylab("Predicted - Observed") +
  ggtitle("Diagnostic plot for the random forest model") + theme_mi2()

ggplot(mp_svm, aes(observed, diff)) + geom_point() + geom_smooth(se = FALSE) +
  xlab("Observed") + ylab("Predicted - Observed") +
  ggtitle("Diagnostic plot for the linear model") + theme_mi2()


#
# with auditor

library("auditor")
audit_rf <- audit(explainer_rf)
plotResidual(audit_rf, variable = "construction.year")

audit_lm <- audit(explainer_lm)
plotResidual(audit_lm, variable = "construction.year")


#
# Variable importance

vi_rf <- variable_importance(explainer_rf, loss_function = loss_root_mean_square)
vi_rf

plot(vi_rf)

vi_lm <- variable_importance(explainer_lm, loss_function = loss_root_mean_square)
vi_svm <- variable_importance(explainer_svm, loss_function = loss_root_mean_square)

plot(vi_lm, vi_rf, vi_svm)


# ----------------------------------------------------------------------
# Ceteris Paribus Plots

# we need a DALEX object
explainer_rf <- explain(apartments_rf_model,
                        data = apartmentsTest[,2:6],
                        y    = apartmentsTest$m2.price)

# explanations for this data point
new_apartment <- apartmentsTest[1, ]

# as usual, create an explainer and plot it
library("ceterisParibus")
wi_rf <- ceteris_paribus(explainer_rf,
                         observation = new_apartment)

plot(wi_rf,
     split     = "variables",
     color     = "variables",
     quantiles = FALSE)

wi_svm <- ceteris_paribus(explainer_svm,
                         observation = new_apartment)

plot(wi_rf, wi_svm,
     split     = "variables",
     color     = "models",
     quantiles = FALSE)

# ----------------------------------------------------------------------
# Wangkardu Plots

# as usual, create an explainer and plot it
library("ceterisParibus")
new_apartment <- apartmentsTest[1, ]

cr_rf <- local_fit(explainer_rf,
                   observation   = new_apartment,
                   select_points = 0.002)
plot(cr_rf)
plot(cr_rf,       palette       = "wangkardu")

cr_svm <- local_fit(explainer_svm,
                    observation   = new_apartment,
                    select_points = 0.002)
plot(cr_svm)

# other point

new_apartment <- apartmentsTest[10, ]

cr_rf <- local_fit(explainer_rf,
                   observation   = new_apartment,
                   select_points = 0.002)
plot(cr_rf)

cr_svm <- local_fit(explainer_svm,
                    observation   = new_apartment,
                    select_points = 0.002)
plot(cr_svm)


#
# Break Down Plots

# for Random Forest Model
br_rf <- prediction_breakdown(explainer_rf,
                             observation = new_apartment)
plot(br_rf)

# + SVM models
br_svm <- prediction_breakdown(explainer_svm,
                              observation = new_apartment)
plot(br_rf, br_svm)

