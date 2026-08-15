-- PASO 1: Predicciones con Modelo 1 (Regresion Lineal)
-- Predice la tarifa esperada para la ultima fecha disponible en la tabla
-- Se compara la tarifa predicha vs la tarifa real

SELECT
    trip_distance,
    hora_viaje,
    duracion_minutos,
    predicted_fare_amount,
    fare_amount AS tarifa_real,
    ROUND(
        ABS(
            predicted_fare_amount - fare_amount
        ),
        2
    ) AS error_absoluto
FROM ML.PREDICT (
        MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_regresion_tarifa`, (
            SELECT
                trip_distance, pickup_location_id, dropoff_location_id, hora_viaje, dia_semana, mes_viaje, passenger_count, duracion_minutos, fare_amount
            FROM
                `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_optimizada`
            WHERE
                fecha_viaje = (
                    SELECT MAX(fecha_viaje)
                    FROM
                        `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_optimizada`
                )
            LIMIT 100
        )
    );

-- PASO 2: Predicciones con Modelo 2 (Clasificacion Logistica)
-- Predice si el pasajero dara propina en la ultima fecha disponible
-- Se compara la prediccion vs el valor real

SELECT
    trip_distance,
    hora_viaje,
    payment_type,
    predicted_dio_propina,
    dio_propina AS valor_real
FROM ML.PREDICT (
        MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina`, (
            SELECT
                trip_distance, pickup_location_id, dropoff_location_id, hora_viaje, dia_semana, payment_type, passenger_count, duracion_minutos, CAST(dio_propina AS STRING) AS dio_propina
            FROM
                `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_optimizada`
            WHERE
                fecha_viaje = (
                    SELECT MAX(fecha_viaje)
                    FROM
                        `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_optimizada`
                )
            LIMIT 100
        )
    );

-- Guardar la data
-- Es lo mismo de arriba pero ahora si almacenamos los resultados en una tabla para su posterior analisis
CREATE OR REPLACE TABLE `proyecto1-201902246.nyc_taxi_analisis.predicciones_regresion`
AS
SELECT
    trip_distance,
    hora_viaje,
    duracion_minutos,
    predicted_fare_amount,
    fare_amount AS tarifa_real,
    ROUND(ABS(predicted_fare_amount - fare_amount), 2) AS error_absoluto
FROM ML.PREDICT (
    MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_regresion_tarifa`,
    (
        SELECT
            trip_distance, pickup_location_id, dropoff_location_id,
            hora_viaje, dia_semana, mes_viaje, passenger_count,
            duracion_minutos, fare_amount
        FROM `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_optimizada`
        WHERE fecha_viaje = (
            SELECT MAX(fecha_viaje)
            FROM `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_optimizada`
        )
        LIMIT 100
    )
);

-- Es lo mismo de arriba pero ahora si almacenamos los resultados en una tabla para su posterior analisis
CREATE OR REPLACE TABLE `proyecto1-201902246.nyc_taxi_analisis.predicciones_clasificacion`
AS
SELECT
    trip_distance,
    hora_viaje,
    payment_type,
    predicted_dio_propina,
    dio_propina AS valor_real
FROM ML.PREDICT (
    MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina`,
    (
        SELECT
            trip_distance, pickup_location_id, dropoff_location_id,
            hora_viaje, dia_semana, payment_type, passenger_count,
            duracion_minutos, CAST(dio_propina AS STRING) AS dio_propina
        FROM `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_optimizada`
        WHERE fecha_viaje = (
            SELECT MAX(fecha_viaje)
            FROM `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_optimizada`
        )
        LIMIT 100
    )
);
