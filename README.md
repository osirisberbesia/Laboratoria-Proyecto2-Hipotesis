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

1. Las canciones con un mayor BPM (Beats Por Minuto) tienen más éxito en términos de cantidad de streams en Spotify.

Se exploró la relación entre una variable y otra a través de la correlación de Pearson, la cual dió el siguiente resultado:
-0.0007 Lo cual, al ser un resultado más cercano a 0 que a 1 o -1, indica que no hay ninguna correlación entre estas variables.

Observando gráficamente, a través de un scatter plot:

![alt text](image-4.png)

Se observa igualmente que los datos están dispersos y no se puede demostrar que esten relacionados entre si.

Por otro lado, aunque en este mapa de calor, se puede ver de forma gráfica que los que tienen BPM Bajos (por debajo de 130), tienen un conteo mayor de tracks

![alt text](image-5.png)


2. Las canciones más populares en el ranking de Spotify también tienen un comportamiento similar en otras plataformas como Deezer.

Las plataformas que se evaluaron fueron Deezer y Apple. 

Obteniendo los siguientes resultados de la siguiente Query:

```sql
 SELECT CORR(b.in_deezer_charts,a.in_spotify_charts) as correlacion_spo_deezer,CORR(b.in_apple_charts,a.in_spotify_charts) as correlacion_spo_apple FROM `laboratoria2.datos_hipotesis.track_in_spotify`  a

 JOIN 

 `laboratoria2.datos_hipotesis.track_in_competition` b

 ON 

 a.track_id = b.track_id
 ```
 
![alt text](image-6.png)

Gráficamente la relación entre las plataformas es la siguiente:

![](image-7.png)


Aplicando igualmente otras pruebas y test estadísticos, se obtienen los siguientes resultados:

#### Análisis de Charts (Deezer y Apple vs Spotify Charts):
Prueba de Shapiro-Wilk para Spotify Charts:
W-statistic: 0.6869614720344543
p-value: 1.6415153248964974e-37
Indica que los datos de Spotify Charts no siguen una distribución normal, ya que el p-value es extremadamente pequeño.

#### Test t de Student para Deezer vs Spotify Charts:

T-statistic: -14.264810631405497
p-value: 2.486799167406407e-42
Hay evidencia significativa para rechazar la hipótesis nula de que no hay diferencia entre las medias de Deezer y Spotify Charts. La popularidad en Deezer es significativamente diferente a la de Spotify.

#### Test t de Student para Apple vs Spotify Charts:
T-statistic: 23.435564295372654
p-value: 1.1223952978245818e-99
Hay evidencia significativa para rechazar la hipótesis nula de que no hay diferencia entre las medias de Apple y Spotify Charts. La popularidad en Apple Charts es significativamente diferente a la de Spotify.

#### Test de Wilcoxon-Mann-Whitney para Deezer vs Spotify Charts:

U-statistic: 263284.0
p-value: 4.150186927427789e-36
Indica que hay diferencias significativas en cómo se distribuyen las posiciones en los charts entre Deezer y Spotify.

#### Test de Wilcoxon-Mann-Whitney para Apple vs Spotify Charts:

U-statistic: 628814.0
p-value: 4.662872441105302e-110
Indica que hay diferencias significativas en cómo se distribuyen las posiciones en los charts entre Apple y Spotify.


* La presencia de una canción en un mayor número de playlists se relaciona con un mayor número de streams.
Para evaluar esta hipótesis, se realizó la consulta:
```sql
SELECT
  CORR(CAST(streams AS int64), participacion_total) AS correlacion
FROM
  `laboratoria2.datos_hipotesis.participacion_playlists`
```
Donde el resultado fue:

![alt text](image-9.png)

Con las pruebas estadisticas adicionales, se obtiene que:
#### Prueba de Shapiro-Wilk para participacion_total:

* W-statistic (estadístico W): 0.605
* p-value: 6.32e-42
* Interpretación: La prueba de Shapiro-Wilk verifica si los datos siguen una distribución normal. Con un p-value extremadamente bajo, podemos rechazar la hipótesis nula de normalidad. Esto indica que participacion_total no sigue una distribución normal.

#### Test t de Student para participacion_total vs streams:

* T-statistic (estadístico t): -27.88
* p-value: 2.19e-125
* Interpretación: Este test compara las medias de participacion_total y streams. Un p-value tan bajo sugiere que hay una diferencia significativa entre estas variables. En términos simples, la cantidad de streams está muy relacionada con la participación total, con una correlación muy fuerte y negativa (es decir, más participación total significa menos streams y viceversa).

#### Test de Wilcoxon-Mann-Whitney para participacion_total vs streams:

* Error: x and y must be of nonzero size.
* Interpretación: Hubo un error porque los datos no cumplen con los requisitos para este test específico en cuanto a tamaño.

#### Para in_apple_playlists vs streams:
#### Prueba de Shapiro-Wilk para in_apple_playlists:

* W-statistic: 0.721
* p-value: 5.06e-37
* Interpretación: Similar a participacion_total, in_apple_playlists no sigue una distribución normal, debido al p-value muy bajo.

#### Test t de Student para in_apple_playlists vs streams:

* T-statistic: -27.88
* p-value: 2.19e-125
* Interpretación: Hay una correlación significativa y negativa entre in_apple_playlists y streams, lo que sugiere que las canciones que están en más playlists de Apple tienden a tener menos streams, y viceversa.

#### Test de Wilcoxon-Mann-Whitney para in_apple_playlists vs streams:

* U-statistic: 145.0
* p-value: 0.367
* Interpretación: El p-value relativamente alto indica que no hay una diferencia significativa en los valores de streams entre las canciones que están o no en playlists de Apple. En criollo, estar en playlists de Apple no parece afectar de manera considerable la cantidad de streams.

#### Para in_deezer_playlists vs streams:
#### Prueba de Shapiro-Wilk para in_deezer_playlists:

* W-statistic: 0.363
* p-value: 0.0
* Interpretación: Similar a los anteriores, in_deezer_playlists no sigue una distribución normal debido al p-value cercano a cero.

#### Test t de Student para in_deezer_playlists vs streams:

* T-statistic: -27.88
* p-value: 2.19e-125
* Interpretación: Hay una correlación significativa y negativa entre in_deezer_playlists y streams, lo que indica que las canciones en más playlists de Deezer tienden a tener menos streams, y viceversa.

#### Test de Wilcoxon-Mann-Whitney para in_deezer_playlists vs streams:

* U-statistic: 139.0
* p-value: 0.600
* Interpretación: Al igual que con Apple Music, el p-value alto sugiere que no hay una diferencia significativa en los valores de streams entre las canciones que están o no en playlists de Deezer.


* Los artistas con un mayor número de canciones en Spotify tienen más streams.


* Las características de la música influyen en el éxito en términos de cantidad de streams en Spotify.


* Las el modo de la canción "Minor" o "Major" influye en la cantidad de reproducciones de la misma.




## Conclusiones
Según cada hipótesis:

1. Al evaluar los datos a través de la prueba Shapiro-Wilk, se puede asumir que los datos para BPM y Streams en todas las categorías de cuartiles siguen una distribución normal.
Por lo cual, podemos aplicar Test Mann-Whitney U como segunda comprobación de la influencia de una variable sobre la otra.
En el cual los resultados sugieren que no hay diferencias significativas en los promedios de BPM entre los cuartiles Alto y Bajo, ni entre Medio-Alto y Medio-Bajo, ya que los p-valores son altos (1.0), lo que indica que no hay suficiente evidencia para rechazar la hipótesis nula de que las distribuciones de BPM en estos grupos son iguales.
En otras palabras, los datos disponibles no muestran una diferencia significativa en los promedios de BPM entre los grupos.

Corroborandose de igual forma con la regresión lineal simple:

![alt text](image-8.png)

2. Los tests estadísticos muestran que Deezer y Apple tienen diferencias significativas en popularidad comparadas con Spotify Charts. Esto se evidencia en los valores bajos de p-value en los tests t de Student y los tests de Wilcoxon-Mann-Whitney. E igualmente Deezer y Apple tienen patrones de popularidad diferentes a los de Spotify, según los análisis de charts realizados.

## Limitaciones/Próximos Pasos:
### Limitaciones


### Próximos pasos

## Enlaces de interés:

[Google Colab Notebook](https://colab.research.google.com/drive/1WFhzvPDD8SYc2n5df5IysLFr5h8cMPmx?usp=sharing)
[Presentación - Google Slides](https://docs.google.com/presentation/d/1X3Xdv1IGNor8D9KBSDh25LyeDOJMR0BY027JqDykrEs/edit?usp=sharing)
[Video Loom]
[Repertorio GitHub]


