--select * 

--from PortifolioProject.dbo.CovidDeaths$
--order by 3 , 4
--;


--select * 

--from PortifolioProject.dbo.CovidVaccinations$
--order by 3 , 4
--;

--Select location,date,total_cases,new_cases,total_deaths,population

--from PortifolioProject..CovidDeaths$


--Looking at total vs total deaths
-- likely of dying if you contract covid in your country

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100


from PortifolioProject..CovidDeaths$
where location like '%somalia%'

order by 1,2;

--looking at total cases vs population
-- shows what percentage of population got covid 
Select location,date,population,total_cases,(total_cases/population)*100 as percentageofpopulationwithcovid

from PortifolioProject..CovidDeaths$
where location like '%somalia%'

order by 1,2;
-- looking at the countries with highest infection rate
Select location,population,max(total_cases)as Hightestinfectcountry,max((total_cases/population)*100) as percentageofpopulationwithcovid

from PortifolioProject..CovidDeaths$
--where location like '%somalia%'
group by location,population
order by percentageofpopulationwithcovid desc
;
---countries with highest death count per population 
Select location,max(cast(total_deaths as int)) as Totaldeathcount

from PortifolioProject..CovidDeaths$
--where location like '%somalia%'
where continent is not null
group by location
order by Totaldeathcount desc
;

--lets break things down by continent
Select continent,max(cast(total_deaths as int)) as Totaldeathcount

from PortifolioProject..CovidDeaths$
--where location like '%somalia%'
where continent is not null
group by continent
order by Totaldeathcount desc
;

--Showing continents with highest death count per population
Select continent,max(cast(total_deaths as int)) as Totaldeathcount

from PortifolioProject..CovidDeaths$
--where location like '%somalia%'
where continent is not null
group by continent
order by Totaldeathcount desc

--global numbers

Select sum(new_cases) as Totalcases,sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as deathpercentage

from PortifolioProject..CovidDeaths$
--where location like '%somalia%'
where continent is not null

order by deathpercentage desc
;

--looking at tolalpopulation vs vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as  rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from PortifolioProject.dbo.CovidDeaths$ dea
join PortifolioProject.dbo.CovidDeaths$ vac

on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3
;

--use CTE
with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated) as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as  rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from PortifolioProject.dbo.CovidDeaths$ dea
join PortifolioProject.dbo.CovidDeaths$ vac

on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*,(rollingpeoplevaccinated/population)*100

from popvsvac;

--Temp table
drop table if exists #populationvaccinated
create table #populationvaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric )

insert into #populationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as  rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from PortifolioProject.dbo.CovidDeaths$ dea
join PortifolioProject.dbo.CovidDeaths$ vac

on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3
select*,(rollingpeoplevaccinated/population)*100

from #populationvaccinated ;


--create views to store data for later visualisations

create view populationvaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as  rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from PortifolioProject.dbo.CovidDeaths$ dea
join PortifolioProject.dbo.CovidDeaths$ vac

on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

create view rollingpeoplevaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as  rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from PortifolioProject.dbo.CovidDeaths$ dea
join PortifolioProject.dbo.CovidDeaths$ vac

on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
;

create view highestinfectionrate as
Select location,population,max(total_cases)as Hightestinfectcountry,max((total_cases/population)*100) as percentageofpopulationwithcovid

from PortifolioProject..CovidDeaths$
--where location like '%somalia%'
group by location,population
--order by percentageofpopulationwithcovid desc
;






