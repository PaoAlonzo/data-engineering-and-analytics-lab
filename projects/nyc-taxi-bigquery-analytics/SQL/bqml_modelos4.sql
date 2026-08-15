-- PASO 1: Dataset limpio para entrenamiento

CREATE
OR
REPLACE
TABLE `proyecto1-201902246.nyc_taxi_analisis.dataset_entrenamiento` AS
SELECT
    trip_distance,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    hora_viaje,
    dia_semana,
    mes_viaje,
    passenger_count,
    duracion_minutos,
    fare_amount,
    CAST(dio_propina AS STRING) AS dio_propina
FROM
    `proyecto1-201902246.nyc_taxi_analisis.viajes_2022_optimizada`
WHERE
    duracion_minutos BETWEEN 1 AND 180
    AND fare_amount BETWEEN 2.5 AND 200;

-- PASO 2: Modelo 1 - Regresion Lineal
--  predecir el monto de la tarifa (fare_amount)
-- Variables de entrada: distancia, ubicaciones, hora, dia, duracion
-- Variable objetivo: fare_amount (numerica continua)

CREATE OR REPLACE MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_regresion_tarifa`
OPTIONS (
  model_type = 'LINEAR_REG',
  input_label_cols = ['fare_amount'],
  data_split_method = 'RANDOM',
  data_split_eval_fraction = 0.2,
  max_iterations = 20
) AS
SELECT
  trip_distance,
  pickup_location_id,
  dropoff_location_id,
  hora_viaje,
  dia_semana,
  mes_viaje,
  passenger_count,
  duracion_minutos,
  fare_amount
FROM `proyecto1-201902246.nyc_taxi_analisis.dataset_entrenamiento`;

-- PASO 3: Modelo 2 - Regresion Logistica
-- predecir si el pasajero dara propina (dio_propina)
-- Variables de entrada: distancia, ubicaciones, hora, dia, tipo de pago
-- Variable objetivo: dio_propina

CREATE OR REPLACE MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina`
OPTIONS (
  model_type = 'LOGISTIC_REG',
  input_label_cols = ['dio_propina'],
  data_split_method = 'RANDOM',
  data_split_eval_fraction = 0.2,
  max_iterations = 20,
  l1_reg = 0.1
) AS
SELECT
  trip_distance,
  pickup_location_id,
  dropoff_location_id,
  hora_viaje,
  dia_semana,
  payment_type,
  passenger_count,
  duracion_minutos,
  dio_propina
FROM `proyecto1-201902246.nyc_taxi_analisis.dataset_entrenamiento`;

-- PASO 4: Evaluar Modelo 1 (Regresion Lineal)
-- Metricas esperadas: mean_absolute_error, mean_squared_error,

SELECT *
FROM ML.EVALUATE (
        MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_regresion_tarifa`
    );

-- PASO 5: Evaluar Modelo 2 (Clasificacion Logistica)
-- Metricas esperadas: precision, recall, accuracy, f1_score, roc_auc

SELECT *
FROM ML.EVALUATE (
        MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina`
    );

-- PASO 6: Matriz de confusion del modelo de clasificacion
-- Permite ver verdaderos positivos, falsos positivos, etc.

SELECT *
FROM ML.CONFUSION_MATRIX (
        MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina`
    );

-- PASO 7: Modelo 3 - Regresion Logistica v2 (hiperparametros distintos)

CREATE OR REPLACE MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina_v2`
OPTIONS (
  model_type = 'LOGISTIC_REG',
  input_label_cols = ['dio_propina'],
  data_split_method = 'RANDOM',
  data_split_eval_fraction = 0.3,
  max_iterations = 50,
  l2_reg = 0.1
) AS
SELECT
  trip_distance,
  pickup_location_id,
  dropoff_location_id,
  hora_viaje,
  dia_semana,
  payment_type,
  passenger_count,
  duracion_minutos,
  dio_propina
FROM `proyecto1-201902246.nyc_taxi_analisis.dataset_entrenamiento`;


-- PASO 8: Evaluar Modelo 3 individualmente

SELECT *
FROM ML.EVALUATE (
  MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina_v2`
);


-- PASO 9: Comparacion directa Modelo 2 vs Modelo 3
-- precision, recall, accuracy, f1_score, roc_auc en una sola tabla

SELECT
  'v1: l1_reg=0.1 | iter=20 | eval=20%' AS configuracion,
  precision,
  recall,
  accuracy,
  f1_score,
  roc_auc
FROM ML.EVALUATE (
  MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina`
)

UNION ALL

SELECT
  'v2: l2_reg=0.1 | iter=50 | eval=30%' AS configuracion,
  precision,
  recall,
  accuracy,
  f1_score,
  roc_auc
FROM ML.EVALUATE (
  MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina_v2`
);


-- PASO 10: Matriz de confusion del Modelo 3

SELECT *
FROM ML.CONFUSION_MATRIX (
  MODEL `proyecto1-201902246.nyc_taxi_analisis.modelo_clasificacion_propina_v2`
);