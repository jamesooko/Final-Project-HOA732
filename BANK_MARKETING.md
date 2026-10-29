# Bank marketing classification in R

A corrected portfolio revision of the bank-marketing section of my completed HOA 732 coursework. Predict term-deposit subscription using client information and previous campaign history. This is an educational benchmark, not an operational targeting recommendation.

## Reproduce

Run `Rscript download_data.R` from the repository root, then `Rscript bank_marketing_analysis.R` from the repository root. Uses base R and `rpart`.

The official UCI `bank.csv` sample has 4,521 observations: 4,000 no and 521 yes. The local course copy differs in some job labels, so this revision explicitly uses the official source. Unknown categories are retained as reported rather than silently discarded.

## Evaluation

Seed 117317 creates stratified, disjoint training (2,712), validation (904), and test (905) sets. The test set has 105 subscribers. Call duration and current-campaign contact fields are excluded. Prior-contact sentinel -1 is represented by an explicit indicator and a zero-filled days field.

- Logistic regression uses `family=binomial`.
- The classification tree is pruned using five-fold cross-validation in training data.
- Each model's probability threshold maximizes F1 over 0.05 to 0.50 on validation data only. The models are not refitted after threshold selection.
- The majority baseline always predicts no. A constant training-prevalence score is used for its AUC and Brier score.

| Test metric | Majority baseline | Logistic regression | Decision tree |
| --- | ---: | ---: | ---: |
| Accuracy | 0.8840 | 0.8431 | 0.8851 |
| Subscriber precision | 0 | 0.3011 | 0.5217 |
| Subscriber recall | 0 | 0.2667 | 0.1143 |
| F1 | 0 | 0.2828 | 0.1875 |
| ROC AUC | 0.5000 | 0.7096 | 0.5503 |
| Balanced accuracy | 0.5000 | 0.5927 | 0.5503 |

Validation-selected thresholds: logistic 0.17; tree 0.10. Logistic regression identifies more subscribers on this split, at the cost of more false positives and lower overall accuracy. Neither model supports a strong performance claim. The tree's high accuracy conceals low subscriber recall.

## Limits

The random split is a benchmark, not chronological or external validation. F1 is a demonstration objective, not an estimated business cost. Deployment would require a decision-time data audit, customer-level separation if repeated identities are present, calibration and stability checks, and an appropriate review of how demographic and financial attributes are used. No customer identities are supplied or inferred here.

Source: Moro, S., Rita, P., & Cortez, P. (2014). Bank Marketing, UCI, DOI: https://doi.org/10.24432/C5K306. Data license: CC BY 4.0. Downloaded `bank.csv` is not modified; transformations occur in `analysis.R`.
