
-- Script de Creación de Base de Datos - Modelo Multidimensional Vuelos
-- Práctica 1: ETL con Python
-- 201902246


-- Crear base de datos
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DW_Vuelos')
BEGIN
    CREATE DATABASE DW_Vuelos;
    PRINT 'Base de datos DW_Vuelos creada exitosamente';
END
ELSE
BEGIN
    PRINT 'La base de datos DW_Vuelos ya existe';
END
GO

USE DW_Vuelos;
GO

-- TABLAS DE DIMENSIONES


-- Dimensión: Aerolíneas
IF OBJECT_ID('dim_aerolinea', 'U') IS NOT NULL
    DROP TABLE dim_aerolinea;
GO

CREATE TABLE dim_aerolinea (
    airline_id INT IDENTITY(1,1) PRIMARY KEY,
    airline_code VARCHAR(10) NOT NULL UNIQUE,
    airline_name VARCHAR(100) NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    INDEX idx_airline_code (airline_code)
);
GO

-- Dimensión: Aeropuertos
IF OBJECT_ID('dim_aeropuerto', 'U') IS NOT NULL
    DROP TABLE dim_aeropuerto;
GO

CREATE TABLE dim_aeropuerto (
    airport_id INT IDENTITY(1,1) PRIMARY KEY,
    airport_code VARCHAR(10) NOT NULL UNIQUE,
    airport_name VARCHAR(100) NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    INDEX idx_airport_code (airport_code)
);
GO

-- Dimensión: Pasajeros
IF OBJECT_ID('dim_pasajero', 'U') IS NOT NULL
    DROP TABLE dim_pasajero;
GO

CREATE TABLE dim_pasajero (
    passenger_key INT IDENTITY(1,1) PRIMARY KEY,
    passenger_id VARCHAR(50) NOT NULL UNIQUE,
    gender VARCHAR(20) NULL,
    age INT NULL,
    nationality VARCHAR(10) NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    INDEX idx_passenger_id (passenger_id)
);
GO

-- Dimensión: Fecha
IF OBJECT_ID('dim_fecha', 'U') IS NOT NULL
    DROP TABLE dim_fecha;
GO

CREATE TABLE dim_fecha (
    date_id INT PRIMARY KEY,  -- Formato: YYYYMMDD
    fecha DATE NOT NULL UNIQUE,
    anio INT NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL,
    trimestre INT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    dia_semana INT NOT NULL,
    nombre_dia_semana VARCHAR(20) NOT NULL,
    es_fin_semana BIT NOT NULL,
    INDEX idx_fecha (fecha),
    INDEX idx_anio_mes (anio, mes)
);
GO

-- Dimensión: Tipo de Avión y Clase de Cabina
IF OBJECT_ID('dim_avion', 'U') IS NOT NULL
    DROP TABLE dim_avion;
GO

CREATE TABLE dim_avion (
    aircraft_id INT IDENTITY(1,1) PRIMARY KEY,
    aircraft_type VARCHAR(20) NOT NULL,
    cabin_class VARCHAR(30) NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    UNIQUE (aircraft_type, cabin_class),
    INDEX idx_aircraft_type (aircraft_type),
    INDEX idx_cabin_class (cabin_class)
);
GO


-- TABLA DE HECHOS


IF OBJECT_ID('fact_vuelo', 'U') IS NOT NULL
    DROP TABLE fact_vuelo;
GO

CREATE TABLE fact_vuelo (
    flight_id INT IDENTITY(1,1) PRIMARY KEY,
    record_id INT NOT NULL UNIQUE,
    
    -- Claves foráneas a dimensiones
    airline_id INT NOT NULL,
    origin_airport_id INT NOT NULL,
    destination_airport_id INT NOT NULL,
    passenger_key INT NOT NULL,
    aircraft_id INT NOT NULL,
    departure_date_id INT NULL,
    arrival_date_id INT NULL,
    booking_date_id INT NULL,
    
    -- Atributos del vuelo
    flight_number VARCHAR(20) NOT NULL,
    departure_datetime DATETIME NULL,
    arrival_datetime DATETIME NULL,
    duration_min INT NULL,
    status VARCHAR(20) NOT NULL,
    delay_min INT NULL,
    seat VARCHAR(10) NULL,
    
    -- Atributos de la reserva
    booking_datetime DATETIME NULL,
    sales_channel VARCHAR(30) NULL,
    payment_method VARCHAR(30) NULL,
    
    -- Métricas financieras
    ticket_price_usd DECIMAL(10,2) NULL,
    
    -- Equipaje
    bags_total INT NULL,
    bags_checked INT NULL,
    
    -- Auditoría
    fecha_carga DATETIME DEFAULT GETDATE(),
    
    -- Definir relaciones (Foreign Keys)
    FOREIGN KEY (airline_id) REFERENCES dim_aerolinea(airline_id),
    FOREIGN KEY (origin_airport_id) REFERENCES dim_aeropuerto(airport_id),
    FOREIGN KEY (destination_airport_id) REFERENCES dim_aeropuerto(airport_id),
    FOREIGN KEY (passenger_key) REFERENCES dim_pasajero(passenger_key),
    FOREIGN KEY (aircraft_id) REFERENCES dim_avion(aircraft_id),
    FOREIGN KEY (departure_date_id) REFERENCES dim_fecha(date_id),
    FOREIGN KEY (arrival_date_id) REFERENCES dim_fecha(date_id),
    FOREIGN KEY (booking_date_id) REFERENCES dim_fecha(date_id),
    
    -- Índices para mejorar el rendimiento
    INDEX idx_airline (airline_id),
    INDEX idx_origin_airport (origin_airport_id),
    INDEX idx_destination_airport (destination_airport_id),
    INDEX idx_passenger (passenger_key),
    INDEX idx_departure_date (departure_date_id),
    INDEX idx_status (status),
    INDEX idx_sales_channel (sales_channel)
);
GO


-- PROCEDIMIENTO PARA POPULAR DIMENSIÓN FECHA

-- Este procedimiento llena la tabla dim_fecha con fechas desde 2020 hasta 2030
CREATE OR ALTER PROCEDURE sp_populate_dim_fecha
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartDate DATE = '2020-01-01';
    DECLARE @EndDate DATE = '2030-12-31';
    DECLARE @CurrentDate DATE = @StartDate;
    
    -- Limpiar tabla si existe data
    TRUNCATE TABLE dim_fecha;
    
    WHILE @CurrentDate <= @EndDate
    BEGIN
        INSERT INTO dim_fecha (
            date_id,
            fecha,
            anio,
            mes,
            dia,
            trimestre,
            nombre_mes,
            dia_semana,
            nombre_dia_semana,
            es_fin_semana
        )
        VALUES (
            CONVERT(INT, FORMAT(@CurrentDate, 'yyyyMMdd')),
            @CurrentDate,
            YEAR(@CurrentDate),
            MONTH(@CurrentDate),
            DAY(@CurrentDate),
            DATEPART(QUARTER, @CurrentDate),
            DATENAME(MONTH, @CurrentDate),
            DATEPART(WEEKDAY, @CurrentDate),
            DATENAME(WEEKDAY, @CurrentDate),
            CASE WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) THEN 1 ELSE 0 END
        );
        
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END
    
    PRINT 'Dimensión dim_fecha poblada exitosamente';
END
GO

-- Ejecutar el procedimiento para poblar la dimensión fecha
EXEC sp_populate_dim_fecha;
GO



