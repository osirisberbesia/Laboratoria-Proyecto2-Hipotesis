# Proyecto 2 de Análisis de Datos (Hipótesis)
## Índice

- [Objetivos](#objetivos)
- [Equipo](#equipo)
- [Herramientas y Tecnologías](#herramientas-y-tecnologas)
- [Procesamiento y análisis](#procesamiento-y-anlisis)
  - [Creación de nuevas variables](#creacin-de-nuevas-variables)
  - [Unificación de tablas](#unificacin-de-tablas)
- [Resultados y Conclusiones](#resultados-y-conclusiones)
  - [Resultados](#resultados)
- [Conclusiones](#conclusiones)
- [Limitaciones/Próximos Pasos:](#limitacionesprximos-pasos)
  - [Limitaciones](#limitaciones)
  - [Próximos pasos](#prximos-pasos)
- [Enlaces de interés:](#enlaces-de-inters)


## Objetivos

Preparar la información de la base de datos que corresponde a los datos de las reproducciones de canciones más escuchadas en el año 2023 en la plataforma Spotify, Deezer y Apple, para comprender, respaldar y conocer el comportamiento que hace que una canción sea mayor o menormente escuchada en una plataforma. 
Analizar los datos, para convertirlos en información respaldada por cálculos estadísticos.

Se pretende obtener las respuestas para validar o refutar las siguientes hipótesis:

* Las canciones con un mayor BPM (Beats Por Minuto) tienen más éxito en términos de cantidad de streams en Spotify.
* Las canciones más populares en el ranking de Spotify también tienen un comportamiento similar en otras plataformas como Deezer.
* La presencia de una canción en un mayor número de playlists se relaciona con un mayor número de streams.
* Los artistas con un mayor número de canciones en Spotify tienen más streams.
* Las características de la música influyen en el éxito en términos de cantidad de streams en Spotify.
* Las el modo de la canción "Minor" o "Major" influye en la cantidad de reproducciones de la misma.

## Equipo

Osiris Berbesia - Julieta Salto

## Herramientas y Tecnologías

* SQL
* BigQuery
* Documentación de Google Console
* Documentación Python
* OpenAI - ChatGPT
* Google Slides
* YouTube

## Procesamiento y análisis

Antes de la exploración de datos, se importan los documentos contenedores de la información dentro de un proyecto en BigQuery.

Luego se procede a la limpieza de datos, la cual incluye:

* Eliminación de duplicados. (Validación que incluye que la combinación de un artista+canción esté repetida)
* Valores Nulos, permanecen en el sistema. (No afectan nuestros datos)
* Eliminación  de caracteres especiales como: �����
* Eliminación de datos donde no corresponden, ejm, caracteres de letras en variables numéricas.

Consultas utilizadas para la limpieza de datos.

Validación de duplicados que tenían artist(s)+nombre de canción repetido:
```sql
  SELECT track_name, artist_s_name
  FROM `laboratoria2.datos_hipotesis.track_in_spotify`
  GROUP BY track_name, artist_s_name
  HAVING COUNT(*) > 1
  order by track_name
```
Luego se traen todos los datos, para validar si los duplicados deben ser eliminados o realmente tomados en cuenta.

```sql
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
```

Con lo anterior, se determina que:

* Los dos Track id que no se tomarán en cuenta son:
    * "5080031" 
    * "7173596"

Para la validación y limpieza de carácteres de datos, junto a la omisión de los track_id que no serán utilizados, además de ser la consulta para crear el view con el que se iba a trabajar, se usó la siguiente consulta:

```sql
SELECT 
  s.track_id, 
  

  REGEXP_REPLACE(s.track_name, r"[^a-zA-Z0-9\s\-:,?\'()&]", '') as track_name,

  REGEXP_REPLACE(s.artist_s_name, r"[^a-zA-Z0-9\s\-:,?\'()&]", '') as artist_s_name,
  
  s.artist_count, 
 CAST(CONCAT(s.released_year, '-', s.released_month, '-', s.released_day) AS DATE) AS released_date,
   s.in_spotify_playlists, s.in_spotify_charts,
  c.in_apple_playlists, 
  c.in_apple_charts,
  c.in_deezer_playlists,
   c.in_deezer_charts, 
   c.in_shazam_charts,
  (s.in_spotify_playlists+c.in_apple_playlists+c.in_deezer_playlists) as participacion_total, s.streams

FROM `laboratoria2.datos_hipotesis.track_in_spotify` AS s
INNER JOIN
(SELECT track_id, in_apple_playlists,in_apple_charts, in_deezer_playlists,in_deezer_charts, in_shazam_charts FROM `laboratoria2.datos_hipotesis.track_in_competition`) AS c
ON s.track_id = c.track_id
where
s.track_id != "5080031" and s.streams NOT LIKE "%B%" and s.track_id !="7173596";
```

### Creación de nuevas variables

 * categoria_artista: separa a las superestrellas, estrellas y artistas de nicho, basandose en el recorrido artístico de cada artista.


 * genero_artista: asigna a aproximadamente las 100 canciones con más éxito el genero a la que corresponde el artista, dentro de las cuales están:
    * Rock
    * Pop
    * Otros
    * Hip-Hop/Rap
    * R&B
    * Electrónica
    * Reggaeton
    * Regional Mexicano


 * modo_cancion: tomando en cuenta la variable existente artist_count (cantidad de artistas que participan en la canción) se categoriza la canción según su participación, como:
    * Feat (participa más de un artista)
    * Solo (Participa solo un artista)

 * released_date: es el resultado del concatenado de la fecha separada por día, mes y año de la tabla original en formato DATE.


 * participacion_total: es la sumatoria de las playlist en la que aparece una canción en las tres plataformas

* cuartiles:

  Los siguientes cuartiles categorizan entre alto y bajo segun el valor de la caracteristica de la música:

  * cuartiles_dance
  * cuartiles_valence
  * cuartiles_energy
  * cuartiles_acousticness
  * cuartiles_intrumental
  * cuartiles_live
  * cuartiles_speech

Los siguientes dividen en 4 variables a los cuartiles según el valor de la cantidad de streams de cada valor. Donde:

  * cuartiles_streams: variable numérica del 1 al 4


  * cuartiles_categoria: variable string que categoriza la variable anterior en:
    * 4 - Alto
    * 3 - Medio-Alto
    * 2 - Medio-Bajo
    * 1 - Bajo


### Unificación de tablas
Se genera un view, donde está el unificado de nuestras primeras 3 tablas proporcionadas, más las nuevas variables. 

La tabla unificada queda así:

![alt text](image.png)
![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image-3.png)


## Resultados y Conclusiones
### Resultados

Después de la limpieza de los datos, de 953 tracks, quedaron 948 tracks.
Con los cuales se puede concluir lo siguiente para cada hipótesis:

* Las canciones con un mayor BPM (Beats Por Minuto) tienen más éxito en términos de cantidad de streams en Spotify.
El resultado de la formula que nos 
* Las canciones más populares en el ranking de Spotify también tienen un comportamiento similar en otras plataformas como Deezer.
* La presencia de una canción en un mayor número de playlists se relaciona con un mayor número de streams.
* Los artistas con un mayor número de canciones en Spotify tienen más streams.
* Las características de la música influyen en el éxito en términos de cantidad de streams en Spotify.
* Las el modo de la canción "Minor" o "Major" influye en la cantidad de reproducciones de la misma.



## Conclusiones


## Limitaciones/Próximos Pasos:
### Limitaciones


### Próximos pasos

## Enlaces de interés:

[Google Colab Notebook](https://colab.research.google.com/drive/1WFhzvPDD8SYc2n5df5IysLFr5h8cMPmx?usp=sharing)
[Presentación - Google Slides](https://docs.google.com/presentation/d/1X3Xdv1IGNor8D9KBSDh25LyeDOJMR0BY027JqDykrEs/edit?usp=sharing)
[Video Loom]
[Repertorio GitHub]


