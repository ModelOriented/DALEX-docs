# R snippets for DALEX
# read more about this tool at
# Explanatory Model Analysis
# https://pbiecek.github.io/ema/


# for pipes
library("magrittr")

# Prepare data
library("DALEX")
head(titanic_imputed)

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
titanic_ex <- explain(titanic_rf,
                data  = titanic_imputed,
                y     = titanic_imputed$survived,
                label = "Regression Forest for Titanic")



# internals
titanic_ex$model
titanic_ex$model_info
titanic_ex$data %>% head
titanic_ex$y_hat %>% head
titanic_ex$residuals %>% head
titanic_ex$label
titanic_ex$predict_function




# other functions from the DALEX package
# model performance (see more in episode 6)
titanic_ex %>%
  model_performance() %>%
  plot(geom = "roc")

# model parts (see more in episode 7)
titanic_ex %>%
  model_parts() %>%
  plot()

# model profile (see more in episode 8)
titanic_ex %>%
  model_profile() %>%
  plot(variables = c("age", "fare", "parch"))

# model diagnostic (see more in episode 9)
titanic_ex %>%
  model_diagnostics() %>%
  plot(variable = "age", yvariable = "abs_residuals")

single_passanger <- titanic_imputed[5,]
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


# champion challenger
library("rms")
set.seed(1313)
titanic_lmr <- lrm(survived == "yes" ~ gender + rcs(age) + class +
                        sibsp + parch + fare + embarked, titanic)
titanic_ex2 <- explain(titanic_lmr,
                      data  = titanic_imputed,
                      y     = titanic_imputed$survived,
                      label = "Logistic regression for Titanic")



plot(model_performance(titanic_ex) ,
     model_performance(titanic_ex2) ,
     geom = "roc")

plot(model_profile(titanic_ex)$agr_profiles ,
     model_profile(titanic_ex2)$agr_profiles ,
     variables = c("age", "fare", "parch"))



# The DrWhy.AI universe

DALEXtra -> wrappers for other models, like scikit learn
-> polazac strone z show cases

ingredients, iBreakdown, auditor, drifter -> DrWhy.AI

modelDown
modelStudio


library("modelDown")
modelDown(titanic_ex, titanic_ex2)


library("modelStudio")
modelStudio(titanic_ex, single_passanger)
