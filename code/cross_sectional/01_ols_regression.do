/**********************************************************
*  UK Housing Price Analysis
*  01_ols_regression.do
*
*  Purpose: Perform cross-sectional OLS regressions on 
*           House_Price and Price_Per_Sqft
*  Note   : This script uses the pre-processed dataset
**********************************************************/

clear all
set more off
version 18   // Change to your Stata version if needed

*===================== 1. Setup Paths =====================
global root "..\\..\\"                     // Root of the project

global data     "$root/data/processed/house_price_reg_processed.csv"
global figures  "$root/results/figures/"
global logs     "$root/code/cross_sectional/logs/"
global tables   "$root/results/tables/"

* Create directories if they don't exist
capture mkdir "$figures"
capture mkdir "$logs"
capture mkdir "$tables"

* Start log file
log using "$logs/01_ols_regression.log", replace text

*===================== 2. Load Processed Data =====================
import delimited using "$data", clear
display "Dataset loaded: " _N " observations, " c(k) " variables"

* Basic data check
describe
summarize

*===================== 3. Descriptive Statistics =====================
display _n "=== Descriptive Statistics ==="
summarize square_footage num_bedrooms num_bathrooms year_built ///
          lot_size garage_size neighborhood_quality house_price ///
          house_age price_per_sqft, detail

*===================== 4. Graphical Analysis =====================
display _n "=== Generating Graphs ==="

* Correlation matrix
correlate square_footage num_bedrooms num_bathrooms year_built ///
          lot_size garage_size neighborhood_quality house_price ///
          house_age price_per_sqft

graph matrix square_footage num_bedrooms num_bathrooms year_built ///
             lot_size garage_size neighborhood_quality house_price ///
             house_age price_per_sqft, title("Correlation Matrix")

graph export "$figures/correlation_matrix.png", replace width(2000)
graph close

* Scatter plots - House_Price
local price_vars square_footage house_age num_bedrooms num_bathrooms lot_size garage_size neighborhood_quality price_per_sqft

foreach var of local price_vars {
    scatter house_price `var', title("House Price vs `var'") ///
        ytitle("House Price") xtitle("`var'")
    graph export "$figures/scatter_house_price_vs_`var'.png", replace
    graph close
}

* Scatter plots - Price_Per_Sqft
foreach var of local price_vars {
    if "`var'" != "price_per_sqft" {   // Avoid plotting against itself
        scatter price_per_sqft `var', title("Price per Sqft vs `var'") ///
            ytitle("Price per Sqft") xtitle("`var'")
        graph export "$figures/scatter_price_per_sqft_vs_`var'.png", replace
        graph close
    }
}

*===================== 5. OLS Regression - House_Price =====================
display _n "=== OLS Regression: House Price ==="

* Full model
regress house_price square_footage house_age num_bedrooms ///
                   num_bathrooms lot_size garage_size neighborhood_quality

* Reduced model (remove insignificant neighborhood_quality)
regress house_price square_footage house_age num_bedrooms ///
                   num_bathrooms lot_size garage_size

* Model diagnostics
vif
estat hettest

*===================== 6. OLS Regression - Price_Per_Sqft =====================
display _n "=== OLS Regression: Price per Square Foot ==="

* Full model
regress price_per_sqft square_footage house_age num_bedrooms ///
                      num_bathrooms lot_size garage_size neighborhood_quality

* Reduced model
regress price_per_sqft square_footage house_age num_bedrooms ///
                      num_bathrooms lot_size garage_size

* Diagnostics
vif
estat hettest

* Robust standard error for Price_Per_Sqft (due to heteroscedasticity)
regress price_per_sqft square_footage house_age num_bedrooms ///
                      num_bathrooms lot_size garage_size, robust

*===================== 7. Final Output =====================
display _n "01_ols_regression.do completed successfully!"
display "   All graphs saved to: $figures"
display "   Log file saved to: $logs/01_ols_regression.log"

log close