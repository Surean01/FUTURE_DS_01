-- Table: public.covid_impact_table

-- DROP TABLE IF EXISTS public.covid_impact_table;

CREATE TABLE IF NOT EXISTS public.covid_impact_table
(
    increased_work_hours integer,
    work_from_home integer,
    hours_worked_per_day double precision,
    meetings_per_day double precision,
    productivity_change integer,
    stress_level character varying COLLATE pg_catalog."default",
    health_issue integer,
    job_security integer,
    childcare_responsibilities integer,
    commuting_changes integer,
    technology_adaptation integer,
    salary_changes integer,
    team_collaboration_challenges integer,
    sector character varying COLLATE pg_catalog."default",
    affected_by_covid integer
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.covid_impact_table
    OWNER to postgres;

--confirm table data
select * from covid_impact_table
limit 20;

--Check for missing values
select 
 count (*) filter (where increased_work_hours is null) as missing_workhours,
 count (*) filter (where work_from_home is null) as missing_work ,
 count (*) filter(where stress_level is null) as missing_stresslevel,
 count (*) filter (where sector is null) as missing_sector
 from covid_impact_table;


 --exploratory data analysis
 --summary statistics
 select
   avg(hours_worked_per_day) as avg_hoursworked_perday,
   avg(meetings_per_day) as avg_meeting_perday,
   avg(productivity_change) as avg_product_change,
   sum(hours_worked_per_day) as sum_workhours_day,
   sum(meetings_per_day) as sum_meetings,
   max(meetings_per_day) as max_meetings,
   min(meetings_per_day) as min_meetings,
   max(hours_worked_per_day)as max_hrsaday,
   min(hours_worked_per_day)as min_hoursaday
 from covid_impact_table;  


 --table distribution
 --stress distribution
 select stress_level,
 count(*)as count1,
 count(*) * 100.0/(select count(*)from covid_impact_table)as percentage_distribution
 from covid_impact_table
 group by stress_level
 order by count1 desc;
--sector distribution
 select sector,count(*) as count2,
 count(*)* 100.00/(select count(*)from covid_impact_table)as percentage_sector
 from covid_impact_table
 group by sector
 order by count2 desc;
 
--relation between  stress level and sector
select sector, stress_level,count(*)as numbers
  from covid_impact_table
  group by sector,stress_level
  order by numbers desc;
  
--correlation between increased work hours and productivity change
select
  corr(increased_work_hours,productivity_change)
from covid_impact_table;

--relation between stress level and health issue
select 
  stress_level,health_issue, count(*)as count4
  from covid_impact_table
  group by stress_level,health_issue
  order by count4 desc;

--stress level and sector relationship
select 
  stress_level,sector,count(*) as sector_stress
  from covid_impact_table
  where lower(stress_level)='high'
  group by stress_level,sector
  order by stress_level
  limit 2;
  



--average productivity change working from home and those who are not
select
 work_from_home, avg(productivity_change)as avg_productivity_on_home
 from covid_impact_table
 group by work_from_home;


 -


 --group analysis
   --variance between average number of hours worked per day and stress levels.
   select
    stress_level, avg(hours_worked_per_day) as stressed_hours
	from covid_impact_table
	group by stress_level;

 --	health issue among productivity levels
 select productivity_change,health_issue,count(*)as health_productivity
	from covid_impact_table
	where health_issue=1
	group by productivity_change,health_issue;

	
--advanced analysis
select 
 percentile_cont(0.5) within group(order by meetings_per_day)as median_meeting
 from covid_impact_table;
 
   
--variance in hours worked by stress levels
select
  stress_level,
  var_pop(hours_worked_per_day) as variance_stress_hours
  from covid_impact_table
  group by stress_level
  order by stress_level desc;

 

 

