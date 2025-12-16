## Stratified Sampling

This R Shiny application demonstrates stratified sampling design for
estimating the population mean under Sampling-2.

### Objectives
- Determine required sample size for population mean
- Incorporate number of strata, sampling bias, survey cost, and time
- Compare allocation strategies:
  - Proportional Allocation
  - Neyman Allocation
  - Optimised Allocation (Cost + Time)
- Visualize the design of experiment

### Methodology
- Sample size derived using variance-based estimator with bias control
- Allocation strategies:
  - Proportional: n_h ∝ N_h
  - Neyman: n_h ∝ N_h S_h
  - Optimised: n_h ∝ N_h S_h / √(cost + time)
- Simple random sampling within each stratum
- Interactive R Shiny interface

### Tools Used
- R
- Shiny

### How to Run
1. Open RStudio
2. Set working directory to project folder
3. Run `app.R`
4. Click **Run Stratified Design**
