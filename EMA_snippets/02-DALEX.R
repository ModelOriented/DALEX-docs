# R snippets for DALEX
# read more about this tool at
# Explanatory Model Analysis
# https://pbiecek.github.io/ema/


# for pipes
library("magrittr")

# Prepare data
library("DALEX")
head(titanic_imputed)

dim(titanic_imputed)

# Train a model
library("ranger")
set.seed(1313)
titanic_rf <- ranger(survived ~ class + gender + age +
                 sibsp + parch + fare + embarked,
                 data = titanic_imputed,
                 probability = TRUE,
                 classification = TRUE)
titanic_rf




# Prepare an explainer

library("DALEX")
# basic use
titanic_ex <- explain(titanic_rf,
                data  = titanic_imputed,
                y     = titanic_imputed$survived,
                label = "Regression Forest")


# advanced use
titanic_ex <- explain(titanic_rf,
                data  = titanic_imputed,
                y     = titanic_imputed$survived,
                label = "Regression Forest",
                predict_function = function(model, data)
                  matrix(predict(model, data,
                                 probability = TRUE)$predictions,
                         ncol=2)[,2]
)


# internals
titanic_ex$model                # encapsulated model
titanic_ex$model_info           # version of model factory
titanic_ex$data %>% head        # encapsulated data
titanic_ex$predict_function     # derived predict
titanic_ex$y_hat %>% head       # calculated predictions
titanic_ex$residuals %>% head   # calculated residuals
titanic_ex$label                # the model label

# explanations from the DALEX package
# instance level
(single_passanger <- titanic_imputed[5,])
# prediction
titanic_ex %>%
  predict(single_passanger)

# prediction parts (see more in episode 3 and 4)
titanic_ex %>%
  predict_parts(new_observation = single_passanger) %>%
  plot()

# prediction profile (see more in episode 5)
titanic_ex %>%
  predict_profile(new_observation = single_passanger) %>%
  plot(variables = c("age", "fare", "parch"))


# dataset level
# model performance (see more in episode 6)
titanic_ex %>%
  model_performance() %>%
  plot(geom = "roc")

# model parts (see more in episode 7)
titanic_ex %>%
  model_parts() %>%
  plot(show_boxplots = FALSE)

# model profile (see more in episode 8)
titanic_ex %>%
  model_profile() %>%
  plot(variables = c("age", "fare", "parch"))

# model diagnostic (see more in episode 9)
titanic_ex %>%
  model_diagnostics() %>%
  plot(variable = "age", yvariable = "abs_residuals")


# champion challenger
# second model - logistic regression with rms
library("rms")
set.seed(1313)
titanic_lmr <- lrm(survived == "yes" ~ gender + rcs(age) +
                   class + sibsp + parch + fare +
                   embarked, titanic)
titanic_ex2 <- explain(titanic_lmr,
                    data  = titanic_imputed,
                    y     = titanic_imputed$survived,
                    label = "Logistic regression")

# ROC for both
plot(model_performance(titanic_ex) ,
     model_performance(titanic_ex2) ,
     geom = "roc")

# LIFT for both
plot(model_performance(titanic_ex) ,
     model_performance(titanic_ex2) ,
     geom = "lift")

# PDP for both
plot(model_profile(titanic_ex)$agr_profiles ,
     model_profile(titanic_ex2)$agr_profiles ,
     variables = c("age", "fare", "parch"))



# The DrWhy.AI universe

DALEXtra -> wrappers for other models, like scikit learn
-> polazac strone z show cases

ingredients, iBreakdown, auditor, drifter -> DrWhy.AI

modelDown
modelStudio

# example for model down
# static HTML site with data explainers for models
library("modelDown")
modelDown(titanic_ex, titanic_ex2)


# example for model studio
# interactive HTML site with data explainers for models

library("modelStudio")
modelStudio(titanic_ex, single_passanger)























