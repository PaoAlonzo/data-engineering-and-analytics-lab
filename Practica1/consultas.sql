
USE DW_Vuelos;
GO

-- SECCIÓN 1: CONSULTAS DE VALIDACIÓN

-- 1.1 Conteo de registros por tabla

SELECT 
    'dim_aerolinea' AS Tabla,
    COUNT(*) AS Total_Registros
FROM dim_aerolinea
UNION ALL
SELECT 
    'dim_aeropuerto' AS Tabla,
    COUNT(*) AS Total_Registros
FROM dim_aeropuerto
UNION ALL
SELECT 
    'dim_pasajero' AS Tabla,
    COUNT(*) AS Total_Registros
FROM dim_pasajero
UNION ALL
SELECT 
    'dim_avion' AS Tabla,
    COUNT(*) AS Total_Registros
FROM dim_avion
UNION ALL
SELECT 
    'dim_fecha' AS Tabla,
    COUNT(*) AS Total_Registros
FROM dim_fecha
UNION ALL
SELECT 
    'fact_vuelo' AS Tabla,
    COUNT(*) AS Total_Registros
FROM fact_vuelo
ORDER BY Tabla;
GO



-- 1.2 Verificar integridad referencial

SELECT 
    'Vuelos sin aerolínea' AS Verificacion,
    COUNT(*) AS Total
FROM fact_vuelo f
LEFT JOIN dim_aerolinea a ON f.airline_id = a.airline_id
WHERE a.airline_id IS NULL

UNION ALL

SELECT 
    'Vuelos sin aeropuerto origen' AS Verificacion,
    COUNT(*) AS Total
FROM fact_vuelo f
LEFT JOIN dim_aeropuerto a ON f.origin_airport_id = a.airport_id
WHERE a.airport_id IS NULL

UNION ALL

SELECT 
    'Vuelos sin aeropuerto destino' AS Verificacion,
    COUNT(*) AS Total
FROM fact_vuelo f
LEFT JOIN dim_aeropuerto a ON f.destination_airport_id = a.airport_id
WHERE a.airport_id IS NULL

UNION ALL

SELECT 
    'Vuelos sin pasajero' AS Verificacion,
    COUNT(*) AS Total
FROM fact_vuelo f
LEFT JOIN dim_pasajero p ON f.passenger_key = p.passenger_key
WHERE p.passenger_key IS NULL;
GO


-- SECCIÓN 2: ANÁLISIS DE VUELOS

-- 2.1 Total de vuelos

SELECT 
    COUNT(*) AS Total_Vuelos,
    COUNT(DISTINCT flight_number) AS Numeros_Vuelo_Unicos,
    COUNT(DISTINCT record_id) AS Registros_Unicos
FROM fact_vuelo;
GO


-- 2.2 Top 10 aerolíneas con más vuelos

SELECT TOP 10
    a.airline_code AS Codigo,
    a.airline_name AS Aerolinea,
    COUNT(*) AS Total_Vuelos,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje
FROM fact_vuelo f
INNER JOIN dim_aerolinea a ON f.airline_id = a.airline_id
GROUP BY a.airline_code, a.airline_name
ORDER BY Total_Vuelos DESC;
GO


-- 2.3 Top 10 rutas más frecuentes
--------------------------------------';

SELECT TOP 10
    origen.airport_code AS Origen,
    destino.airport_code AS Destino,
    COUNT(*) AS Total_Vuelos,
    AVG(f.duration_min) AS Duracion_Promedio_Min,
    AVG(f.ticket_price_usd) AS Precio_Promedio_USD
FROM fact_vuelo f
INNER JOIN dim_aeropuerto origen ON f.origin_airport_id = origen.airport_id
INNER JOIN dim_aeropuerto destino ON f.destination_airport_id = destino.airport_id
GROUP BY origen.airport_code, destino.airport_code
ORDER BY Total_Vuelos DESC;
GO


-- 2.4 Top 10 destinos más populares

SELECT TOP 10
    a.airport_code AS Destino,
    COUNT(*) AS Total_Llegadas,
    COUNT(DISTINCT f.airline_id) AS Aerolineas_Diferentes
FROM fact_vuelo f
INNER JOIN dim_aeropuerto a ON f.destination_airport_id = a.airport_id
GROUP BY a.airport_code
ORDER BY Total_Llegadas DESC;
GO


-- 2.5 Top 10 orígenes más frecuentes

SELECT TOP 10
    a.airport_code AS Origen,
    COUNT(*) AS Total_Salidas,
    COUNT(DISTINCT f.airline_id) AS Aerolineas_Diferentes
FROM fact_vuelo f
INNER JOIN dim_aeropuerto a ON f.origin_airport_id = a.airport_id
GROUP BY a.airport_code
ORDER BY Total_Salidas DESC;
GO


-- SECCIÓN 3: ANÁLISIS DE ESTADO DE VUELOS

-- 3.1 Distribución por estado de vuelo

SELECT 
    status AS Estado,
    COUNT(*) AS Total_Vuelos,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje
FROM fact_vuelo
GROUP BY status
ORDER BY Total_Vuelos DESC;
GO


-- 3.2 Análisis de demoras (delays)

SELECT 
    status AS Estado,
    COUNT(*) AS Total_Vuelos,
    AVG(CAST(delay_min AS FLOAT)) AS Demora_Promedio_Min,
    MIN(delay_min) AS Demora_Minima_Min,
    MAX(delay_min) AS Demora_Maxima_Min,
    SUM(delay_min) AS Demora_Total_Min
FROM fact_vuelo
WHERE status = 'DELAYED'
GROUP BY status;
GO


-- 3.3 Aerolíneas con más demoras

SELECT TOP 10
    a.airline_code AS Codigo,
    a.airline_name AS Aerolinea,
    COUNT(*) AS Vuelos_Demorados,
    AVG(CAST(f.delay_min AS FLOAT)) AS Demora_Promedio_Min,
    MAX(f.delay_min) AS Demora_Maxima_Min
FROM fact_vuelo f
INNER JOIN dim_aerolinea a ON f.airline_id = a.airline_id
WHERE f.status = 'DELAYED' AND f.delay_min IS NOT NULL
GROUP BY a.airline_code, a.airline_name
ORDER BY Vuelos_Demorados DESC;
GO


-- 3.4 Vuelos cancelados por aerolínea

SELECT 
    a.airline_code AS Codigo,
    a.airline_name AS Aerolinea,
    COUNT(*) AS Vuelos_Cancelados,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo WHERE status = 'CANCELLED') AS DECIMAL(5,2)) AS Porcentaje_Del_Total
FROM fact_vuelo f
INNER JOIN dim_aerolinea a ON f.airline_id = a.airline_id
WHERE f.status = 'CANCELLED'
GROUP BY a.airline_code, a.airline_name
ORDER BY Vuelos_Cancelados DESC;
GO



-- SECCIÓN 4: ANÁLISIS DE PASAJEROS

-- 4.1 Distribución por género

SELECT 
    CASE 
        WHEN p.gender = 'M' THEN 'Masculino'
        WHEN p.gender = 'F' THEN 'Femenino'
        WHEN p.gender = 'X' THEN 'Otro'
        ELSE 'No especificado'
    END AS Genero,
    COUNT(*) AS Total_Vuelos,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje
FROM fact_vuelo f
INNER JOIN dim_pasajero p ON f.passenger_key = p.passenger_key
GROUP BY p.gender
ORDER BY Total_Vuelos DESC;
GO


-- 4.2 Distribución por rango de edad


SELECT 
    CASE 
        WHEN p.age < 18 THEN '0-17 (Menor)'
        WHEN p.age BETWEEN 18 AND 25 THEN '18-25 (Joven)'
        WHEN p.age BETWEEN 26 AND 35 THEN '26-35 (Adulto Joven)'
        WHEN p.age BETWEEN 36 AND 50 THEN '36-50 (Adulto)'
        WHEN p.age > 50 THEN '51+ (Adulto Mayor)'
        ELSE 'No especificado'
    END AS Rango_Edad,
    COUNT(*) AS Total_Vuelos,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje,
    AVG(f.ticket_price_usd) AS Precio_Promedio_USD
FROM fact_vuelo f
INNER JOIN dim_pasajero p ON f.passenger_key = p.passenger_key
GROUP BY 
    CASE 
        WHEN p.age < 18 THEN '0-17 (Menor)'
        WHEN p.age BETWEEN 18 AND 25 THEN '18-25 (Joven)'
        WHEN p.age BETWEEN 26 AND 35 THEN '26-35 (Adulto Joven)'
        WHEN p.age BETWEEN 36 AND 50 THEN '36-50 (Adulto)'
        WHEN p.age > 50 THEN '51+ (Adulto Mayor)'
        ELSE 'No especificado'
    END
ORDER BY Total_Vuelos DESC;
GO


-- 4.3 Top 10 nacionalidades con más vuelos

SELECT TOP 10
    p.nationality AS Nacionalidad,
    COUNT(*) AS Total_Vuelos,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje,
    AVG(f.ticket_price_usd) AS Precio_Promedio_USD
FROM fact_vuelo f
INNER JOIN dim_pasajero p ON f.passenger_key = p.passenger_key
WHERE p.nationality IS NOT NULL
GROUP BY p.nationality
ORDER BY Total_Vuelos DESC;
GO


-- SECCIÓN 5: ANÁLISIS FINANCIERO

-- 5.1 Resumen de ventas

SELECT 
    COUNT(*) AS Total_Ventas,
    SUM(ticket_price_usd) AS Ingreso_Total_USD,
    AVG(ticket_price_usd) AS Precio_Promedio_USD,
    MIN(ticket_price_usd) AS Precio_Minimo_USD,
    MAX(ticket_price_usd) AS Precio_Maximo_USD
FROM fact_vuelo
WHERE ticket_price_usd IS NOT NULL;
GO


-- 5.2 Ventas por canal de venta

SELECT 
    sales_channel AS Canal_Venta,
    COUNT(*) AS Total_Ventas,
    SUM(ticket_price_usd) AS Ingreso_Total_USD,
    AVG(ticket_price_usd) AS Precio_Promedio_USD,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje_Ventas
FROM fact_vuelo
WHERE sales_channel IS NOT NULL
GROUP BY sales_channel
ORDER BY Total_Ventas DESC;
GO


-- 5.3 Ventas por método de pago

SELECT 
    payment_method AS Metodo_Pago,
    COUNT(*) AS Total_Transacciones,
    SUM(ticket_price_usd) AS Ingreso_Total_USD,
    AVG(ticket_price_usd) AS Precio_Promedio_USD,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje
FROM fact_vuelo
WHERE payment_method IS NOT NULL
GROUP BY payment_method
ORDER BY Total_Transacciones DESC;
GO

-- 5.4 Top 10 aerolíneas por ingresos

SELECT TOP 10
    a.airline_code AS Codigo,
    a.airline_name AS Aerolinea,
    COUNT(*) AS Total_Vuelos,
    SUM(f.ticket_price_usd) AS Ingreso_Total_USD,
    AVG(f.ticket_price_usd) AS Precio_Promedio_USD
FROM fact_vuelo f
INNER JOIN dim_aerolinea a ON f.airline_id = a.airline_id
WHERE f.ticket_price_usd IS NOT NULL
GROUP BY a.airline_code, a.airline_name
ORDER BY Ingreso_Total_USD DESC;
GO


-- SECCIÓN 6: ANÁLISIS DE CLASE DE CABINA

-- 6.1 Distribución por clase de cabina

SELECT 
    av.cabin_class AS Clase_Cabina,
    COUNT(*) AS Total_Vuelos,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje,
    AVG(f.ticket_price_usd) AS Precio_Promedio_USD
FROM fact_vuelo f
INNER JOIN dim_avion av ON f.aircraft_id = av.aircraft_id
GROUP BY av.cabin_class
ORDER BY Total_Vuelos DESC;
GO


-- 6.2 Tipo de aeronave más utilizado


SELECT TOP 10
    av.aircraft_type AS Tipo_Aeronave,
    COUNT(*) AS Total_Vuelos,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje
FROM fact_vuelo f
INNER JOIN dim_avion av ON f.aircraft_id = av.aircraft_id
GROUP BY av.aircraft_type
ORDER BY Total_Vuelos DESC;
GO



-- SECCIÓN 7: ANÁLISIS TEMPORAL

-- 7.1 Vuelos por año

SELECT 
    df.anio AS Anio,
    COUNT(*) AS Total_Vuelos,
    SUM(f.ticket_price_usd) AS Ingreso_Total_USD,
    AVG(f.ticket_price_usd) AS Precio_Promedio_USD
FROM fact_vuelo f
INNER JOIN dim_fecha df ON f.departure_date_id = df.date_id
GROUP BY df.anio
ORDER BY df.anio;
GO


-- 7.2 Vuelos por mes (del año más reciente)

SELECT 
    df.anio AS Anio,
    df.mes AS Mes,
    df.nombre_mes AS Nombre_Mes,
    COUNT(*) AS Total_Vuelos,
    AVG(f.ticket_price_usd) AS Precio_Promedio_USD
FROM fact_vuelo f
INNER JOIN dim_fecha df ON f.departure_date_id = df.date_id
GROUP BY df.anio, df.mes, df.nombre_mes
ORDER BY df.anio DESC, df.mes;
GO


-- 7.3 Vuelos por día de la semana

SELECT 
    df.nombre_dia_semana AS Dia_Semana,
    COUNT(*) AS Total_Vuelos,
    AVG(f.ticket_price_usd) AS Precio_Promedio_USD,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo WHERE departure_date_id IS NOT NULL) AS DECIMAL(5,2)) AS Porcentaje
FROM fact_vuelo f
INNER JOIN dim_fecha df ON f.departure_date_id = df.date_id
GROUP BY df.dia_semana, df.nombre_dia_semana
ORDER BY df.dia_semana;
GO



-- SECCIÓN 8: ANÁLISIS DE EQUIPAJE

-- 8.1 Distribución de equipaje

SELECT 
    bags_total AS Total_Maletas,
    COUNT(*) AS Total_Vuelos,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_vuelo) AS DECIMAL(5,2)) AS Porcentaje
FROM fact_vuelo
WHERE bags_total IS NOT NULL
GROUP BY bags_total
ORDER BY bags_total;
GO


-- 8.2 Promedio de equipaje por clase de cabina
SELECT 
    av.cabin_class AS Clase_Cabina,
    AVG(CAST(f.bags_total AS FLOAT)) AS Promedio_Maletas_Total,
    AVG(CAST(f.bags_checked AS FLOAT)) AS Promedio_Maletas_Documentadas
FROM fact_vuelo f
INNER JOIN dim_avion av ON f.aircraft_id = av.aircraft_id
WHERE f.bags_total IS NOT NULL
GROUP BY av.cabin_class
ORDER BY Promedio_Maletas_Total DESC;
GO



-- SECCIÓN 9: CONSULTAS COMPLEJAS

-- 9.1 Perfil del viajero frecuente

SELECT TOP 10
    p.passenger_id AS ID_Pasajero,
    CASE 
        WHEN p.gender = 'M' THEN 'Masculino'
        WHEN p.gender = 'F' THEN 'Femenino'
        ELSE 'Otro'
    END AS Genero,
    p.age AS Edad,
    p.nationality AS Nacionalidad,
    COUNT(*) AS Total_Vuelos,
    SUM(f.ticket_price_usd) AS Gasto_Total_USD,
    AVG(f.ticket_price_usd) AS Gasto_Promedio_USD
FROM fact_vuelo f
INNER JOIN dim_pasajero p ON f.passenger_key = p.passenger_key
GROUP BY p.passenger_id, p.gender, p.age, p.nationality
ORDER BY Total_Vuelos DESC;
GO


-- 9.2 Análisis de rentabilidad por ruta


SELECT TOP 10
    origen.airport_code AS Origen,
    destino.airport_code AS Destino,
    COUNT(*) AS Total_Vuelos,
    SUM(f.ticket_price_usd) AS Ingreso_Total_USD,
    AVG(f.ticket_price_usd) AS Precio_Promedio_USD,
    AVG(f.duration_min) AS Duracion_Promedio_Min
FROM fact_vuelo f
INNER JOIN dim_aeropuerto origen ON f.origin_airport_id = origen.airport_id
INNER JOIN dim_aeropuerto destino ON f.destination_airport_id = destino.airport_id
WHERE f.ticket_price_usd IS NOT NULL
GROUP BY origen.airport_code, destino.airport_code
ORDER BY Ingreso_Total_USD DESC;
GO

-- 9.3 Comparación de puntualidad por aerolínea
---------------------------------------';

SELECT 
    a.airline_code AS Codigo,
    a.airline_name AS Aerolinea,
    COUNT(*) AS Total_Vuelos,
    SUM(CASE WHEN f.status = 'ON_TIME' THEN 1 ELSE 0 END) AS Vuelos_A_Tiempo,
    SUM(CASE WHEN f.status = 'DELAYED' THEN 1 ELSE 0 END) AS Vuelos_Demorados,
    SUM(CASE WHEN f.status = 'CANCELLED' THEN 1 ELSE 0 END) AS Vuelos_Cancelados,
    CAST(SUM(CASE WHEN f.status = 'ON_TIME' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Porcentaje_Puntualidad
FROM fact_vuelo f
INNER JOIN dim_aerolinea a ON f.airline_id = a.airline_id
GROUP BY a.airline_code, a.airline_name
HAVING COUNT(*) >= 10  -- Solo aerolíneas con al menos 10 vuelos
ORDER BY Porcentaje_Puntualidad DESC;
GO
