# For this project, I downloaded Spotify data from Kaggle.
# Then I created a table to insert Spotify data into.
# Finally, I performed analytics on the data using SQL. 

CREATE TABLE BIT_DB.Spotifydata (
id integer PRIMARY KEY,
artist_name varchar NOT NULL,
track_name varchar NOT NULL,
track_id varchar NOT NULL,
popularity integer NOT NULL,
danceability decimal(4,3) NOT NULL,
energy decimal(4,3) NOT NULL,
key integer NOT NULL,
loudness decimal(5,3) NOT NULL,
mode integer NOT NULL,
speechiness decimal(5,4) NOT NULL,
acousticness decimal(6,5) NOT NULL,
instrumentalness text NOT NULL,
liveness decimal(5,4) NOT NULL,
valence decimal(4,3) NOT NULL,
tempo decimal(6,3) NOT NULL,
duration_ms integer NOT NULL,
time_signature integer NOT NULL 
)

/*Select the top 10 most popular songs*/
SELECT 
    artist_name, track_name, popularity
FROM
    BIT_DB.Spotifydata
ORDER BY POPULARITY DESC
LIMIT 10;

/*Select the most danceable of the most popular songs*/
SELECT 
    artist_name, track_name, popularity, danceability
FROM
    BIT_DB.Spotifydata
WHERE
    popularity >= 90
ORDER BY danceability DESC
;

/*Select the average "danceability" of the top 10 songs*/
SELECT 
    AVG(danceability)
FROM
    BIT_DB.Spotifydata
WHERE
    popularity IN (SELECT 
            popularity
        FROM
            BIT_DB.Spotifydata
        ORDER BY popularity DESC
        LIMIT 10)
;

/*Select the artist with the longest track*/
SELECT 
    artist_name, track_name, MAX(duration_ms)
FROM
    BIT_DB.Spotifydata;

/*Select the average energy of the bottom 10 songs by popularity*/
SELECT 
    AVG(energy)
FROM
    BIT_DB.Spotifydata
WHERE
    popularity IN (SELECT 
            popularity
        FROM
            BIT_DB.Spotifydata
        ORDER BY popularity ASC
        LIMIT 10);

/*Select the average energy of the top 10 songs by popularity*/
SELECT 
    AVG(energy)
FROM
    BIT_DB.Spotifydata
WHERE
    popularity IN (SELECT 
            popularity
        FROM
            BIT_DB.Spotifydata
        ORDER BY popularity DESC
        LIMIT 10);

/*Select the song with the highest tempo and danceability*/
SELECT 
    artist_name, track_name, tempo, danceability
FROM
    BIT_DB.Spotifydata
WHERE
    tempo >= 170 AND danceability > 0.6
ORDER BY tempo;