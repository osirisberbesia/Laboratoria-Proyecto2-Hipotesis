  with auxiliar as
  (SELECT 
    artist_s_name,count(artist_s_name) as conteo,sum(cast(streams as int)) as streamss
  FROM 
    `laboratoria2.datos_hipotesis.view_unificado`
 group by artist_s_name 
 order by conteo desc)

 select corr(a.streamss, a.conteo)
 from auxiliar a