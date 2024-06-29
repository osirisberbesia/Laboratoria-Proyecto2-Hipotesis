WITH duplicates AS (
  SELECT track_name, artist_s_name
  FROM `laboratoria2.datos_hipotesis.track_in_spotify`
  GROUP BY track_name, artist_s_name
  HAVING COUNT(*) > 1
)
SELECT t.*
FROM `laboratoria2.datos_hipotesis.track_in_spotify` t
JOIN duplicates d
ON t.track_name = d.track_name AND t.artist_s_name = d.artist_s_name;
