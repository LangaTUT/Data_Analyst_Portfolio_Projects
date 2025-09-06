/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/
select *
from coviddeaths
where continent is not null
order by 3,4;

-- Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1,2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%states%' and continent is not null
order by 1,2;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location, date, population, total_cases, (total_cases/population)*100 as percentPopulation
from coviddeaths
where continent is not null
order by 1,2;


-- Countries with Highest Infection Rate compared to Population

select location, population, max(total_cases) as highestInfectionCount, max((total_cases/population))*100 as percentPopulationInfected
from coviddeaths
where continent is not null
group by location, population, continent
order by percentPopulationInfected desc;


-- Countries with Highest Death Count per Population

select location, max(cast(total_deaths as int)) as totalDeathCount
from coviddeaths
where continent is not null and total_deaths is not null
group by location
order by totalDeathCount desc;


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

select continent, max(cast(total_deaths as int)) as totalDeathCount
from coviddeaths
where continent is not null and total_deaths is not null
group by continent
order by totalDeathCount desc;



-- GLOBAL NUMBERS

select sum(new_cases) as sumNewCases, sum(new_deaths) as sumNewDeaths, sum(new_deaths)/sum(new_cases)*100 as deathPercentage
from coviddeaths
where continent is not null
order by 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date) as rollingPeopleVaccinated
from coviddeaths as dea
join covidvaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3;


-- Using CTE to perform Calculation on Partition By in previous query

WITH popVSvac(continent, location, date, population, new_vaccinations, rollingPeopleVaccinated) AS
(
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
SELECT *, (rollingPeopleVaccinated/population)*100
FROM popVSvac;


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS percentPopulationVaccinated;
CREATE TEMP TABLE percentPopulationVaccinated
(
    continent TEXT,
    location TEXT,
    date DATE,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rollingPeopleVaccinated NUMERIC
);

INSERT INTO percentPopulationVaccinated (continent, location, date, population, new_vaccinations, rollingPeopleVaccinated)
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
ORDER BY 2,3;
SELECT
    *,
    (rollingPeopleVaccinated /population) * 100 AS percentVaccinated
FROM percentPopulationVaccinated;


-- Creating View to store data for later visualizations

CREATE OR REPLACE VIEW percentPopulationVaccinated AS
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
WHERE dea.continent IS NOT NULL;

