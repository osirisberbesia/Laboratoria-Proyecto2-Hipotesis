SELECT CORR(cast(streams as int64),  `danceability_%`) as dance, 
CORR(cast(streams as int64), `valence_%`) as valance, 
CORR(cast(streams as int64),  `energy_%`) as ener, 
CORR(cast(streams as int64),  `instrumentalness_%`) as instru, 
CORR(cast(streams as int64),  `liveness_%`) as live, 
CORR(cast(streams as int64),  `speechiness_%`) as speech
 FROM `laboratoria2.datos_hipotesis.view_unificado` 