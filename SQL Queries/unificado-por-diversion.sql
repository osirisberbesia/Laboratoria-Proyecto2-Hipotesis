SELECT 
  a.* EXCEPT(track_name,
    artist_s_name,
    released_day,
    released_month,
    released_year),
  REGEXP_REPLACE(a.track_name, r'[^a-zA-Z0-9\s\-:,?\'()&]', '') AS track_name,
  REGEXP_REPLACE(a.artist_s_name, r'[^a-zA-Z0-9\s\-:,?\'()&]', '') AS `artist+s`,
  CAST(CONCAT(a.released_year, '-', a.released_month, '-', a.released_day) AS DATE) AS released_date,

  c.* EXCEPT (track_id),
  (c.in_apple_playlists+a.in_spotify_playlists+c.in_deezer_playlists) AS total_playlist,
  
  t.* EXCEPT(track_id),
FROM
  `laboratoria2.datos_hipotesis.track_in_spotify` a
INNER JOIN
  `laboratoria2.datos_hipotesis.track_in_competition` c
ON
  a.track_id = c.track_id
JOIN
  `laboratoria2.datos_hipotesis.track_technical_info` t
ON
  t.track_id = a.track_id
WHERE
  a.streams NOT LIKE "%B%"
  AND a.track_id != "5080031"
  AND a.track_id !="7173596";