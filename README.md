# UK Housing Price Analysis

**Quantitative and Time-Series Analysis of UK Housing Prices with Cross-Sectional and Temporal Dimensions**

This project investigates UK housing prices by integrating cross-sectional structural characteristics with temporal trends derived from construction year, using econometric and statistical methods.

## Project Overview

The analysis combines **cross-sectional** and **time-series** approaches to understand both the structural drivers of housing prices and their evolution over time.

- **Dependent variables**: Housing price and price per square foot (Price/sqft)
- **Structural features**: Floor area, number of bedrooms, bathrooms, lot size, garage capacity, and neighbourhood quality
- **Time dimension**: Construction year (used to construct yearly averages)

Cross-sectional analysis was primarily conducted in **Stata**, while **Python** was used for time-series modelling, stationarity testing, ARIMA forecasting, and visualization.

## Key Findings and Conclusions

### Cross-Sectional Analysis
- OLS regressions were estimated for both housing price and price per square foot.
- Properties were segmented into **low-, medium-, and high-price groups**.
- **Chow tests** confirmed statistically significant differences in coefficients across segments, highlighting **heterogeneous patterns in price formation**.
- The results illustrate the importance of feature importance analysis and segmentation-driven modelling when dealing with complex structured datasets.

### Time-Series Analysis
- Yearly averages of housing price and price per square foot were constructed using construction year as the time index.
- **Augmented Dickey-Fuller (ADF) tests** showed that housing prices are **stationary** over time, while price per square foot exhibits a **clear upward trend**.
- After first differencing, ARIMA models were fitted and selected based on AIC.
- Model comparison (including residual diagnostics and out-of-sample forecasts) identified **ARIMA(4,1,0)** as the best-performing model. It better captures autoregressive dynamics and produces more reliable forward-looking predictions for unit price.

### Dynamic Regression Analysis
- Grouped regressions over time were estimated to isolate temporal effects from structural features.
- Results reveal that the influence of key attributes — such as **floor area** and **lot size** — evolves differently across price segments.
- **More pronounced aging effects** were observed in high-price markets.

**Overall Insight**: This project demonstrates a unified framework that effectively integrates structural and temporal information, providing valuable support for predictive analytics and real estate decision-making.

## Project Structure
```
uk-housing-price-analysis/
├── README.md
├── requirements.txt
├── .gitignore
│
├── data/
│   ├── raw/
│   │   └── house_price_regression_dataset.csv
│   └── processed/
│       └── house_price_reg_processed.csv
│
├── code/
│   ├── preprocess/
│   │   └── data_preprocess.ipynb
│   │
│   ├── cross_sectional/
│   │   ├── 01_ols_regression.do
│   │   ├── 02_group_regression.do
│   │   ├── 03_visualization.ipynb
│   │   └── logs/
│   │
│   └── time_series/
│       ├── 01_time_series_analysis.ipynb
│       ├── 02_coefficient_dynamic.ipynb
│       └── outputs/
│
├── results/
│   ├── tables/
│   └── figures/
```

## How to Reproduce

### Prerequisites
- **Stata** (tested on Stata 17/18)
- **Python** 3.9+
- Jupyter Notebook

### Step-by-Step Reproduction

1. **Clone the repository**
   ```bash
   git clone https://github.com/Shuntao-Wang/uk-housing-price-analysis.git
   cd uk-housing-price-analysis
2.  **Install Python dependencies**
    ```
    pip install -r requirements.txt
    ```
3.  **Stata Requirements**
-   Stata 17 or 18
-   Install `esttab` or `outreg2` for better table export
4.  **Data Preparation**
    -   Run code/preprocess/data_preprocess.ipynb to generate the processed dataset (if needed).
5.  **Cross-Sectional Analysis (Stata + Python)**
    -   Open Stata and run the do-files in order:
        -   code/cross_sectional/01_ols_regression.do
        -   code/cross_sectional/02_group_regression.do
    -   Then open code/cross_sectional/03_visualization.ipynb for visualizations.
6.  **Time-Series Analysis (Python)**
    -   Run the notebooks in sequence:
        -   code/time_series/01_time_series_analysis.ipynb
        -   code/time_series/02_coefficient_dynamic.ipynb

**Note**: All scripts use relative paths. Please keep the folder structure as shown above.

## Technologies Used

-   **Stata**: Cross-sectional regression, Chow test, group analysis
-   **Python**: Time-series analysis, ARIMA modeling, visualization
    -   Key packages: pandas, numpy, statsmodels, matplotlib, seaborn, pmdarima

## Author

Shuntao Wang

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

This project demonstrates practical skills in econometric modelling, time-series forecasting, and reproducible research.
