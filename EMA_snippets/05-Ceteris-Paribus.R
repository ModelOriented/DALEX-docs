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

# Ceteris paribus plots with `predict_profile()`

cp_johny <- predict_profile(titanic_ex,
                 new_observation = johny_d)
cp_johny

# simple plot
plot(cp_johny)
plot(cp_johny, variables = c("age", "fare"))

# enhanced ggplot2 object
library("ggplot2")
plot(cp_johny, variables = c("age", "fare"))  +
  ggtitle("Ceteris Paribus for Johny D") +
  theme(panel.grid = element_blank()) +
  ylab("expected survival")


# simple plot for categorical variables
plot(cp_johny, variables = c("class", "gender"))


# Advanced use of the `predict_profiles()`

variable_splits = list(age = seq(0, 70, 0.1),
                       fare = seq(0, 100, 0.1))

titanic_cp <- predict_profile(titanic_ex, johny_d,
                              variable_splits = variable_splits)

# simple plot

plot(titanic_cp, variables = c("age", "fare"))



# second instance - mary
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

# profiles for both observations
cp_both <- predict_profile(titanic_ex, rbind(johny_d, mary_d))

# plot for johny_d and mary_d
plot(cp_both, variables = c("age", "fare"), color = "_ids_") +
  scale_color_manual(name = "Passenger:", breaks = 1:2,
                     values = c("#4378bf", "#8bdcbe"),
                     labels = c("johny_d" , "mary_d"))

# Champion-challenger analysis
# for two models

# train a logistic regression model
library("rms")
titanic_lmr <- lrm(survived ~ gender + rcs(age) + class +
                     sibsp + parch + fare + embarked, titanic_imputed)

# build an explainer
titanic_ex_lmr <- explain(titanic_lmr,
                          titanic_imputed,
                          label = "Logistic regression with splines")

# create the profile for lmr model
titanic_cp_lmr <- predict_profile(titanic_ex_lmr, johny_d,
                                  variable_splits = variable_splits)

# plot both profiles

plot(titanic_cp_lmr, titanic_cp,
     color = "_label_",
     variables = c("age", "fare"))




