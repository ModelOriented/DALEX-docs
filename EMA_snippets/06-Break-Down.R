# R snippets for Break-Down with DALEX
# read more about the metod at
# Explanatory Model Analysis
# https://pbiecek.github.io/ema/

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

# Prepare an instance

johny_d <- data.frame(
            class = factor("1st", levels = c("1st", "2nd",
                       "3rd", "deck crew",
                       "engineering crew",
                       "restaurant staff",
                       "victualling crew")),
            gender = factor("male", levels =
                              c("female", "male")),
            age = 8,
            sibsp = 0,
            parch = 0,
            fare = 72,
            embarked = factor("Southampton",
                        levels = c("Belfast","Cherbourg",
                           "Queenstown","Southampton")))
johny_d

predict(titanic_ex, johny_d)

# Break-down plots with `predict_parts()`

bd_rf <- predict_parts(titanic_ex,
                 new_observation = johny_d,
                 type = "break_down")
bd_rf

plot(bd_rf)

library("ggplot2")
plot(bd_rf) +
  ggtitle("Which variables affect survival of Johny D?") +
  theme(panel.grid = element_blank())

# Advanced use of the `predict_parts()`

bd_rf_order <- predict_parts(titanic_ex,
         new_observation = johny_d,
         type = "break_down",
         order = c("class", "age", "gender", "fare",
                   "parch", "sibsp", "embarked"))

plot(bd_rf_order)

bd_rf <- predict_parts(titanic_ex,
          new_observation = johny_d,
          type = "break_down")

plot(bd_rf, max_features = 3)




mary_d <- data.frame(
  class = factor("2nd", levels = c("1st", "2nd",
                                   "3rd", "deck crew",
                                   "engineering crew",
                                   "restaurant staff",
                                   "victualling crew")),
  gender = factor("female", levels =
                    c("female", "male")),
  age = 18,
  sibsp = 0,
  parch = 0,
  fare = 72,
  embarked = factor("Southampton",
                    levels = c("Belfast","Cherbourg",
                               "Queenstown","Southampton")))
mary_d
bd_rf_order <- predict_parts(titanic_ex,
                             new_observation = mary_d,
                             type = "break_down")

plot(bd_rf_order)

