SELECT *
FROM `laboratoria2.datos_hipotesis.track_in_spotify`
WHERE REGEXP_CONTAINS(streams, r'[^\d]')