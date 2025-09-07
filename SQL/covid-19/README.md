# 🦠 Covid-19 Data Exploration

This project focuses on exploring global Covid-19 data using **SQL**.  
It demonstrates how to analyze real-world datasets to uncover insights such as infection rates, death percentages, vaccination progress, and population-level impacts.  

The goal is to practice **SQL for data analysis** and prepare the dataset for further **visualizations** (e.g., in Tableau, Power BI, or Python).

---

## 📂 Project Overview

- **Dataset**: Covid-19 data (deaths and vaccinations)  
- **Database**: PostgreSQL (can also be adapted for SQL Server / MySQL)  
- **Objective**: Explore and analyze Covid-19 trends using SQL queries  

---

## 🛠️ Skills Demonstrated

- Joins (INNER JOIN)  
- Common Table Expressions (CTEs)  
- Temporary Tables  
- Window Functions (`OVER`, `PARTITION BY`, `ORDER BY`)  
- Aggregate Functions (`SUM`, `AVG`, `MAX`, `ROUND`)  
- Creating Views  
- Data Cleaning (handling NULLs, type casting)  
- Converting Data Types  

---

## 📊 Key Analyses Performed

1. **Basic Exploration**
   - Filter out NULL values for continent.
   - Select core fields: `location`, `date`, `total_cases`, `new_cases`, `total_deaths`, `population`.

2. **Total Cases vs Total Deaths**
   - Calculate **death percentage** to show the likelihood of dying if infected.

3. **Total Cases vs Population**
   - Calculate **percent of population infected**.

4. **Highest Infection Rates**
   - Identify countries with the **highest infection rate relative to population**.

5. **Highest Death Counts**
   - Find countries and continents with the **highest death counts**.

6. **Global Numbers**
   - Aggregate **total cases, total deaths, and global death percentage**.

7. **Vaccination Progress**
   - Compare **population vs vaccinations** using:
     - Window functions for rolling totals
     - CTEs for cleaner calculations
     - Temp tables for intermediate storage
     - Views for reusability in future visualizations

---

## 🗂️ File Structure

📦 covid-19
┣ 📜 Project1_covid.sql # Main SQL script with queries
┣ 📜 README.md # Project documentation

---

## 📈 Example Queries

### 1. Death Percentage for United States
```sql
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE location LIKE '%states%'
  AND continent IS NOT NULL
ORDER BY 1,2;
```
### 2. Countries with Highest Infection Rates
```sql
SELECT 
    location, 
    population, 
    MAX(total_cases) AS highestInfectionCount, 
    MAX((total_cases/population))*100 AS percentPopulationInfected
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population, continent
ORDER BY percentPopulationInfected DESC;
```
### 3. Vaccination Progress with CTE
```sql
WITH popVSvac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (
            PARTITION BY dea.location
            ORDER BY dea.date
        ) AS rollingPeopleVaccinated
    FROM coviddeaths AS dea
    JOIN covidvaccinations AS vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, 
       (rollingPeopleVaccinated/population)*100 AS percentVaccinated
FROM popVSvac;
```
📌 How to Use
1. Clone the Repository: Clone this project repository from GitHub.
2. Load the dataset into your database (coviddeaths, covidvaccinations).
3.Run the SQL script (Project1_covid.sql) in PostgreSQL or your preferred SQL environment.

📊 Possible Visualizations
**Global cases and deaths trend over time

**Infection rates by continent/country

**Vaccination progress vs population

**Mortality percentage comparisons

🚀 Future Improvements
**Automate data loading with Python or Airflow

**Create dashboards in Tableau/Power BI

**Use advanced SQL techniques (stored procedures, triggers)

**Integrate with APIs for live updates

🙌 Acknowledgements
Dataset sourced from Our World in Data.

🧑‍💻 Author
Thobeka Mabaso
📌 Aspiring Data Analyst | Skilled in SQL, Python, and Data Visualization
