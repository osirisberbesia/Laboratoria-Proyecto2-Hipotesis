SELECT *
  FROM `laboratoria2.datos_hipotesis.track_in_spotify`
WHERE REGEXP_CONTAINS(track_id , r'[^a-zA-Z0-9]');

select * 
 FROM `laboratoria2.datos_hipotesis.track_in_spotify`
 where length(track_id)<=6