SELECT 
  s.track_id, s.track_name, s.artist_s_name, s.artist_count, 
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
s.track_id != "5080031" and s.streams NOT LIKE "%B%";




