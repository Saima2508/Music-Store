use music;

-- 1. List all artists for each record label sorted by artist name. 
SELECT 
    a.name AS artist_name, r.name AS record_label_name
FROM
    artist a
        JOIN
    record_label r ON a.record_label_id = r.id
ORDER BY a.name;

-- 2. Which record labels have no artists.
SELECT 
    r.id
FROM
    record_label r
        LEFT JOIN
    artist a ON r.id = a.record_label_id
WHERE
    a.name IS NULL;

-- 3. List the number of songs per artist in descending order
SELECT 
    a.id AS artist_id,
    a.name AS artist_name,
    COUNT(s.id) AS num_of_songs
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
GROUP BY a.id
ORDER BY num_of_songs DESC;

-- 4. Which artist or artists have recorded the most number of songs?
SELECT 
    a.id AS artist_id,
    a.name AS artist_name,
    COUNT(s.id) AS num_of_songs
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
GROUP BY a.id
ORDER BY num_of_songs DESC
LIMIT 1;

-- 5. Which artist or artists have recorded the least number of songs?
SELECT 
    a.name, COUNT(s.id) AS count
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
GROUP BY a.name
HAVING count = (SELECT 
        MIN(num_of_songs)
    FROM
        (SELECT 
            a.id AS artist_id,
                a.name AS artist_name,
                COUNT(s.id) AS num_of_songs
        FROM
            artist a
        JOIN album al ON a.id = al.artist_id
        JOIN song s ON al.id = s.album_id
        GROUP BY a.id) t1);

-- 6. How many artists have recorded the least number of songs?
SELECT 
    COUNT(*)
FROM
    (SELECT 
        a.name, COUNT(s.id) AS count
    FROM
        artist a
    JOIN album al ON a.id = al.artist_id
    JOIN song s ON al.id = s.album_id
    GROUP BY a.name
    HAVING count = (SELECT 
            MIN(num_of_songs)
        FROM
            (SELECT 
            a.id AS artist_id,
                a.name AS artist_name,
                COUNT(s.id) AS num_of_songs
        FROM
            artist a
        JOIN album al ON a.id = al.artist_id
        JOIN song s ON al.id = s.album_id
        GROUP BY a.id) t1)) t2;

-- 7. which artists have recorded songs longer than 5 minutes, and how many songs was that?
SELECT 
    a.name AS artist_name, COUNT(s.id) AS num_of_songs
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
WHERE
    s.duration > 5
GROUP BY a.name;

-- 8. for each artist and album how many songs were less than 5 minutes long?
SELECT 
    a.id AS artist_id, al.id AS album_id, COUNT(s.id)
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
WHERE
    s.duration < 5
GROUP BY a.id , al.id;

-- 9. in which year or years were the most songs recorded?
SELECT 
    al.year, COUNT(s.id) AS count
FROM
    album al
        JOIN
    song s ON al.id = s.album_id
GROUP BY al.year
HAVING count = (SELECT 
        MAX(count_of_songs)
    FROM
        (SELECT 
            al.year, COUNT(s.id) AS count_of_songs
        FROM
            album al
        JOIN song s ON al.id = s.album_id
        GROUP BY al.id) t1);

 -- 10. list the artist, song and year of the top 5 longest recorded songs.
SELECT 
    s.name AS song_name,
    s.duration,
    a.name AS artist_name,
    al.name AS album_name
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
ORDER BY s.duration DESC
LIMIT 5;

-- 11. Number of albums recorded for each year
SELECT 
    year, COUNT(id) AS num_of_album
FROM
    album
GROUP BY year;

-- 12. What is the max number of recorded albums across all the years?
SELECT 
    MAX(num_of_album)
FROM
    (SELECT 
        year, COUNT(id) AS num_of_album
    FROM
        album
    GROUP BY year
    ORDER BY num_of_album DESC) t1;

-- 13. In which year (or years) were the most (max) number of albums recorded, and how many were recorded?
SELECT 
    year, COUNT(id)
FROM
    album
GROUP BY year
HAVING COUNT(id) = (SELECT 
        MAX(num_of_album)
    FROM
        (SELECT 
            year, COUNT(id) AS num_of_album
        FROM
            album
        GROUP BY year
        ORDER BY num_of_album DESC) t1);
        
-- 14. total duration of all songs recorded by each artist in descending order
SELECT 
    a.id AS arist_id, SUM(s.duration) AS total_duration
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
GROUP BY a.id
ORDER BY total_duration DESC;

-- 15. for which artist and album are there no songs less than 5 minutes long?
SELECT 
    a.name AS artist_name, al.name AS album_name, s.duration
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
WHERE
    s.duration > 5;
    
-- 16. Display a table of all artists, albums, songs and song duration all ordered in ascending order by artist, album and song  
SELECT 
    a.name AS artist_name,
    al.name AS album_name,
    s.name AS song_name,
    s.duration
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
ORDER BY artist_name ASC , album_name ASC , song_name ASC;

-- 17. List the top 3 artists with the longest average song duration, in descending with longest average first.
SELECT 
    a.id AS artist_id,
    a.name,
    AVG(s.duration) AS avg_song_duration
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
        JOIN
    song s ON al.id = s.album_id
GROUP BY a.id
ORDER BY avg_song_duration DESC
LIMIT 3;

-- 18. Total album length for all songs on the Beatles Sgt. Pepper's album - in minutes and seconds.
SELECT 
    al.name AS Album_Name,
    FLOOR(SUM(s.duration)) AS Minutes,
    ROUND(MOD(SUM(s.duration), 1) * 60) AS Seconds
FROM
    album al
        JOIN
    song s ON s.album_id = al.id
WHERE
    al.name LIKE 'Sgt. Pepper%'
GROUP BY al.name
;   

-- 19. Which artists did not release an album during the decades of the 1980's and the 1990's?
SELECT 
    a.id, a.name
FROM
    artist a
WHERE
    a.id NOT IN (SELECT 
            a.id
        FROM
            artist a
                JOIN
            album al ON a.id = al.artist_id
        WHERE
            year BETWEEN 1980 AND 1990
        GROUP BY a.id , al.id , al.year);
        
-- 20. Which artists did release an album during the decades of the 1980's and the 1990's?
SELECT 
    a.id, a.name, al.year
FROM
    artist a
        JOIN
    album al ON a.id = al.artist_id
WHERE
    year BETWEEN 1980 AND 1990
GROUP BY a.id , al.year;