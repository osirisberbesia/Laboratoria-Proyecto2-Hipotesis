WITH cuartiles AS (
  SELECT 
    track_id,streams,  `danceability_%`,`valence_%`,`energy_%`,`acousticness_%`,`instrumentalness_%`,`liveness_%`,
  `speechiness_%`,
    NTILE(4) OVER (ORDER BY streams) AS cuartiles_streams,
  NTILE(4) OVER (ORDER BY `danceability_%`) AS cuartiles_dance,
  NTILE(4) OVER (ORDER BY `valence_%`) AS cuartiles_valence,
  NTILE(4) OVER (ORDER BY `energy_%`) AS cuartiles_energy,
  NTILE(4) OVER (ORDER BY `acousticness_%`) AS cuartiles_acousticness,
  NTILE(4) OVER (ORDER BY `instrumentalness_%`) AS cuartiles_instrumental,
  NTILE(4) OVER (ORDER BY `liveness_%`) AS cuartiles_live,
  NTILE(4) OVER (ORDER BY `speechiness_%`) AS cuartiles_speech
  FROM 
    `laboratoria2.datos_hipotesis.view_unificado_1query`

)

SELECT 
  distinct a.track_id,
  a.track_name,
  a.`artist+s` AS artist_s_name,
  a.artist_count,
  b.categoria_artista,
  b.genero_artista,
  IF(a.artist_count = 1, "Solo", "Feat") AS modo_cancion,
  a.released_date,
  a.in_spotify_playlists,
  a.in_spotify_charts,
  a.in_apple_playlists,
  a.in_apple_charts,
  a.in_deezer_playlists,
  a.in_deezer_charts,
  a.in_shazam_charts,
  a.total_playlist AS participacion_total,
  a.streams,
  b.bpm,
  b.key,
  b.mode,
  b.`danceability_%`,
  IF(c.cuartiles_dance = 4, 'Alto', 'Bajo') AS cuartiles_dance,
  b.`valence_%`,
  IF(c.cuartiles_valence = 4, 'Alto', 'Bajo') AS cuartiles_valence,
  b.`energy_%`,
  IF(c.cuartiles_energy = 4, 'Alto', 'Bajo') AS cuartiles_energy,
  b.`acousticness_%`,
  IF(c.cuartiles_acousticness = 4, 'Alto', 'Bajo') AS cuartiles_acousticness,
  b.`instrumentalness_%`,
  IF(c.cuartiles_instrumental = 4, 'Alto', 'Bajo') AS cuartiles_instrumental,
  b.`liveness_%`,
  IF(c.cuartiles_live = 4, 'Alto', 'Bajo') AS cuartiles_live,
  b.`speechiness_%`,
  IF(c.cuartiles_speech = 4, 'Alto', 'Bajo') AS cuartiles_speech,
  c.cuartiles_streams,
  CASE
    WHEN c.cuartiles_streams = 1 THEN 'Bajo'
    WHEN c.cuartiles_streams = 2 THEN 'Medio-Bajo'
    WHEN c.cuartiles_streams = 3 THEN 'Medio-Alto'
    WHEN c.cuartiles_streams = 4 THEN 'Alto'
  END AS cuartiles_categoria

FROM 
  `laboratoria2.datos_hipotesis.view_unificado_1query` a
INNER JOIN
  `laboratoria2.datos_hipotesis.views_technical` b
ON
  a.track_id = b.track_id

INNER JOIN
  cuartiles c
ON 
  c.track_id = a.track_id
ORDER BY 
  a.released_date ASC;
