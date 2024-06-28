WITH temporal_with AS (
  SELECT track_id, artist_s_name, artist_count
  FROM `laboratoria2.datos_hipotesis.view_unificado` 
  WHERE artist_count = 1
  group by track_id, artist_s_name, artist_count
)

SELECT 
  t.artist_s_name, 
  COUNT(t.artist_s_name) AS cantidad
FROM `laboratoria2.datos_hipotesis.view_unificado` u

JOIN temporal_with t
ON t.track_id = u.track_id
group by  t.artist_s_name
order by t.artist_s_name asc
