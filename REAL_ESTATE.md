# Real estate valuation in R

Compare a linear baseline with a radial support vector machine using documented UCI fields: house age, distance to MRT, and number of nearby convenience stores. The target is price per unit area, measured in 10,000 New Taiwan dollars per ping in the source documentation.

## Reproduce

Run `Rscript download_data.R` from the repository root, then `Rscript real_estate_analysis.R` from the repository root. Requires `e1071`.

The dataset has 414 observations. Seed 1197317 selects 311 training and 103 test observations. SVM cost and epsilon are selected using five-fold cross-validation within training data; the final model scales predictors using the training set. Both models use the same test observations.

| Test metric | Linear regression | Radial SVM |
| --- | ---: | ---: |
| RMSE | 7.9205 | 6.8694 |
| MAE | 6.0286 | 5.1621 |
| R-squared, 1 - SSE/SST | 0.6125 | 0.7085 |

Selected SVM cost: 1; epsilon: 0.05. The nonlinear model has lower error on this split. One random split does not establish future-market or external performance, and these estimates do not prove causation.

## Relationship to the LinkedIn course summary

The earlier LinkedIn PDF uses a fourth predictor, `Dist`, from the course-provided CSV and reports SVM RMSE 5.64 versus 7.37 for linear regression. That field is absent from the official UCI file, so it is excluded from this public-data version. The scripts and results are deliberately separate. Do not mix the two sets of numbers.

`real_estate_course_version.R` accepts the original course CSV as a command-line argument and reproduces that earlier calculation. That course file is not redistributed because the additional field's provenance is unverified.

Source: Yeh, I. (2018). Real Estate Valuation, UCI, DOI: https://doi.org/10.24432/C5J30W. Data license: CC BY 4.0. Column names are shortened by `download_data.R`; values are preserved.
