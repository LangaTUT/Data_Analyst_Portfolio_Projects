-- TABLE NAME coviddeaths starts here
-- select everything from coviddeaths/covidvaccinations table order them by column positions
select *
from coviddeaths
where continent is not null
order by 3,4;

-- select Data that we are going to be using
select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1,2;

-- Looking at the total cases vs the total deaths
-- shows the likelyhood of dying if you contract covid in your location
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%states%' and continent is not null
order by 1,2;


-- looking at the total cases vs population
-- shows the percentage of population that got covid
select location, date, population, total_cases, (total_cases/population)*100 as percentPopulation
from coviddeaths
-- where location like '%states%'
where continent is not null
order by 1,2;


-- looking at the locations with the highest infection rate compared to population
select location, population, max(total_cases) as highestInfectionCount, max((total_cases/population))*100 as percentPopulationInfected
from coviddeaths
where continent is not null
group by location, population, continent
order by percentPopulationInfected desc;


-- showing the location with the highest death count per population
select location, max(cast(total_deaths as int)) as totalDeathCount
from coviddeaths
where continent is not null and total_deaths is not null
group by location
order by totalDeathCount desc;


-- let's break things down by continent
-- showing continets with the highest death count per population

select continent, max(cast(total_deaths as int)) as totalDeathCount
from coviddeaths
where continent is not null and total_deaths is not null
group by continent
order by totalDeathCount desc;


-- global numbers
select sum(new_cases) as sumNewCases, sum(new_deaths) as sumNewDeaths, sum(new_deaths)/sum(new_cases)*100 as deathPercentage
from coviddeaths
where continent is not null
order by 1,2;

-- looking at the total population vs vacinations
select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date) as rollingPeopleVaccinated
from coviddeaths as dea
join covidvaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3;


-- USE CTE
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


-- TEMP TABLE
-- Drop temp table if it exists
DROP TABLE IF EXISTS percentPopulationVaccinated;

-- Create temp table
CREATE TEMP TABLE percentPopulationVaccinated
(
    continent TEXT,
    location TEXT,
    date DATE,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rollingPeopleVaccinated NUMERIC
);

-- Insert data into the temp table
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
ORDER BY 2,3
-- Select from temp table with % vaccinated
SELECT
    *,
    (rollingPeopleVaccinated /population) * 100 AS percentVaccinated
FROM percentPopulationVaccinated;


-- creating view to store data for later visualizations
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
