library("pdp")
library("randomForest")
library("xgboost")
library("ggplot2")
library("ggthemes")
library("breakDown")
library("ALEPlot")
library("DALEX")

x <- seq(-1,2,by = 0.001)
y <- factor(rbinom(3001, 1, pmax(0.01, pmin(0.99, x))), levels = c("0", "1"))
df <- data.frame(y,x,x^2)
df_rf_model <- randomForest(y~x, data = df, ntree = 500)
df_glm_model <- glm(y~x, data = df, family = "binomial")

explainer_rf  <- explain(df_rf_model, data = df)
explainer_glm <- explain(df_glm_model, data = df)

expl_rf  <- single_variable(explainer_rf, "x", "ale")
expl_glm <- single_variable(explainer_glm, "x", "ale")

plot(expl_rf, expl_glm)


logit <- function(x) exp(x)/(1+exp(x))

HR_rf_model <- randomForest(left~., data = breakDown::HR_data, ntree = 100)
HR_glm_model <- glm(left~., data = breakDown::HR_data, family = "binomial")
model_martix_train <- model.matrix(left~.-1, breakDown::HR_data)
data_train <- xgb.DMatrix(model_martix_train, label = breakDown::HR_data$left)
param <- list(max_depth = 2, eta = 1, silent = 1, nthread = 2,
              objective = "binary:logistic", eval_metric = "auc")
HR_xgb_model <- xgb.train(param, data_train, nrounds = 50)
HR_xgb_model2 <- xgb.train(param, data_train, nrounds = 2)

explainer_rf  <- explain(HR_rf_model, data = HR_data)
explainer_glm <- explain(HR_glm_model, data = HR_data)
explainer_xgb <- explain(HR_xgb_model, data = model_martix_train)
explainer_xgb2 <- explain(HR_xgb_model2, data = model_martix_train, label = "xgb x2")

expl_rf  <- single_variable(explainer_rf, "satisfaction_level", "pdp", trans=logit)
expl_glm <- single_variable(explainer_glm, "satisfaction_level", "pdp", trans=logit)
expl_xgb <- single_variable(explainer_xgb, "satisfaction_level", "pdp", trans=logit)
expl_xgb2 <- single_variable(explainer_xgb2, "satisfaction_level", "pdp", trans=logit)

exel_rf  <- single_variable(explainer_rf, "satisfaction_level", "ale", trans=logit)
exel_glm <- single_variable(explainer_glm, "satisfaction_level", "ale", trans=logit)
exel_xgb <- single_variable(explainer_xgb, "satisfaction_level", "ale", trans=logit)
exel_xgb2 <- single_variable(explainer_xgb2, "satisfaction_level", "ale", trans=logit)

plot(expl_rf)
plot(expl_glm)
plot(expl_xgb)
plot(expl_rf) + theme_classic()
plot(expl_rf) + theme_tufte()
pl <- plot(expl_rf, expl_glm, expl_xgb, expl_xgb2)
pl
plot(expl_rf, exel_rf)
plot(expl_glm, exel_glm)
plot(expl_xgb, exel_xgb)

plot(expl_rf, expl_glm, exel_rf, exel_glm)


HR_rf_model %>% explain %>% marginal_response %>% plot()

part <- partial(HR_rf_model, "satisfaction_level")
plotPartial(part)
variable = "satisfaction_level"

# ------

# variable importance
unloadNamespace("DALEX")
library("DALEX")
library("randomForest")
library("xgboost")
library("breakDown")

HR_rf_model <- randomForest(left~., data = breakDown::HR_data, ntree = 100)
explainer_rf  <- explain(HR_rf_model, data = HR_data, y = HR_data$left)

variable_dropout(explainer_rf)

HR_glm_model <- glm(left~., data = breakDown::HR_data, family = "binomial")
model_martix_train <- model.matrix(left~.-1, breakDown::HR_data)
data_train <- xgb.DMatrix(model_martix_train, label = breakDown::HR_data$left)
param <- list(max_depth = 2, eta = 1, silent = 1, nthread = 2,
              objective = "binary:logistic", eval_metric = "auc")
HR_xgb_model <- xgb.train(param, data_train, nrounds = 50)

explainer_rf  <- explain(HR_rf_model, data = HR_data, y = HR_data$left)
explainer_glm <- explain(HR_glm_model, data = HR_data, y = HR_data$left)
explainer_xgb <- explain(HR_xgb_model, data = model_martix_train, y = HR_data$left, label = "xgboost")


logit <- function(x) exp(x)/(1+exp(x))

vd1 <- variable_dropout(explainer_rf, type = "raw")
vd2 <- variable_dropout(explainer_glm, type = "raw",
                 loss_function = function(observed, predicted) sum((observed - logit(predicted))^2))
vd3 <- variable_dropout(explainer_xgb, type = "raw")

plot(vd1)
plot(vd2)
plot(vd3)

plot(vd1, vd2, vd3)

nn <- rbind(vd1, vd2, vd3)

library(ggplot2)

ggplot(nn, aes(label, dropout_loss, shape = variable, group=variable)) +
  geom_point(position = "dodge") +
  geom_line() + scale_shape_manual(values=LETTERS) +
  coord_flip()

library(dplyr)
expl_df <- nn
bestFits <- expl_df[expl_df$variable == "_full_model_", ]
ext_expl_df <- merge(expl_df, bestFits[,c("label", "dropout_loss")], by = "label")

ext_expl_df$variable <- reorder(ext_expl_df$variable,
                                ext_expl_df$dropout_loss.x - ext_expl_df$dropout_loss.y,
                                mean)
max_vars = 10
trimmed_parts <- lapply(unique(ext_expl_df$label), function(label) {
  tmp <- ext_expl_df[ext_expl_df$label == label, ]
  tmp[tail(order(tmp$dropout_loss.x), max_vars), ]
})
ext_expl_df <- do.call(rbind, trimmed_parts)

ggplot(ext_expl_df, aes(variable, ymin = dropout_loss.y, ymax = dropout_loss.x)) +
  geom_errorbar() + coord_flip() +
  facet_wrap(~label, ncol = 1, scales = "free_y") +
  ylab("Drop-out Loss") + xlab("") +
  theme_mi2()



# ------

yhat <- function(X.model, newdata) as.numeric(predict(X.model, newdata))

res <- ALEPlot(breakDown::HR_data, HR_rf_model, K=40, yhat, J = variable)
res <- ALEPlot(breakDown::HR_data, HR_rf_model, K=50, yhat, J = variable)
res <- ALEPlot(breakDown::HR_data, HR_rf_model, K=100, yhat, J = variable)


# ----------

library(gbm)
library(DALEX)
library(breakDown)

# create a gbm model
model <- gbm(quality ~ pH + residual.sugar + sulphates + alcohol, data = wine,
             distribution = "gaussian",
             n.trees = 1000,
             interaction.depth = 4,
             shrinkage = 0.01,
             n.minobsinnode = 10,
             verbose = FALSE)

# make an explainer for the model
explainer_gbm <- explain(model, data = wine)

# create a new observation
new.wine <- data.frame(citric.acid = 0.35,
                       sulphates = 0.6,
                       alcohol = 12.5,
                       pH = 3.36,
                       residual.sugar = 4.8)

exp_sgn <- single_prediction(explainer_gbm, observation = new.wine, n.trees = 1000)

exp_sgn
plot(exp_sgn)




