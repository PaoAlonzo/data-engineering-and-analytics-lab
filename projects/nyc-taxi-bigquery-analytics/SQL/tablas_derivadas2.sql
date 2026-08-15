-- Tabla base sin particion ni clustering 

CREATE OR REPLACE TABLE `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_base`
AS
SELECT
  vendor_id,
  pickup_datetime,
  dropoff_datetime,
  passenger_count,
  trip_distance,
  pickup_location_id,
  dropoff_location_id,
  payment_type,
  fare_amount,
  tip_amount,
  total_amount,
  EXTRACT(DATE FROM pickup_datetime) AS fecha_viaje,
  EXTRACT(HOUR FROM pickup_datetime) AS hora_viaje,
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS dia_semana,
  EXTRACT(MONTH FROM pickup_datetime) AS mes_viaje,
  TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) AS duracion_minutos,
  CASE
    WHEN tip_amount > 0 THEN 1
    ELSE 0
  END AS dio_propina
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE pickup_datetime IS NOT NULL
  AND dropoff_datetime IS NOT NULL
  AND fare_amount BETWEEN 1 AND 500
  AND trip_distance BETWEEN 0.1 AND 100
  AND passenger_count BETWEEN 1 AND 6
  AND EXTRACT(YEAR FROM pickup_datetime) = 2022
  