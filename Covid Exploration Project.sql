-- The goal of this project is to explore the Covid dataset, write sql queries to generate specific data and get insights from the dataset

-- I start by first importing the coviddeath and Covidvaccination csv dataset from excel and then I visualize it to ensure successful import to mysql

-- checking to ensure data was imported successfully
select *
from `CovidVaccinations(1)` limit 5;

select *
from `CovidDeaths(1)` limit 10;


select *
from PortfolioProject.`CovidDeaths(1)`
where continent is not null
order by 3, 4;

--
select location, date, total_cases, new_cases, total_deaths, population
from `CovidDeaths(1)
where continent is not null`;


-- Looking at the Total Cases vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 as DeathPercentage
from `CovidDeaths(1)`
where location like '%states%'
  and continent is not null
order by 1, 2;

#
The above query shows the likelhood of dying if you contract covid in the United States (This tells us the probability of someone dying from the covid disease)


-- Looking at the Total Cases vs  Population

select location, date, total_cases, population, (total_cases / population) * 100 as PercentageOfInfected
from `CovidDeaths(1)`
where location like '%states%'
  and continent is not null
order by 1, 2;

# The above query shows the percentage of population that has covid in the United states.


-- Looking at Countries with the highest infection rate compared to the population

select location,
       population,
       max(total_cases)                               as HighestInfectionCount,
       max(total_cases / `CovidDeaths(1)`.population) as PercentPopulationInfected
from `CovidDeaths(1)`
where continent is not null
group by 1, 2
order by PercentPopulationInfected desc;


-- Countries with Highest Death Count per Population

select location,
       population,
       max(total_deaths)                                                as TotalDeathCount,
       max(`CovidDeaths(1)`.total_deaths / `CovidDeaths(1)`.population) as PercentDeathCount
from `CovidDeaths(1)`
where continent is not null
group by 1, 2
order by TotalDeathCount desc;



-- Breaking things down by continent

-- Showing continent with the highest death count per population

select continent,
       max(total_deaths)                                                as TotalDeathCount,
       max(`CovidDeaths(1)`.total_deaths / `CovidDeaths(1)`.population) as PercentDeathCount
from `CovidDeaths(1)`
where continent is not null
group by 1
order by TotalDeathCount desc;

select location,
       max(total_deaths)                                                as TotalDeathCount,
       max(`CovidDeaths(1)`.total_deaths / `CovidDeaths(1)`.population) as PercentDeathCount
from `CovidDeaths(1)`
where continent is null
group by 1
order by TotalDeathCount desc;


-- Global Numbers

select sum(new_cases)                           as Total_cases,
       sum(new_deaths)                          as Total_deaths,
       (sum(new_deaths) / sum(new_cases) * 100) as DeathPercentage
from `CovidDeaths(1)`
where continent is not null
order by 1, 2;

-------------- joining the two tables (covid vaccination & covid death)
select *
from `CovidDeaths(1)` as dea
         join CovidVaccinations as vac on dea.location = vac.location
    and dea.date = vac.date;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has received at least one Covid Vaccine

select dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       sum(vac.new_vaccinations)
           over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from `CovidDeaths(1)` as dea
         join CovidVaccinations as vac on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2, 3;


---  Using CTE to perform Calculation on Partition By in previous query
with PopsVac (Continent, location, date, Population, New_Vaccinations, RollingPeopleVaccinated)
         as (select dea.continent,
                    dea.location,
                    dea.date,
                    dea.population,
                    vac.new_vaccinations,
                    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
             from `CovidDeaths(1)` as dea
                      join CovidVaccinations as vac on dea.location = vac.location
                 and dea.date = vac.date
             where dea.continent is not null
-- order by 2,3;
    )
select *, (RollingPeopleVaccinated / Population) as PercentageofPopulationVaccinated
from PopsVac;


-- Using Temp Table perform Calculation on Partition By in previous query

Drop table if exists # PercentageofPopulationVaccinated
Create table #PercentageofPopulationVaccinated
(
    Continent               nvarchar(255),
    location                nvarchar(255),
    Date                    datetime,
    Population              numeric,
    New_vaccinations        numeric,
    RollingPeopleVaccinated numeric
) insert into #PercentageofPopulationVaccinated
select dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       sum(vac.new_vaccinations)
           over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from `CovidDeaths(1)` as dea
         join CovidVaccinations as vac on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
-- order by 2, 3;

select *, (RollingPeopleVaccinated / Population) as PercentageofPopulationVaccinated
from #PercentageofPopulationVaccinated;



-- Creating Views to store data for later visualizations

create view PercentageofPopulationVaccinated as
select dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       sum(vac.new_vaccinations)
           over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from `CovidDeaths(1)` as dea
         join CovidVaccinations as vac on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
-- order by 2, 3;


