# How to add a new explanation?

Let's suppose there is some new explanation that is not present in current version of the `dalex` Python package. How to add such explanation to the package with preservance of compliant structure? This list presents general schema of adding a new functionality on an example of [VIVO](https://github.com/ModelOriented/vivo) (Variable Importance via Oscillations). Contents of files will be discussed later.

1. Decide whether a new explanation is a `model_explanation` or `predict_explanation`
2. Create a new subdirectory in `DALEX/python/dalex/dalex/<choice>/` that starts with '_' and has a self-explanatory name, i.e. `DALEX/python/dalex/dalex/predict_explanations/_vivo`
3. Each directory consists always of 5 files, these files contain actual implementation:
	* `__init__.py`
	* `checks.py`
	* `object.py`
	* `plot.py`
	* `utils.py`
4. Add imports in all __init__.py files:
	* `DALEX/python/dalex/dalex/<choice>/_<new_explanation>/__init__.py`
	* `DALEX/python/dalex/dalex/<choice>/__init__.py`
5. Add an option directing to a new explanation in a proper method in `DALEX/python/dalex/dalex/_explainer/object.py`. For example, in case of VIVO, add a new `type` option called `vivo` in `predict_parts` and add a proper `if` statement.
6. Remember about a proper documentation!
7. Add tests in file `DALEX/python/dalex/test/test_<new explanation>.py`. For example, `DALEX/python/dalex/test/test_vivo.py` We use `unittest` package for testing.

## Implementation details


### `object.py`

File `object.py` is supposed to contain definition of explanation class. Instances of this class are returned as results of calling a coresponding explainer method and provide all functionalities required for calculation.

Our `__init__` methods usually do not contain any functionalities except creating object that has a defined task.

Method `fit` does actual job. We try to keep this method (and generally this file) as short as it is possible. Thus `fit` method sources high-level functionalities from `utils.py` and `checks.py` files. Its first argument (except `self` of course) is always an `explainer` that provides all necessary abstraction.

Method `plot` is used for plotting the result. Similarly like in `fit` method, this method uses only high-level methods sourced from `plot.py` file.

Method `_repr_html_` simply calls HTML representation of result `pandas` `DataFrame`.

### `utils.py`

This file contains low-level implementation of an explanation. Functions implemented here are used in an 'object.py' file.

### `checks.py`

File `checks.py` has an implementation of explanation-specific function checks that are performed in an `object.py` file. This includes but is not limited to: input type checks, input size checks, small transformations of data to a required format.

### `plot.py`

This file contains functions that are used in the `plot` method in an `object.py` file.

## Adding a new option to explainer method - details.

When you have implemented the explanation, now it is time to add this new functionality to the `explainer` and make it available for end users. You have to open `explainer`'s `object.py` file (this can be found here [`DALEX/python/dalex/dalex/_explainer/object.py`](https://github.com/ModelOriented/DALEX/blob/master/python/dalex/dalex/_explainer/object.py)) and find a method that best corresponds to the new explanation. For example, `VIVO` should be added to the `predict_parts` method. Each explanation method has a `type` parameter. Thus in order to add your new implementation, you should add a new `type` value option and add a new `if` statement in this method that redirects to your actual implementation.

```
def predict_parts(self,
                  new_observation,
                  type=('break_down_interactions', 'break_down', 'shap', 'shap_wrapper', 'vivo'),
                  ...):
```

```
elif _type == 'vivo':
    _predict_parts = Vivo(
        ...
    ) 
```

Finally, one can post an [issue on GitHub](https://github.com/ModelOriented/DALEX/issues/new) and make a [pull request](https://github.com/ModelOriented/DALEX/compare) with the implementation.

## Contributing

In order to contribute to the main `dalex` package, you have to fork a repository on Github, commit your changes, and create a Pull Request into the main branch. The Pull Request's name should start with `[python]` followed by a descriptive title (it is best to have a related open Issue).