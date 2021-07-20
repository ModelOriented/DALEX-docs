# How to add a new fairness metric? 
Fairness module supports all metrics that are based on the confusion matrix. 
If user wants to add a custom metric there are certain actions to be performed. 

## Necessary steps
1. Go to file containing support functions and classes in fairness module `DALEX/python/dalex/dalex/fairness/_group_fairness/utils.py` 

2. In a class `SubgroupConfusionMatrixMetrics` add a formula for a metric that depends on confusion matrix and bind it to some variable. This variable should be initialized with `np.nan` just like other metrics. If there is a denominator, be sure that it is greater than zero. Add the variable to `cf_metrics` dict. 

3. Now the new metric is accessible through the fields in the object (eg. `parity_loss`) and through various visualization methods after passing it to the `metrics` parameter. 

## Adding a new metric to `fairness_check` plot and print
To add the metric to `fairness_check` plot type and print method there are following actions to be performed. 

1. First to function `fairness_check_metrics()` in `DALEX/python/dalex/dalex/fairness/_group_fairness/utils.py` add your metric or supersede the existing one. 

2. Then in function `plot_fairness_check_clf()` in `DALEX/python/dalex/dalex/fairness/_group_fairness/plot.py` where names of metric are changed, you may also change your name. 

3. In the same file in function `_metric_ratios_2_df()` be sure to also add the metric to the existing filter (add/supersede with your metric in `data = data.loc[data.metric.isin(["TPR", "ACC", "PPV", "FPR", "STP"])]`). Now the plotting should work properly. 

4. If you added a new metric instead of superseding existing one, be sure to adjust the fairness criterions in `fairness_check()` method of `GroupFairnessClassification` object in `DALEX/python/dalex/dalex/fairness/_group_fairness/object.py`. Simply adjust the parameters in `utils.universal_fairness_check()` function call (the `num_for_not_fair` and `num_for_no_decision` which denote the number of metrics that are needed to call the model not fair and for no decision respectively). 

## Adding a new metric to `metric_scores` plot
To add a metric to `metric_scores` plot similar steps are needed like in step section above. 

1. In `DALEX/python/dalex/dalex/fairness/_group_fairness/plot.py` in `plot_metric_scores()` function the metric should be changed/added in *metric choosing and name change* section. 

2. Here, the number of panels is set to 5 so if a new metric is added instead of superseded, there are a little coding to be done. The numbers of refs should be incremented along with panels names change.  
