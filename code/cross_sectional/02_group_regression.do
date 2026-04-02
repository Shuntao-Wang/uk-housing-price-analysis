/**********************************************************
*  UK Housing Price Analysis
*  02_group_regression.do
*
*  Purpose: Grouped regression by price segments + Chow Test
*           Test structural differences across low/medium/high price groups
**********************************************************/

clear all
set more off
version 18

*===================== 1. Setup Paths =====================
global root "..\\..\\"

global data     "$root/data/processed/house_price_reg_processed.csv"
global figures  "$root/results/figures/"
global logs     "$root/code/cross_sectional/logs/"
global tables   "$root/results/tables/"

* Create directories
capture mkdir "$figures"
capture mkdir "$logs"
capture mkdir "$tables"

* Start logging
log using "$logs/02_group_regression.log", replace text

*===================== 2. Load Processed Data =====================
import delimited using "$data", clear
display "Dataset loaded: " _N " observations"

*===================== 3. Create Price Groups =====================
display _n "=== Creating Price Groups (Tertiles) ==="

egen low_threshold  = pctile(house_price), p(33.33)
egen high_threshold = pctile(house_price), p(66.67)

gen price_group = .
replace price_group = 1 if house_price <= low_threshold
replace price_group = 2 if house_price > low_threshold & house_price <= high_threshold
replace price_group = 3 if house_price > high_threshold

label define price_group_lbl 1 "Low" 2 "Medium" 3 "High"
label values price_group price_group_lbl

tab price_group, missing

* Summary statistics by group
table price_group, statistic(mean house_price square_footage house_age) 
table price_group, statistic(mean num_bedrooms num_bathrooms lot_size garage_size)

*===================== 4. Grouped OLS Regressions =====================
display _n "=== OLS Regressions by Price Group ==="

* Pooled regression (all data)
regress house_price square_footage house_age num_bedrooms num_bathrooms lot_size garage_size
estimates store pooled
scalar rss_pooled = e(rss)
scalar df_pooled = e(df_r)

* Group 1: Low price
regress house_price square_footage house_age num_bedrooms num_bathrooms lot_size garage_size if price_group == 1
estimates store low
scalar rss1 = e(rss)
scalar df1 = e(df_r)

* Group 2: Medium price
regress house_price square_footage house_age num_bedrooms num_bathrooms lot_size garage_size if price_group == 2
estimates store medium
scalar rss2 = e(rss)
scalar df2 = e(df_r)

* Group 3: High price
regress house_price square_footage house_age num_bedrooms num_bathrooms lot_size garage_size if price_group == 3
estimates store high
scalar rss3 = e(rss)
scalar df3 = e(df_r)

*===================== 5. Chow Test =====================
display _n "=== Chow Test for Structural Break ==="

scalar k = e(df_m) + 1          // number of parameters (including intercept)
scalar n = _N                   // total sample size

scalar f_chow = ((rss_pooled - (rss1 + rss2 + rss3)) / k) / ///
                ((rss1 + rss2 + rss3) / (n - 3*k))

scalar p_value = Ftail(k, n - 3*k, f_chow)

display "Chow Test F-statistic : " %9.4f f_chow
display "Degrees of freedom    : " k ", " n-3*k
display "P-value               : " %6.4f p_value

if p_value < 0.05 {
    display "Result: Reject null hypothesis. Significant structural differences across price groups."
}
else {
    display "Result: Fail to reject null. No strong evidence of structural differences."
}

*===================== 6. Export Regression Tables (Optional but Recommended) =====================

* Export all models to one nice table
esttab pooled low medium high using "$tables/ols_by_price_group.csv", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    title("OLS Regression by Price Group") ///
    scalars("r2 R-squared" "N Observations") ///
    label compress

esttab pooled low medium high using "$tables/ols_by_price_group.tex", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    title("OLS Regression by Price Group") ///
    scalars("r2 R-squared" "N Observations") ///
    label compress

display _n "Regression tables exported:"
display "   - $tables/ols_by_price_group.csv"
display "   - $tables/ols_by_price_group.tex"

*===================== 7. Final Message =====================
display _n "02_group_regression.do completed successfully!"
display "   Log file     : $logs/02_group_regression.log"
display "   Tables saved : $tables/ols_by_price_group.*"

log close