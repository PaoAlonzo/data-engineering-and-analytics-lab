-- ============================================================
-- Script:      03_SP_Poblar_DimFecha.sql
-- Descripcion: Pobla la dimension de tiempo DimFecha con un
--              rango de fechas dado. Se ejecuta una sola vez
--              antes de cargar los hechos.
-- Rango:       2025-01-01 hasta 2027-12-31
-- ============================================================

USE DW_SGFood;
GO

-- Eliminar registros existentes antes de repoblar
TRUNCATE TABLE dbo.DimFecha;
GO

-- Poblar DimFecha con bucle diario
DECLARE @FechaInicio DATE = '2025-01-01';
DECLARE @FechaFin    DATE = '2027-12-31';
DECLARE @Fecha       DATE = @FechaInicio;

WHILE @Fecha <= @FechaFin
BEGIN
    INSERT INTO dbo.DimFecha (
        FechaKey,
        Fecha,
        Anio,
        Semestre,
        Trimestre,
        Mes,
        NombreMes,
        Semana,
        DiaDelMes,
        DiaSemana,
        NombreDia
    )
    VALUES (
        CONVERT(INT, FORMAT(@Fecha, 'yyyyMMdd')),   -- Ej: 20260331
        @Fecha,
        YEAR(@Fecha),
        CASE WHEN MONTH(@Fecha) <= 6 THEN 1 ELSE 2 END,
        DATEPART(QUARTER, @Fecha),
        MONTH(@Fecha),
        DATENAME(MONTH, @Fecha),
        DATEPART(WEEK, @Fecha),
        DAY(@Fecha),
        DATEPART(WEEKDAY, @Fecha),                  -- 1=Domingo, 7=Sabado
        DATENAME(WEEKDAY, @Fecha)
    );

    SET @Fecha = DATEADD(DAY, 1, @Fecha);
END;

DECLARE @TotalFechas INT = (
    SELECT COUNT(*)
    FROM dbo.DimFecha
);

PRINT 'DimFecha poblada con ' + CAST(@TotalFechas AS VARCHAR) + ' registros.';