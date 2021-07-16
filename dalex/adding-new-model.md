
# How to add a new model?

`dalex` is compatible with many popular packages for machine learning such as `scikit-learn`, `xgboost` or `keras`. However, even if the model that one wants to explain comes from the package that is not directly handled, `dalex` can often manage such situation making some common assumptions.

However, sometimes happens that dalex cannot recognize and understand the model. In such situations you have two options to choose from. First option allows you to quickly tell dalex how to manage this particular model. Second option is to implement a wrapper in the package and then, possibly, contribute to the main project.

## In-line wrapper

This is the most common option in an everyday work. You have to define a function that takes two arguments: `model` - whatever it is; and `data` in a form of `pandas.DataFrame`. This function should return a 1D `numpy.ndarray` of regression predicates or classification probabilities of one of the classes. All explanations will be based on such probabilities, so the choice here is very important. If you have one special class, like for example minority class, and you are interested in finding instances of this class, you should choose its probabilities. `dalex` does not support multiclass predictions.

Example below shows implementation of such function for `xgboost` model that is already included in the package.

```
def predict_function(model, data):
    from xgboost import DMatrix
    return model.predict(DMatrix(data))
```

This function is then passed to `explainer`'s constructor:

```
dx.Explainer(model, X, y, predict_function=predict_function)
```

This feature can be also usefull if our actual target is a transformation of a target used in a training. This case is covered in [FIFA example](https://github.com/ModelOriented/DALEX-docs/blob/master/jupyter-notebooks/python-dalex-fifa.html). There model was trained using log transformation of a variable of our interest. In order to reverse this transformation in explainations you have to define a predict function:

```
def predict_function(model, data):
    return np.exp(model.predict(data))
```

and then pass this predict function to an `explainer`.

## Implementation in a package

Writing your own `predict_function` for a new model that `dalex` cannot manage is a first step in order to add this implementation to the project. Why would you want to add this implementation to the main project? Because then `dalex` explainer will learn how to recognize this kind of the model and you will no longer have to implement predict funtion whenever you want to use it.

All predict functions implemented in `dalex` are written in this [file](https://github.com/ModelOriented/DALEX/blob/master/python/dalex/dalex/_explainer/yhat.py). Please note that each such function starts with `yhat_` then there is a package name and, optionally an information if this is a classification of regression. If the model needs both regression and classification implementation then you should additionally create a function that returns one of these two predict functions.

For example, `h2o` models require both classification and regression implementation. Thus, we create two predict functions:

```
def yhat_h2o_regression(m, d):
    from h2o import H2OFrame
    return m.predict(H2OFrame(d, column_types=m._column_types)).as_data_frame().to_numpy().flatten()
```

and

```
def yhat_h2o_classification(m, d):
    from h2o import H2OFrame
    return m.predict(H2OFrame(d, column_types=m._column_types)).as_data_frame().to_numpy()[:, 2]
```

At the end, we create one master function that returns one of these two:

```
def get_h2o_yhat(model):
    if not str(type(model)).startswith("<class 'h2o.estimators"):
        return None
    
    if model.type == 'classifier':
        return yhat_h2o_classification, "classification"
    if model.type == 'regressor':
        return yhat_h2o_regression, "regression"
```

When we have this implementation, we need to add this to the package. In the same file there is a dictionary called `yhat_exception_dict`. This dictionary redirects all models that require special treatment to a proper predict function. In order to add this implementation we need to add a key to this dictionary - name of the model (please note that this is a long name, not the short one); and a value - a predict function.

That's all you need to do.

## Contributing

In order to contribute to the main `DALEX` project, you have to fork a repository on Github, commit your changes and create a Pull Request to Master. Each Pull Request's name has to start with `[python]`, has to have a descriptive name (good to have a related open Issue) and has to have a proper badges.