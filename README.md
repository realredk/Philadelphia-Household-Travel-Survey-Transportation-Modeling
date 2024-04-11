
# README - Philadelphia Household Travel Survey Transportation Modeling

## Overview
This project utilizes the 2012 Philadelphia Household Travel Survey to analyze transportation patterns and model transit ridership. The survey data includes detailed household, personal, vehicle, and trip information, aiding in comprehensive transportation studies for the Philadelphia area.

## Project Structure
- `data.Rda`: Environment data containing pre-processed datasets.
- `data_test.Rda`: Test data for validation and testing purposes.
- `Philadelphia Household Travel Survey Transportation Modeling.R`: Main R scripts for data analysis and modeling.
- `Philadelphia Household Travel Survey Transportation Modeling.docx`: Document detailing project objectives and methodology.
- `Philadelphia Household Travel Survey Transportation Modeling.pdf`: Document summarizing key findings and statistical analysis.
- `Data`:
  - `1_Household_Public.csv`: Household data from the survey.
  - `2_Person_Public.csv`: Individual person data from the surveyed households. (Not uploaded due to size constraints)
  - `3_Vehicle_Public.csv`: Vehicle data related to the surveyed households.
  - `4_Trip_Public.csv`: Trip data from the survey participants.

## Project Objectives
The objective of this project is to enhance understanding and application of transportation modeling using data from the 2012 Philadelphia Household Travel Survey. Key aspects of the project include:

1. **Travel Pattern Analysis**: Utilize the survey to plot histograms and describe the distribution of the total number of trips made by individuals, focusing on both motorized and non-motorized trips.
2. **Demographic Analysis**: Create variables to identify individuals who did not take any trips and analyze their demographic characteristics such as race, age, and income. This analysis helps understand the socio-economic factors influencing travel behaviors.
3. **Statistical Modeling**: Use station-level transit ridership data to build regression models that predict ridership based on proximity to jobs, population density, and station characteristics like being a terminal or having airport connections.
4. **Model Improvement**: Incorporate additional variables such as the type of rail station (heavy rail vs others) to refine the models and assess improvements in predictive accuracy and explanatory power.

These objectives aim to provide comprehensive insights into how demographic and economic factors affect travel patterns and how these patterns can be modeled to predict transit ridership effectively.

## Key Findings
- A significant number of trips are motorized, with a majority of trips falling within the 0-2 trips range.
- Non-travelers tend to be older, with a noticeable number of non-travelers in the highest age categories.
- Racial and economic disparities exist in travel patterns, with economic conditions being a strong predictor of travel likelihood.
- Station-level ridership is closely tied to the availability of nearby jobs and the demographic composition around stations.

## Usage
To replicate the project setup:
1. Load the R environment from `data.Rda` to access all necessary datasets and pre-configured settings.
2. Execute the scripts in `Philadelphia Household Travel Survey Transportation Modeling.R` to perform the analysis and view results.

## Acknowledgements
This project was conducted under the supervision of Erick Guerra at the University of Pennsylvania. Thanks to the Delaware Valley Regional Planning Commission (DVRPC) for providing the data used in this study.
