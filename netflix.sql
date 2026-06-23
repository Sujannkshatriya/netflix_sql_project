-- netflix project
drop table if exists netflix;
create table netflix(show_id varchar(10),
type varchar(20),
title varchar(200),
director varchar(250),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(15),
listed_in varchar(300),
description varchar(300)
);

select * from netflix ;

select count(*) as total_content
from netflix;

select distinct type from netflix;

--1. count the number of movies vs tv shows?
select 
type,
count(*) as total
from netflix
group by type;

--2. find the most common rating for movies and tv shows?

select 
type,
rating,
count(*),
rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2
order by 1,3 desc;

--3. list all the movie released in specific year 2020?

select * from netflix
where 
    type= 'Movie'
	and
	release_year = 2020

--4.find the top 5 countries with the most content on netflix

select 
country,
count(show_id) as content
from netflix
group by 1;

--5. identify the longest movie?

select * from netflix
where 
type = 'Movie'
and
duration = (select max(duration) from netflix)

--6. find the content added in last 5 years?

select *
from netflix
where 
to_date(date_added,'month dd,yyyy' )>= current_date - interval '5 years'

select current_date - interval '5 years'

--7. find all movie/tv shows directed by 'rajiv chilaka'

select * from netflix
where director like'%Rajiv Chilaka%'

--8.list all tv show with more than 5 seasons

select
*,
split_part(duration, ' ',1 ) as sessions 
from netflix
where 
type = 'TV Show'

--9. count the number of content items in each genre

select 
unnest(string_to_array(listed_in, ',')) as genre,
count(show_id) as total_content
from netflix
group by 1

--10. find each year and the avreage numbers of content realesed by india on netflix, return top 5 year with highest average content realesed

select
extract(year from to_date(date_added, 'Month dd,yyyy')) as year,
count(*),
count(*)::numeric/(select count(*) from netflix where country='India') * 100 as avg_content_per_year
from netflix
where country ='India'
group by 1


