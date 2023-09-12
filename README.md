# COVID-19 Data Exploration

This project performs analysis on COVID-19 data to uncover insights and trends. Data is imported from CSVs into a MySQL database and explored through SQL queries.

#### Data
The data contains two tables:

CovidDeaths - COVID-19 daily death figures globally

CovidVaccinations - Daily vaccination figures globally


#### Analysis
The analysis focuses on:

-- Calculating mortality, infection rates, and vaccination rates

-- Identifying countries and continents with highest impacts

-- Joining the two datasets to analyze vaccination progress vs population

-- Using CTEs and temp tables to calculate rolling vaccination rates

-- Creating views to store data for visualizations


##### Key Insights

--- The US has a 1.8% COVID mortality rate

--- Peru has the highest COVID infection rate at 9.7% of population

--- Europe has the highest continental mortality rate at 3.5%\

--- Globally, 4.66% of population has been vaccinated


#### Technical Notes

-- Imported CSV data into MySQL database
-- Wrote SQL queries to explore and analyze the data
Created views to store data for future visualization

This analysis provides a framework to continue exploring the COVID datasets and derive additional insights as needed. Views created enable quick access to key data joins for dashboarding.
