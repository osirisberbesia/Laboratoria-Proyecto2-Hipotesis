SELECT 
    COUNT(CASE WHEN track_id IS NULL THEN 1 END) AS null1,
    COUNT(CASE WHEN bpm IS NULL THEN 1 END) AS null2,
    COUNT(CASE WHEN `key` IS NULL THEN 1 END) AS null3,
    COUNT(CASE WHEN mode IS NULL THEN 1 END) AS null4,
    COUNT(CASE WHEN `danceability_%` IS NULL THEN 1 END) AS null5,
    COUNT(CASE WHEN `valence_%` IS NULL THEN 1 END) AS null6,
    COUNT(CASE WHEN `energy_%` IS NULL THEN 1 END) AS null7,
    COUNT(CASE WHEN `acousticness_%` IS NULL THEN 1 END) AS null8,
    COUNT(CASE WHEN `instrumentalness_%` IS NULL THEN 1 END) AS null9,
    COUNT(CASE WHEN `liveness_%` IS NULL THEN 1 END) AS null10,
    COUNT(CASE WHEN `speechiness_%` IS NULL THEN 1 END) AS null11
FROM 
    `laboratoria2.datos_hipotesis.track_technical_info`;