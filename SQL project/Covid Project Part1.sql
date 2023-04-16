select*from Project..CovidDeaths where continent is not null order by 3,4 

select*from Project..CovidVaccinations where continent is not null order by 3,4


select Location,date,total_cases,new_cases,total_deaths,population from Project..CovidDeaths where continent is not null order by 1,2

----Total cases vs deaths

select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage from Project..CovidDeaths where continent is not null and  location like'%india%' order by 1,2

----Total cases vs population
----Shows what percentage of population infected with Covid

select Location,date,total_cases,population,(total_cases/population)*100 as PercentPopulationInfected from Project..CovidDeaths where location like'%india%' order by 1,2

----countries with highest infection rate

select Location,population,MAX(total_cases)AS HighestInfectionRate,max((total_cases/population)*100) as PercentPopulationInfected from Project..CovidDeaths group by location,population order by PercentPopulationInfected desc

--Showing the countries with death per population

select Location,MAX(cast(total_deaths as int))AS TotalDeathRate from Project..CovidDeaths where continent is not null group by location order by TotalDeathRate desc

--Looking at continents with highest death rate 

select continent,MAX(cast(total_deaths as int))AS TotalDeathRate from Project..CovidDeaths where continent is not null group by continent order by TotalDeathRate desc

--Global numbers

select date,SUM(new_cases)as TotalCases,SUM(cast(new_deaths as int))as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage from Project..CovidDeaths where continent is not null group by date order by 1,2

create view GlobalNumbers as select date,SUM(new_cases)as TotalCases,SUM(cast(new_deaths as int))as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage from Project..CovidDeaths where continent is not null group by date 

select*from GlobalNumbers

 --Total Population vs Vaccinations
  --use CTE

 With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Project..CovidDeaths cd
Join Project..CovidVaccinations cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

 


--temp table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Project..CovidDeaths cd
Join Project..CovidVaccinations cv
	On cd.location = cv.location
	and cd.date = cv.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--create view to store data for visualization


create view PercentPopulationVaccinated as
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Project..CovidDeaths cd
Join Project..CovidVaccinations cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 

Create View PercentPopulationvaccinatedd as
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Project..CovidDeaths cd
Join Project..CovidVaccinations cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 

select*from PercentPopulationvaccinated