-- ============================================================
-- Script:      06_Consultas_Analiticas.sql
-- Descripcion: Consultas analiticas sobre el Data Warehouse.
--              Estas consultas simulan lo que el modelo SSAS
--              expone a herramientas de reporte como Excel o Power BI.
-- Prerrequisito: DW_SGFood debe tener datos cargados.
-- ============================================================

USE DW_SGFood;
GO

-- ============================================================
-- CONSULTA 1: Ventas totales por mes y anio
-- Jerarquia de tiempo: Anio > Mes
-- ============================================================
SELECT
    d.Anio,
    d.Mes,
    d.NombreMes,
    COUNT(fv.VentaKey) AS NumTransacciones,
    SUM(fv.CantidadVendida) AS TotalUnidades,
    SUM(fv.ImporteNeto) AS TotalVentas,
    SUM(fv.MargenBruto) AS TotalMargen
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimFecha d ON fv.FechaKey = d.FechaKey
GROUP BY
    d.Anio,
    d.Mes,
    d.NombreMes
ORDER BY d.Anio, d.Mes;
GO

-- ============================================================
-- CONSULTA 2: Ventas por categoria y subcategoria de producto
-- Jerarquia de producto: Categoria > Subcategoria > SKU
-- ============================================================
SELECT
    p.Categoria,
    p.Subcategoria,
    p.SKU,
    p.Nombre,
    p.Marca,
    COUNT(fv.VentaKey) AS NumTransacciones,
    SUM(fv.CantidadVendida) AS TotalUnidades,
    SUM(fv.ImporteNeto) AS TotalVentas,
    SUM(fv.MargenBruto) AS TotalMargen,
    AVG(fv.PrecioUnitario) AS PrecioPromedio
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimProducto p ON fv.ProductoKey = p.ProductoKey
GROUP BY
    p.Categoria,
    p.Subcategoria,
    p.SKU,
    p.Nombre,
    p.Marca
ORDER BY TotalVentas DESC;
GO

-- ============================================================
-- CONSULTA 3: Ventas por canal y segmento de cliente
-- Jerarquia de cliente: Segmento > Canal > Cliente
-- ============================================================
SELECT
    c.Segmento,
    c.Canal,
    c.ClienteId,
    c.ClienteNombre,
    c.Departamento,
    c.Municipio,
    COUNT(fv.VentaKey) AS NumTransacciones,
    SUM(fv.CantidadVendida) AS TotalUnidades,
    SUM(fv.ImporteNeto) AS TotalVentas,
    SUM(fv.MargenBruto) AS TotalMargen
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimCliente c ON fv.ClienteKey = c.ClienteKey
GROUP BY
    c.Segmento,
    c.Canal,
    c.ClienteId,
    c.ClienteNombre,
    c.Departamento,
    c.Municipio
ORDER BY TotalVentas DESC;
GO

-- ============================================================
-- CONSULTA 4: Ventas por departamento geografico
-- Jerarquia geografica: Departamento > Municipio
-- ============================================================
SELECT
    c.Departamento,
    c.Municipio,
    COUNT(fv.VentaKey) AS NumTransacciones,
    SUM(fv.CantidadVendida) AS TotalUnidades,
    SUM(fv.ImporteNeto) AS TotalVentas
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimCliente c ON fv.ClienteKey = c.ClienteKey
GROUP BY
    c.Departamento,
    c.Municipio
ORDER BY c.Departamento, TotalVentas DESC;
GO

-- ============================================================
-- CONSULTA 5: Cruce Tiempo x Producto (matriz analitica)
-- Ventas por mes y categoria (vista de cubo OLAP)
-- ============================================================
SELECT
    d.Anio,
    d.NombreMes,
    p.Categoria,
    SUM(fv.ImporteNeto) AS TotalVentas,
    SUM(fv.CantidadVendida) AS TotalUnidades
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimFecha d ON fv.FechaKey = d.FechaKey
    INNER JOIN dbo.DimProducto p ON fv.ProductoKey = p.ProductoKey
GROUP BY
    d.Anio,
    d.Mes,
    d.NombreMes,
    p.Categoria
ORDER BY d.Anio, d.Mes, p.Categoria;
GO

-- ============================================================
-- CONSULTA 6: Top 5 productos por importe de venta
-- ============================================================
SELECT
    TOP 5 p.SKU,
    p.Nombre,
    p.Marca,
    p.Categoria,
    SUM(fv.ImporteNeto) AS TotalVentas,
    SUM(fv.CantidadVendida) AS TotalUnidades,
    SUM(fv.MargenBruto) AS TotalMargen
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimProducto p ON fv.ProductoKey = p.ProductoKey
GROUP BY
    p.SKU,
    p.Nombre,
    p.Marca,
    p.Categoria
ORDER BY TotalVentas DESC;
GO

-- ============================================================
-- CONSULTA 7: Comparativo de ventas por fuente de datos
-- Permite ver la contribucion de cada sistema fuente
-- ============================================================
SELECT
    fu.NombreFuente,
    fu.TipoFuente,
    COUNT(fv.VentaKey) AS NumTransacciones,
    SUM(fv.CantidadVendida) AS TotalUnidades,
    SUM(fv.ImporteNeto) AS TotalVentas,
    ROUND(
        100.0 * SUM(fv.ImporteNeto) / SUM(SUM(fv.ImporteNeto)) OVER (),
        2
    ) AS PorcentajeDelTotal
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimFuente fu ON fv.FuenteKey = fu.FuenteKey
GROUP BY
    fu.NombreFuente,
    fu.TipoFuente
ORDER BY TotalVentas DESC;
GO

-- ============================================================
-- CONSULTA 8: Analisis de inventario por producto
-- Rotacion y variacion de inventario desde el archivo .comp
-- ============================================================
SELECT
    p.SKU,
    p.Nombre,
    p.Categoria,
    COUNT(fi.InventarioKey) AS DiasConRegistro,
    AVG(fi.InventarioInicial) AS InventarioPromedioInicio,
    AVG(fi.InventarioFinal) AS InventarioPromedioFin,
    MIN(fi.InventarioFinal) AS StockMinimo,
    MAX(fi.InventarioFinal) AS StockMaximo,
    SUM(fi.VariacionInventario) AS VariacionAcumulada
FROM dbo.FactInventario fi
    INNER JOIN dbo.DimProducto p ON fi.ProductoKey = p.ProductoKey
GROUP BY
    p.SKU,
    p.Nombre,
    p.Categoria
ORDER BY p.Categoria, p.SKU;
GO

-- ============================================================
-- CONSULTA 9: Cruce Ventas vs Inventario por producto
-- Relaciona el importe vendido con el stock promedio disponible
-- ============================================================
SELECT
    p.SKU,
    p.Nombre,
    p.Categoria,
    ISNULL(SUM(fv.CantidadVendida), 0) AS UnidadesVendidas,
    ISNULL(SUM(fv.ImporteNeto), 0) AS ImporteVendido,
    ISNULL(AVG(fi.InventarioFinal), 0) AS StockPromedioFinal
FROM dbo.DimProducto p
    LEFT JOIN dbo.FactVentas fv ON p.ProductoKey = fv.ProductoKey
    LEFT JOIN dbo.FactInventario fi ON p.ProductoKey = fi.ProductoKey
GROUP BY
    p.SKU,
    p.Nombre,
    p.Categoria
ORDER BY ImporteVendido DESC;
GO

-- ============================================================
-- CONSULTA 10: Ventas por trimestre y fabricante de origen
-- Jerarquia: Anio > Trimestre; Agrupacion: FabricanteOrigen
-- ============================================================
SELECT
    d.Anio,
    d.Trimestre,
    p.FabricanteOrigen,
    SUM(fv.ImporteNeto) AS TotalVentas,
    SUM(fv.CantidadVendida) AS TotalUnidades,
    COUNT(fv.VentaKey) AS NumTransacciones
FROM dbo.FactVentas fv
    INNER JOIN dbo.DimFecha d ON fv.FechaKey = d.FechaKey
    INNER JOIN dbo.DimProducto p ON fv.ProductoKey = p.ProductoKey
GROUP BY
    d.Anio,
    d.Trimestre,
    p.FabricanteOrigen
ORDER BY d.Anio, d.Trimestre, p.FabricanteOrigen;
GO