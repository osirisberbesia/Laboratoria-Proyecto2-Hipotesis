SELECT
    COUNT(DISTINCT CASE WHEN key IS NOT NULL THEN key ELSE NULL END) AS total_duplicados_key,
    COUNT(DISTINCT CASE WHEN bpm IS NOT NULL THEN bpm ELSE NULL END) AS total_duplicados_bpm,
    COUNT(DISTINCT CASE WHEN `key` IS NOT NULL THEN `key` ELSE NULL END) AS total_duplicados_key,
    COUNT(DISTINCT CASE WHEN mode IS NOT NULL THEN mode ELSE NULL END) AS total_duplicados_mode,
    COUNT(DISTINCT CASE WHEN `danceability_%` IS NOT NULL THEN `danceability_%` ELSE NULL END) AS total_duplicados_danceability,
    COUNT(DISTINCT CASE WHEN `valence_%` IS NOT NULL THEN `valence_%` ELSE NULL END) AS total_duplicados_valence,
    COUNT(DISTINCT CASE WHEN `energy_%` IS NOT NULL THEN `energy_%` ELSE NULL END) AS total_duplicados_energy,
    COUNT(DISTINCT CASE WHEN `acousticness_%` IS NOT NULL THEN `acousticness_%` ELSE NULL END) AS total_duplicados_acousticness,
    COUNT(DISTINCT CASE WHEN `instrumentalness_%` IS NOT NULL THEN `instrumentalness_%` ELSE NULL END) AS total_duplicados_instrumentalness,
    COUNT(DISTINCT CASE WHEN `liveness_%` IS NOT NULL THEN `liveness_%` ELSE NULL END) AS total_duplicados_liveness,
    COUNT(DISTINCT CASE WHEN `speechiness_%` IS NOT NULL THEN `speechiness_%` ELSE NULL END) AS total_duplicados_speechiness
FROM `laboratoria2.datos_hipotesis.track_technical_info`