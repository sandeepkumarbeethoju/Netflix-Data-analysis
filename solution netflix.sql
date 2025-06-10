--netflix project
drop table if exists netflix;
create table netflix
(
show_id varchar(6),
type varchar(10),
title varchar(150),
director varchar(208),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
 duration varchar(15),
listed_in varchar(100),
description varchar(250)
);
select * from netflix;
----15 business problems
--1.count the number of movies vs tv shows
select type,count(*)as total_content
from netflix
group by type;
---2.find the most common rating for movies and tv shows
select 
type,rating
from
(select type,rating,count(*),
rank()over(partition by type order by count(*) desc)as rank
from netflix
group by 1,2)as table1
where rank=1;

---3.list allmovie released in a specific year(e.g-2020)
select *
from netflix
where type='Movie'and
 release_year=2020;
 
---4.find the top 5 countries with the most content on netflix
select 
unnest(string_to_array(country::text,','))as new_country,count(show_id) AS total_content
from netflix
group by 1
order by 2 desc
limit 5;

--- 5.identify the longest movie.
select *
from netflix
where type='Movie'
and duration=(select max(duration) from netflix)
limit 1;

---6.find content added in the last 5 years.
select *
from netflix
where
 to_date(date_added,'month dd,yyyy')>=current_date - interval '5 years';

---7.find all the movies/tv shows  by director "rajiv chilka".
select *
from netflix
where director like'%Rajiv Chilaka%';

--8.list all tv shows with more than 5 season.

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND split_part(duration, ' ', 1)::int > 5;

--9.count the numbers of content items in esch genre
select
unnest(string_to_array(listed_in::text,','))as genre,
count(show_id) as totalcontent
from netflix
group by 1;

---10.find each year and the avg number of content release by india  on netflix.
---return top 5 year with highest avg content realese.
SELECT
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
  COUNT(*) AS total_content,
  ROUND(
    COUNT(*)::NUMERIC / 
    (SELECT COUNT(*) FROM netflix WHERE country = 'India')::NUMERIC * 100, 
    2
  ) AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

--11.list all movies that are documentries.
select *
from netflix
where listed_in ilike '%documentaries%'

--12.find all the content without a director..
select *
from netflix
where director is null

--13.find how many movie actor 'salman khan'appeared in last 10 years.
select *
from netflix
where 
casts ilike '%Salman Khan%'and
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

---14.find the top 10 actors who have appeared in the highest number of movies produce 9in india
select
unnest(string_to_array(casts::text,','))as actors,
count(*)as totalcount
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10
---15.catagorise the content based on the presence of the keyword "kill"and "violance"in the description field.lebel contaant containing these keyword as 
--"bad"and all other content as "good".count how many contants fall in each category
with new_table
as
(
select *,
case
when description ilike '%kill%'or
description ilike '%violance%' then 'Bad_content'
else 'Good_content'
end category
from netflix)
select 
category,
count(*) as otal_content
from new_table
group by 1;












































