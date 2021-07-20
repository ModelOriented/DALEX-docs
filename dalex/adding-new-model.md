
# How to add a new model?

`dalex` is compatible with many popular packages for machine learning such as `scikit-learn`, `xgboost` or `keras`. However, even if the model that one wants to explain comes from the package that is not directly handled, `dalex` can often manage such situation making some common assumptions.

It may happen that `dalex` cannot recognize and understand the model. In such situations, you have two options to choose from. First option allows to quickly tell `dalex` how to manage this particular model. Second option is to implement an abstraction layer in the package and then, possibly, contribute to the main project.

## In-line abstraction

This is the most common option in an everyday work. You have to define a function that takes two arguments: `model` - whatever it is; and `data` in a form of `pandas.DataFrame`. This function should return a 1D `numpy.ndarray` of regression predicates or classification probabilities of one of the classes. All explanations will be based on such probabilities, so the choice here is very important. If you have one special class, like for example minority class, and you are interested in finding instances of this class, you should choose its probabilities. `dalex` currently doesn't support multiclass predictions.

Example below shows an implementation of the predict abstraction for the `xgboost` model that is already included in the `dalex` package.

```
def predict_function(model, data):
    from xgboost import DMatrix
    return model.predict(DMatrix(data))
```

This function is then passed to `Explainer`'s constructor:

```
dx.Explainer(model, X, y, predict_function=predict_function)
```

This parameter is also useful if the actual target is a transformation of the target used in training. Such case is covered in the [FIFA example](https://github.com/ModelOriented/DALEX-docs/blob/master/jupyter-notebooks/python-dalex-fifa.html). There, a model is trained using the log transformation of the variable of interest. In order to reverse this transformation in explanations, you have to define a predict function:

```
def predict_function(model, data):
    return np.exp(model.predict(data))
```

and then pass this predict function to an `Explainer` object.

## In-package implementation

Implementing a new `predict_function` for a model that `dalex` cannot manage is a first step in order to add it to the package. Why would you want to add this implementation into the main project? Because then, `dalex.Explainer` learns how to recognize this kind of model and you will no longer need to implement a `predict_function` whenever you want to use it.

All predict functions implemented in `dalex` are written in [the yhat.py file](https://github.com/ModelOriented/DALEX/blob/master/python/dalex/dalex/_explainer/yhat.py). Please note that each function starts with `yhat_`, then there is (usually) a package name and, optionally, an information if this task is a classification or regression. Should the model need both, regression and classification implementation, then you will additionally create a function that returns one of these two predict functions.

For example, `h2o` models differ in the implementation for classification and regression. Thus, we create two predict functions:

```
def yhat_h2o_regression(m, d):
    from h2o import H2OFrame
    return m.predict(H2OFrame(d, column_types=m._column_types)).as_data_frame().to_numpy().flatten()

def yhat_h2o_classification(m, d):
    from h2o import H2OFrame
    return m.predict(H2OFrame(d, column_types=m._column_types)).as_data_frame().to_numpy()[:, 2]
```

Then, we create one master function that returns an appropriate `yhat`:

```
def get_h2o_yhat(model):
    if not str(type(model)).startswith("<class 'h2o.estimators"):
        return None
    
    if model.type == 'classifier':
        return yhat_h2o_classification, "classification"
    if model.type == 'regressor':
        return yhat_h2o_regression, "regression"
```

Now, this implementation can be added to the package. In [the same file](https://github.com/ModelOriented/DALEX/blob/master/python/dalex/dalex/_explainer/yhat.py), there is a dictionary called `yhat_exception_dict`. This dictionary redirects all models that require special treatment to a proper `predict_function`. In order to add this implementation, we need to add a new key into the dictionary - in this case, a class name of the model (please note that this is a long name, not the short one); and a value - `yhat`.

Finally, one can post an [issue on GitHub](https://github.com/ModelOriented/DALEX/issues/new) and make a [pull request](https://github.com/ModelOriented/DALEX/compare) with the implementation.

## Contributing

In order to contribute to the main `dalex` package, you have to fork a repository on Github, commit your changes, and create a Pull Request into the main branch. The Pull Request's name should start with `[python]` followed by a descriptive title (it is best to have a related open Issue).