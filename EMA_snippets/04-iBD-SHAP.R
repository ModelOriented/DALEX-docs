# R snippets for Break-Down with DALEX
# read more about the metod at
# Explanatory Model Analysis
# https://pbiecek.github.io/ema/

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
titanic_ex <- explain(titanic_rf,
                data  = titanic_imputed,
                y     = titanic_imputed$survived,
                label = "Regression Forest for Titanic")

# Prepare an instance

henry <- data.frame(
  class = factor("2nd", levels = c("1st", "2nd", "3rd",
                    "deck crew", "engineering crew",
                    "restaurant staff", "victualling crew")),
  gender = factor("male", levels = c("female", "male")),
  age = 15,
  sibsp = 0,
  parch = 0,
  fare = 100,
  embarked = factor("Cherbourg", levels = c("Belfast",
                  "Cherbourg", "Queenstown", "Southampton"))
)

henry

predict(titanic_ex, henry)

# Different orders in break-down plots

bd_rf_fag <- predict_parts(titanic_ex,
             new_observation = henry,
             order = c("class", "fare", "gender", "age",
                       "embarked", "sibsp", "parch"))
bd_rf_afg <- predict_parts(titanic_ex,
             new_observation = henry,
             order = c("fare", "class", "gender", "age",
                       "embarked", "sibsp", "parch"))

# Two break down plots

library("patchwork")
plot(bd_rf_afg) / plot(bd_rf_fag)

# Shapley values with `predict_parts()`

shap_henry <- predict_parts(titanic_ex,
                         henry,
                         type = "shap",
                         B    = 25)
shap_henry

# simple plot
plot(shap_henry)

# simple plot without boxplots
plot(shap_henry, show_boxplots = FALSE)

# enhanced ggplot2 object
library("ggplot2")
plot(shap_henry, show_boxplots = FALSE) +
  ggtitle("Shapley values for Johny D") +
  theme(panel.grid = element_blank())


# Break down with interactions with `predict_parts()`

library("DALEX")
ibd_henry <- predict_parts(titanic_ex,
                        new_observation = henry,
                        type = "break_down_interactions")
ibd_henry

# simple plot
plot(ibd_henry)

# enhanced ggplot2 object
plot(ibd_henry) +
  ggtitle("Break down with interactions for Henry") +
  theme(panel.grid = element_blank())

