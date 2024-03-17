/* 
COVID Data Exploration Project

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


-- to see each table and all their columns
SELECT *
FROM coviddeaths 
ORDER BY location, date;

SELECT *
FROM covidvaccinations
ORDER BY location, date;

-- we can see that some data has their continent as NULL or spaces or blank, and their location as the continent, we need to exclude those
-- NULL doesnt filter out blank continent data therefore I will use a different syntax to filter them out 
SELECT *
FROM coviddeaths
WHERE continent > ''
ORDER BY location, date;

SELECT * 
FROM covidvaccinations
WHERE continent > ''
ORDER BY location, date;

-- the data imported had a string type for date and we need to update it to a datetime format with the year first
UPDATE coviddeaths SET date = DATE_FORMAT(STR_TO_DATE(date, '%m/%d/%Y %H:%i'), '%Y-%m-%d %H:%i:%s'); 

UPDATE covidvaccinations SET date = DATE_FORMAT(STR_TO_DATE(date, '%m/%d/%Y %H:%i'), '%Y-%m-%d %H:%i:%s'); 



-- exploring the table to see what relevant data or columns we can start with 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY location, date;

-- total cases vs total deaths (likelihood of dying if COVID is contracted in each country), lets look at the United Kingdom
SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases) * 100, 2)AS death_percentage
FROM coviddeaths
WHERE location like '%kingdom%' 
ORDER BY location, date;

-- lets look at the percentage of population infected with COVID (in the United Kingdom) 
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentageofPopulationInfected
FROM coviddeaths
WHERE location like '%kingdom%'
ORDER BY location, date;

-- lets compare infection rate between countries
Select location, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 as PercentageofPopulationInfected
From coviddeaths
GROUP BY location, population
ORDER BY PercentageofPopulationInfected DESC;

-- lets compare highest death count per population
-- needed to cast total_deaths as DECIMAL as the datatype was not NUMERIC
-- we also need to filter out data with NULL Or empty continent column as those have their continent as their location
Select Location, MAX(CAST(total_deaths AS DECIMAL)) AS TotalDeathCount
From coviddeaths
WHERE continent > ''
Group by location
order by TotalDeathCount DESC;

-- now lets look at comparing continents with highest death count per population
-- this also includes continent column that can have NULL or space/s 
SELECT location, MAX(CAST(total_deaths AS DECIMAL)) AS TotalDeathCount
FROM coviddeaths
WHERE continent = '' 
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Global numbers
-- need to filter out where locations were the continents and the continent is null or '' to prevent doubling the numbers 
SELECT SUM(new_cases) AS total_cases, 
SUM(CAST(new_deaths AS DECIMAL)) AS total_deaths, 
SUM(CAST(new_deaths AS DECIMAL))/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent > '';


-- join the coviddeaths table and the covidvaccinations table
-- comparison on total population vs total vaccinations
-- shows percentage of vaccinated people within a population (atleast 1 dose of vaccine), it shows a rolling count on people vaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CAST(new_vaccinations AS DECIMAL)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent > ''
ORDER BY location, date;

-- using CTE to perform a calculation on the Partition By on previous query

WITH Pop_vs_Vac AS (
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CAST(new_vaccinations AS DECIMAL)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent > '') 

SELECT * , (RollingPeopleVaccinated/population)*100 AS PercentageofPeopleVaccinated
FROM Pop_vs_Vac
ORDER BY PercentageofPeopleVaccinated DESC;

-- Using a TEMP TABLE to perform above query
SET SESSION sql_mode = '';
DROP TABLE IF EXISTS PercentageofPeopleVaccinated;
CREATE TEMPORARY TABLE PercentageofPeopleVaccinated 
(
continent varchar(255),
location varchar(255),
date datetime,
population int,
new_vaccination int,
RollingPeopleVaccinated int
);

INSERT IGNORE INTO PercentageofPeopleVaccinated(continent, location, date, population, new_vaccination, RollingPeopleVaccinated)
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CAST(new_vaccinations AS DECIMAL)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date;
-- WHERE cd.continent > '';

SELECT *, (RollingPeopleVaccinated/Population)*100 AS PercentageofPeopleVaccinated
FROM PercentageofPeopleVaccinated
ORDER BY PercentageofPeopleVaccinated DESC;


-- Creating View to store data for visualization
DROP VIEW IF EXISTS PercentageofPeopleVaccinated;
CREATE VIEW PercentageofPeopleVaccinated AS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CAST(new_vaccinations AS DECIMAL)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent > ''; 

