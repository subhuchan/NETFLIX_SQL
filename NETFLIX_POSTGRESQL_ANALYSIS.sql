--NETFLIX SQL PROJECT

-- CREATING THE TABLE 
CREATE TABLE netflix
(
show_id VARCHAR(7),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(210),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);

-- THE WHOLE DATASET
SELECT * FROM netflix;

--1. Count the number of Movies and TV Shows.
SELECT 
type, count(*) AS number_of_content
FROM netflix
GROUP BY type;

--2. Find the most common rating for movies and TV shows.
SELECT
type, rating
FROM
(
SELECT 
type , rating , COUNT(*) AS frequency,
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
Group By 2,1 
ORDER BY 3 DESC
) 
WHERE ranking=1;

--3. List all movies released in a specific year(e.g 2020).
SELECT *
FROM netflix
WHERE 
release_year=2020 AND type= 'Movie';

--4. Find the top 5 countries with the most content on Netflix.
SELECT 
UNNEST(STRING_TO_ARRAY(country, ',')) AS individual_country ,
COUNT(show_id) AS frequency
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5. Identify the longest movie duration.
SELECT * FROM 
 (SELECT DISTINCT title AS movie,
  split_part(duration,' ',1):: numeric AS duration 
  FROM netflix
  WHERE type ='Movie') AS subquery
WHERE duration = (SELECT MAX(split_part(duration,' ',1):: numeric ) 
FROM netflix)

--6. Find content added in the last 5 years.
SELECT*
FROM netflix
WHERE 
CURRENT_DATE<=TO_DATE(date_added,'MONTH DD, YYYY') + INTERVAL '5 years';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'.
SELECT * 
FROM netflix 
WHERE 
director ILIKE '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons.
SELECT *
FROM netflix 
WHERE 
type='TV Show'
AND 
SPLIT_PART(duration,' ',1)::numeric> 5 ;

--9. Count the number of contents in each genre.
SELECT 
UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genres , COUNT(*)
FROM netflix
GROUP BY 1;

--10. Find the number of contents released for distinct years in India.
SELECT DISTINCT release_year, COUNT(*)
FROM netflix 
WHERE country LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC;

-- 11. Find the number of contents released in Netflix platform for distinct years in India.
SELECT 
EXTRACT(YEAR FROM TO_DATE(date_added,'MONTH DD, YYYY')) AS years,
COUNT(*)
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1;

--12. List all movies that are documentaries.
SELECT *
FROM netflix
WHERE type='Movie'
AND 
listed_in ILIKE '%Documentaries%';

--13. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL;

--14. Find how many movies actor 'salman khan' appeared in last 15 years.
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND 
release_year >= Extract(year from current_date)-15
;

--15. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT UNNEST(STRING_TO_ARRAY(casts,',')), COUNT(*)
FROM netflix 
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
