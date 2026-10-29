# R analytics and machine learning portfolio

**James Ooko** | [LinkedIn](https://www.linkedin.com/in/james-ooko-056124194/) | [GitHub](https://github.com/jamesooko)

Reviewed portfolio revisions of my completed HOA 732 coursework. The original submitted R Markdown remains in the repository. The files below contain corrected, runnable analyses and checked results prepared in October 2026.

## Projects

| Project | Question | Methods | Result on the held-out split |
| --- | --- | --- | --- |
| [Real estate valuation](REAL_ESTATE.md) | Can a nonlinear model improve a regression baseline? | Linear regression, radial SVM, training-only cross-validation | RMSE 7.92 for linear regression; 6.87 for SVM |
| [Bank marketing](BANK_MARKETING.md) | Can pre-call information identify term-deposit subscribers? | Binomial logistic regression, pruned classification tree, validation-selected thresholds | Logistic test ROC AUC 0.710; subscriber recall 0.267 |

Results are limited to the documented datasets and random splits. These are educational analyses, not deployed valuation or customer-targeting systems.

## Run

Use R with `e1071`, `rpart`, and `readxl`. Install missing packages once:

```r
install.packages(c("e1071", "rpart", "readxl"))
```

From the repository root:

```sh
Rscript download_data.R
Rscript real_estate_analysis.R
Rscript bank_marketing_analysis.R
```

Each project writes its calculations to its own `real_estate_results/` or `bank_marketing_results/` folder. Expected results and runtime versions are included. Seeds and splits are set in the scripts. Small numerical differences can occur across R/package versions.

## What changed from the coursework

- Bank marketing now uses binary classification throughout. It excludes call duration and current-campaign fields, uses separate training/validation/test observations, and reports subscriber precision and recall alongside accuracy.
- Thresholds use validation data, never test outcomes. The tree is pruned using cross-validation within training data.
- Real estate's public-data version excludes the course-only `Dist` field because its source and units are unverified. The original four-predictor course revision shown in the earlier LinkedIn PDF remains reproducible with `real_estate_course_version.R` and the original course CSV. Its results differ and should not be compared as the same experiment.
- The original raw coursework is historical reference. Use the reviewed scripts for the reviewed implementation and current interpretation.

## Data and attribution

Data are downloaded from UCI rather than silently republishing local course files.

- Yeh, I. (2018). *Real Estate Valuation*. UCI Machine Learning Repository. https://doi.org/10.24432/C5J30W. [Source and CC BY 4.0 notice](https://archive.ics.uci.edu/dataset/477/real%26).
- Moro, S., Rita, P., & Cortez, P. (2014). *Bank Marketing*. UCI Machine Learning Repository. https://doi.org/10.24432/C5K306. [Source and CC BY 4.0 notice](https://archive.ics.uci.edu/dataset/222/bank+marketing).

Dataset rights remain with their creators under CC BY 4.0. Transformations are documented in the download and analysis scripts. Code and narrative are presented as James Ooko's coursework with a later reviewed portfolio revision; the datasets and algorithms are not claimed as original inventions.
