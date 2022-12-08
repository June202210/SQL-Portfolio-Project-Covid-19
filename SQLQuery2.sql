use portfolioproject;
select *
from dbo.coviddeaths;

select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from dbo.coviddeaths
where location='Canada'
order by 1,2;

--looking at the country with the highest infection rate

select location,population, total_cases,(total_cases/population)*100 as infection_rate 
from dbo.coviddeaths
group by location,population,total_cases
order by infection_rate desc;

--showing the highest deathcount
select location,max(cast(total_deaths as int)) as total_death_count
from dbo.coviddeaths
where continent is not null
group by location
order by total_death_count desc;

--Let's break things down into continent.
select continent,max(cast(total_deaths as int)) as total_death_count
from dbo.coviddeaths
where continent is not null
group by continent
order by total_death_count desc;

--global numbers
select date,sum(new_cases)as total_cases,sum(cast(new_deaths as int))as total_deaths,sum(cast(new_deaths as int))/sum (new_cases)*100 as DeathPercentage
from dbo.coviddeaths
where continent is not null
group by date
order by 1,2;

--global numbers in total

select sum(new_cases)as total_cases,sum(cast(new_deaths as int))as total_deaths,sum(cast(new_deaths as int))/sum (new_cases)*100 as DeathPercentage
from dbo.coviddeaths
where continent is not null
order by 1,2;

--looking at total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date)as current_sum
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

--CTE
with PopvsVac(continent,location, date, population, new_vaccinations,current_sum)
as(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int))over(partition by dea.location order by dea.location,dea.date)as current_sum
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null and new_vaccinations is not null
)

select *,(current_sum/population)*100
from PopvsVac
go

CREATE VIEW Vac2 as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int))over(partition by dea.location order by dea.location,dea.date)as current_sum
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
go

drop view Vac2;

SELECT 
OBJECT_SCHEMA_NAME(o.object_id) schema_name,o.name
FROM
sys.objects as o
WHERE
o.type = 'V';
