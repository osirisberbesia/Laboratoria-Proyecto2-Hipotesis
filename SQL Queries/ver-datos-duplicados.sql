--- para ver los datos de todos los duplicados

WITH duplicates AS (
  SELECT track_name, artist_s_name
  FROM `laboratoria2.datos_hipotesis.track_in_spotify`
  GROUP BY track_name, artist_s_name
  HAVING COUNT(*) > 1
  order by track_name
)
SELECT 
  t.track_id,
  t.track_name,
  t.artist_s_name,
  CAST(CONCAT(t.released_year, '-', t.released_month, '-', t.released_day) AS DATE) AS Fecha_Released,
  t.streams,
  t.in_spotify_playlists,
  tt.in_apple_playlists,
  tt.in_deezer_playlists,
  ti.bpm,
  ti.key,
  ti.mode,
  ti.`danceability_%`,
  ti.`valence_%`,
  ti.`energy_%`,
  ti.`acousticness_%`,
  ti.`instrumentalness_%`,
  ti.`liveness_%`,
  ti.`speechiness_%`
FROM 
  `laboratoria2.datos_hipotesis.track_in_spotify` t
JOIN 
  duplicates d
ON 
  t.track_name = d.track_name AND t.artist_s_name = d.artist_s_name
JOIN 
  `laboratoria2.datos_hipotesis.track_technical_info` ti
ON 
  t.track_id = ti.track_id
JOIN 
`laboratoria2.datos_hipotesis.track_in_competition` tt
ON
tt.track_id = t.track_id;