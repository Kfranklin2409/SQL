-- Aggregate functions queries of Khan Academy Planetary Data source.  

SELECT 
    body, MAX(density)
FROM
    solar_system_objects;

-- Select the least dense planet
SELECT 
    body, MIN(density)
FROM
    solar_system_objects;

-- Select the masses of each planet and group from greatest to least 
SELECT 
    body, mass
FROM
    solar_system_objects
GROUP BY - 1 * mass;

-- Select the mean radius and the relative percent of planets that are 50% of the Earth's radius and above
SELECT 
    body,
    mean_radius,
    ROUND(mean_radius_rel * 100) AS relative_percent
FROM
    solar_system_objects
GROUP BY - 1 * ROUND(mean_radius_rel * 100)
HAVING ROUND(mean_radius_rel * 100) >= 50;

-- Select the planets that have a mass greater than 150 and volume less than 1000 and grouping by a radius of greater than 4000 (Only 1 planet met the criteria)
SELECT 
    body, mass, volume
FROM
    solar_system_objects
WHERE
    mass > 150 AND volume < 1000
GROUP BY mass
HAVING mean_radius > 4000;

-- Select the planets that have a mass greater than 150 and volume greater than 1000 and grouping by a radius of greater than 4000 (Six planets met this criteria)
SELECT 
    body, mass, volume
FROM
    solar_system_objects
WHERE
    mass > 150 AND volume > 1000
GROUP BY mass
HAVING mean_radius > 4000;
    
# In this SQL code, I'm querying a database that holds Nexflix data to answer questions about the data. 

-- Example query (PostgreSQL)

/*Selecting all the data from one of the two tables in the database*/
SELECT * 
FROM "CharlotteChaze/BreakIntoTech"."netflix_titles_info";

 /*Joining specific columns from both tables with a limit of 10*/
SELECT "release_year", "title", "cast", "director" FROM "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
    LEFT JOIN "CharlotteChaze/BreakIntoTech"."netflix_people"
		ON "CharlotteChaze/BreakIntoTech"."netflix_titles_info"."show_id"="CharlotteChaze/BreakIntoTech"."netflix_people"."show_id"
    LIMIT 10;

/*Total number of movies (not TV Shows) in the database*/
SELECT count(*) 
FROM "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
Where type= 'Movie'; 

/*Selecting when the latest batch of data was entering into the database*/
SELECT MAX(date(date_added)) 
FROM "CharlotteChaze/BreakIntoTech"."netflix_titles_info"; 

/*Titles of the TV Shows and movies in alphabetical order in the database*/
SELECT title 
FROM "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
ORDER BY title asc; 

/*Joining the tables together to find the director of the movie Bright Star*/
SELECT director 
FROM "CharlotteChaze/BreakIntoTech"."netflix_people"
    LEFT JOIN "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
		ON "CharlotteChaze/BreakIntoTech"."netflix_titles_info"."show_id"="CharlotteChaze/BreakIntoTech"."netflix_people"."show_id"
WHERE title='Bright Star';

/*Selecting the two oldest movies in the database*/
SELECT title,
	release_year
FROM "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
WHERE type='Movie'
ORDER BY release_year
LIMIT 2;

