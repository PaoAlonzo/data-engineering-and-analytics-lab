-- ============================================================
-- Script:      05_Validaciones.sql
-- Descripcion: Consultas de validacion para verificar la carga
--              correcta del Data Warehouse y la integridad de datos.
-- Orden:       Ejecutar despues del proceso ETL completo.
-- ============================================================

USE DW_SGFood;
GO

-- ============================================================
-- SECCION 1: Conteo de registros en staging
-- Permite verificar que SSIS cargo correctamente las fuentes
-- ============================================================
PRINT '--- STAGING: Conteo de registros por fuente ---';

SELECT 'STG_VentasFabricanteA' AS Tabla, COUNT(*) AS Total
FROM STG_SGFood.dbo.STG_VentasFabricanteA
UNION ALL
SELECT 'STG_VentasFabricanteB', COUNT(*)
FROM STG_SGFood.dbo.STG_VentasFabricanteB
UNION ALL
SELECT 'STG_VentasOLTP', COUNT(*)
FROM STG_SGFood.dbo.STG_VentasOLTP
UNION ALL
SELECT 'STG_VentasExternas', COUNT(*)
FROM STG_SGFood.dbo.STG_VentasExternas
UNION ALL
SELECT 'STG_InventarioExterno', COUNT(*)
FROM STG_SGFood.dbo.STG_InventarioExterno
ORDER BY Tabla;
GO

-- ============================================================
-- SECCION 2: Conteo de registros en dimensiones del DW
-- ============================================================
PRINT '--- DW: Conteo de registros en dimensiones ---';

SELECT 'DimFecha' AS Dimension, COUNT(*) AS TotalRegistros
FROM dbo.DimFecha
UNION ALL
SELECT 'DimProducto', COUNT(*)
FROM dbo.DimProducto
UNION ALL
SELECT 'DimCliente', COUNT(*)
FROM dbo.DimCliente
UNION ALL
SELECT 'DimFuente', COUNT(*)
FROM dbo.DimFuente
ORDER BY Dimension;
GO

-- ============================================================
-- SECCION 3: Conteo de registros en tablas de hechos
-- ============================================================
PRINT '--- DW: Conteo de registros en tablas de hechos ---';

SELECT 'FactVentas' AS TablaHechos, COUNT(*) AS TotalRegistros
FROM dbo.FactVentas
UNION ALL
SELECT 'FactInventario', COUNT(*)
FROM dbo.FactInventario
ORDER BY TablaHechos;
GO

-- ============================================================
-- SECCION 4: Validacion de integridad referencial
-- Verifica que no existan huerfanos en las tablas de hechos
-- (registros en hechos sin correspondencia en dimensiones)
-- ============================================================
PRINT '--- INTEGRIDAD: FechaKey huerfanos en FactVentas ---';

SELECT COUNT(*) AS Huerfanos_FechaKey
FROM dbo.FactVentas fv
    LEFT JOIN dbo.DimFecha d ON fv.FechaKey = d.FechaKey
WHERE
    d.FechaKey IS NULL;

PRINT '--- INTEGRIDAD: ProductoKey huerfanos en FactVentas ---';

SELECT COUNT(*) AS Huerfanos_ProductoKey
FROM dbo.FactVentas fv
    LEFT JOIN dbo.DimProducto p ON fv.ProductoKey = p.ProductoKey
WHERE
    p.ProductoKey IS NULL;

PRINT '--- INTEGRIDAD: ClienteKey huerfanos en FactVentas ---';

SELECT COUNT(*) AS Huerfanos_ClienteKey
FROM dbo.FactVentas fv
    LEFT JOIN dbo.DimCliente c ON fv.ClienteKey = c.ClienteKey
WHERE
    c.ClienteKey IS NULL;

PRINT '--- INTEGRIDAD: ProductoKey huerfanos en FactInventario ---';

SELECT COUNT(*) AS Huerfanos_ProductoKey
FROM dbo.FactInventario fi
    LEFT JOIN dbo.DimProducto p ON fi.ProductoKey = p.ProductoKey
WHERE
    p.ProductoKey IS NULL;
GO

-- ============================================================
-- SECCION 5: Validacion de datos nulos en hechos
-- Los campos clave no deben tener valores nulos
-- ============================================================
PRINT '--- CALIDAD: Nulos en FactVentas ---';

SELECT
    SUM(
        CASE
            WHEN FechaKey IS NULL THEN 1
            ELSE 0
        END
    ) AS Nulos_FechaKey,
    SUM(
        CASE
            WHEN ProductoKey IS NULL THEN 1
            ELSE 0
        END
    ) AS Nulos_ProductoKey,
    SUM(
        CASE
            WHEN ClienteKey IS NULL THEN 1
            ELSE 0
        END
    ) AS Nulos_ClienteKey,
    SUM(
        CASE
            WHEN CantidadVendida IS NULL THEN 1
            ELSE 0
        END
    ) AS Nulos_Cantidad,
    SUM(
        CASE
            WHEN ImporteNeto IS NULL THEN 1
            ELSE 0
        END
    ) AS Nulos_ImporteNeto
FROM dbo.FactVentas;

PRINT '--- CALIDAD: ImporteNeto negativo en FactVentas ---';

SELECT
    COUNT(*) AS Registros_ImporteNeto_Negativo
FROM dbo.FactVentas
WHERE
    ImporteNeto < 0;

PRINT '--- CALIDAD: CantidadVendida menor o igual a cero ---';

SELECT COUNT(*) AS Registros_Cantidad_Invalida
FROM dbo.FactVentas
WHERE
    CantidadVendida <= 0;
GO

-- ============================================================
-- SECCION 6: Distribucion de ventas por fuente
-- Confirma que cada fuente aportó registros al DW
-- ============================================================
PRINT '--- DISTRIBUCION: Registros en FactVentas por fuente ---';

SELECT
    fu.NombreFuente,
    fu.TipoFuente,
    COUNT(fv.VentaKey) AS TotalTransacciones,
    SUM(fv.CantidadVendida) AS TotalUnidades,
    SUM(fv.ImporteNeto) AS TotalImporte
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimFuente fu ON fv.FuenteKey = fu.FuenteKey
GROUP BY
    fu.NombreFuente,
    fu.TipoFuente
ORDER BY TotalImporte DESC;
GO

-- ============================================================
-- SECCION 7: Productos cargados en DimProducto
-- Verifica los 12 SKUs esperados de ambos fabricantes
-- ============================================================
PRINT '--- CATALOGO: Productos en DimProducto ---';

SELECT
    SKU,
    Nombre,
    Marca,
    Categoria,
    Subcategoria,
    CostoUnitario,
    FabricanteOrigen
FROM dbo.DimProducto
ORDER BY Categoria, Subcategoria, SKU;
GO

-- ============================================================
-- SECCION 8: Clientes cargados en DimCliente
-- Verifica los 10 clientes esperados
-- ============================================================
PRINT '--- CATALOGO: Clientes en DimCliente ---';

SELECT
    ClienteId,
    ClienteNombre,
    Segmento,
    Canal,
    Departamento,
    Municipio
FROM dbo.DimCliente
ORDER BY ClienteId;
GO

-- ============================================================
-- SECCION 9: Rango de fechas en FactVentas
-- Verifica que el rango de fechas sea el esperado
-- ============================================================
PRINT '--- RANGO: Fechas cubiertas en FactVentas ---';

SELECT
    MIN(d.Fecha) AS FechaMasAntigua,
    MAX(d.Fecha) AS FechaMasReciente,
    COUNT(DISTINCT d.Fecha) AS DiasDistintos,
    MIN(d.Anio) AS AnioMinimo,
    MAX(d.Anio) AS AnioMaximo
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimFecha d ON fv.FechaKey = d.FechaKey;
GO

-- ============================================================
-- SECCION 10: Resumen ejecutivo de la carga
-- Vista rapida del estado general del DW
-- ============================================================
PRINT '--- RESUMEN EJECUTIVO ---';

SELECT (
        SELECT COUNT(*)
        FROM dbo.DimFecha
    ) AS DimFecha_Registros,
    (
        SELECT COUNT(*)
        FROM dbo.DimProducto
    ) AS DimProducto_Registros,
    (
        SELECT COUNT(*)
        FROM dbo.DimCliente
    ) AS DimCliente_Registros,
    (
        SELECT COUNT(*)
        FROM dbo.DimFuente
    ) AS DimFuente_Registros,
    (
        SELECT COUNT(*)
        FROM dbo.FactVentas
    ) AS FactVentas_Registros,
    (
        SELECT COUNT(*)
        FROM dbo.FactInventario
    ) AS FactInventario_Registros,
    (
        SELECT SUM(ImporteNeto)
        FROM dbo.FactVentas
    ) AS ImporteTotal_DW;
GO