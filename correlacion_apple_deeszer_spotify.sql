 SELECT CORR(b.in_deezer_charts,a.in_spotify_charts) as correlacion_spo_deezer,CORR(b.in_apple_charts,a.in_spotify_charts) as correlacion_spo_apple FROM `laboratoria2.datos_hipotesis.track_in_spotify`  a

 JOIN 

 `laboratoria2.datos_hipotesis.track_in_competition` b

 ON 

 a.track_id = b.track_id