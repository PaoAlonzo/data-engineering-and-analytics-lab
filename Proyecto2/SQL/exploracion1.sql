-- Total de registros por mes
SELECT
  EXTRACT(MONTH FROM pickup_datetime) AS mes,
  COUNT(*) AS total_viajes,
  ROUND(AVG(fare_amount), 2) AS tarifa_promedio,
  ROUND(AVG(trip_distance), 2) AS distancia_promedio,
  ROUND(AVG(tip_amount), 2) AS propina_promedio
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE pickup_datetime IS NOT NULL
  AND fare_amount > 0
  AND trip_distance > 0
GROUP BY mes
ORDER BY mes;

-- Distribucion por tipo de pago
SELECT
  payment_type,
  COUNT(*) AS total_viajes,
  ROUND(AVG(fare_amount), 2) AS tarifa_promedio
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE payment_type IS NOT NULL
GROUP BY payment_type
ORDER BY total_viajes DESC;

-- Patrones por hora del dia
SELECT
  EXTRACT(HOUR FROM pickup_datetime) AS hora,
  COUNT(*) AS total_viajes,
  ROUND(AVG(fare_amount), 2) AS tarifa_promedio
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE pickup_datetime IS NOT NULL
GROUP BY hora
ORDER BY hora;

-- Top 10 zonas de recogida mas frecuentes
SELECT
  pickup_location_id,
  COUNT(*) AS total_viajes
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE pickup_location_id IS NOT NULL
GROUP BY pickup_location_id
ORDER BY total_viajes DESC
LIMIT 10;
