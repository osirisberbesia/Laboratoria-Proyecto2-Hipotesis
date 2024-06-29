SELECT
  MIN(bpm) AS min_bpm,
  MIN(`danceability_%`) AS min_danceability,
  MIN(`valence_%`) AS min_valence,
  MIN(`energy_%`) AS min_energy,
  MIN(`acousticness_%`) AS min_acousticness,
  MIN(`instrumentalness_%`) AS min_instrumentalness,
  MIN(`liveness_%`) AS min_liveness,
  MIN(`speechiness_%`) AS min_speechiness
FROM `laboratoria2.datos_hipotesis.track_technical_info`;

SELECT
  MAX(bpm) AS max_bpm,
  MAX(`danceability_%`) AS max_danceability,
  MAX(`valence_%`) AS max_valence,
  MAX(`energy_%`) AS max_energy,
  MAX(`acousticness_%`) AS max_acousticness,
  MAX(`instrumentalness_%`) AS max_instrumentalness,
  MAX(`liveness_%`) AS max_liveness,
  MAX(`speechiness_%`) AS max_speechiness
FROM `laboratoria2.datos_hipotesis.track_technical_info`;

SELECT
  AVG(bpm) AS avg_bpm,
  AVG(`danceability_%`) AS avg_danceability,
  AVG(`valence_%`) AS avg_valence,
  AVG(`energy_%`) AS avg_energy,
  AVG(`acousticness_%`) AS avg_acousticness,
  AVG(`instrumentalness_%`) AS avg_instrumentalness,
  AVG(`liveness_%`) AS avg_liveness,
  AVG(`speechiness_%`) AS avg_speechiness
FROM `laboratoria2.datos_hipotesis.track_technical_info`;

