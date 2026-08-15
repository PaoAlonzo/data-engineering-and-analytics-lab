-- ============================================================
-- Script:      04_SP_Carga_DW.sql
-- Descripcion: Stored Procedures para cargar el Data Warehouse
--              desde las tablas de staging.
--              Orden de ejecucion:
--                1. SP_Cargar_DimFuente
--                2. SP_Cargar_DimProducto
--                3. SP_Cargar_DimCliente
--                4. SP_Cargar_FactVentas
--                5. SP_Cargar_FactInventario
-- Prerrequisito: Staging STG_SGFood ya tiene datos cargados por SSIS
-- ============================================================

USE DW_SGFood;
GO

-- ============================================================
-- SP 1: Cargar DimFuente
-- Descripcion: Inserta los 5 origenes de datos del proyecto.
--              Se ejecuta una sola vez; usa MERGE para evitar duplicados.
-- ============================================================
CREATE OR ALTER PROCEDURE dbo.SP_Cargar_DimFuente
AS
BEGIN
    SET NOCOUNT ON;

    MERGE dbo.DimFuente AS destino
    USING (
        VALUES
            ('DB_FabricanteA',   'BdDatos',           'Base transaccional del Fabricante A - lacteos, snacks y abarrotes'),
            ('DB_FabricanteB',   'BdDatos',           'Base transaccional del Fabricante B - bebidas, snacks y abarrotes'),
            ('SGFoodOLTP',       'BdDatos',           'Base transaccional SG-Food en servidor 34.63.26.98 (1000 registros)'),
            ('VentasExternas',   'ArchivoDelimitado', 'Archivo ventas_externas.vent delimitado por |'),
            ('InventarioExterno','ArchivoDelimitado', 'Archivo inventario_externo.comp delimitado por |')
    ) AS origen (NombreFuente, TipoFuente, Descripcion)
    ON destino.NombreFuente = origen.NombreFuente
    WHEN NOT MATCHED THEN
        INSERT (NombreFuente, TipoFuente, Descripcion)
        VALUES (origen.NombreFuente, origen.TipoFuente, origen.Descripcion);

    PRINT 'DimFuente cargada: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros nuevos.';
END;
GO

-- ============================================================
-- SP 2: Cargar DimProducto
-- Descripcion: Une los productos de Fabricante A y Fabricante B.
--              Usa MERGE para no duplicar SKUs ya existentes.
-- ============================================================
CREATE OR ALTER PROCEDURE dbo.SP_Cargar_DimProducto
AS
BEGIN
    SET NOCOUNT ON;

    -- Union de productos unicos de ambos fabricantes
    MERGE dbo.DimProducto AS destino
    USING (
        SELECT DISTINCT
            SKU,
            NomProducto,
            Marca,
            Categoria,
            Subcategoria,
            CostoUnitario,
            FuenteRegistro AS FabricanteOrigen
        FROM (
            SELECT SKU, NomProducto, Marca, Categoria, Subcategoria, CostoUnitario, FuenteRegistro
            FROM STG_SGFood.dbo.STG_VentasFabricanteA
            WHERE SKU IS NOT NULL

            UNION

            SELECT SKU, NomProducto, Marca, Categoria, Subcategoria, CostoUnitario, FuenteRegistro
            FROM STG_SGFood.dbo.STG_VentasFabricanteB
            WHERE SKU IS NOT NULL
        ) AS productos_union
    ) AS origen
    ON destino.SKU = origen.SKU
    WHEN NOT MATCHED THEN
        INSERT (SKU, Nombre, Marca, Categoria, Subcategoria, CostoUnitario, FabricanteOrigen)
        VALUES (origen.SKU, origen.NomProducto, origen.Marca, origen.Categoria,
                origen.Subcategoria, origen.CostoUnitario, origen.FabricanteOrigen);

    PRINT 'DimProducto cargada: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros nuevos.';
END;
GO

-- ============================================================
-- SP 3: Cargar DimCliente
-- Descripcion: Une los clientes de todas las fuentes disponibles.
--              Usa MERGE para no duplicar ClienteId ya existentes.
-- ============================================================
CREATE OR ALTER PROCEDURE dbo.SP_Cargar_DimCliente
AS
BEGIN
    SET NOCOUNT ON;

    MERGE dbo.DimCliente AS destino
    USING (
        SELECT DISTINCT
            ClienteId,
            ClienteNombre,
            Segmento,
            Canal,
            Departamento,
            Municipio
        FROM (
            SELECT ClienteId, ClienteNombre, Segmento, Canal, Departamento, Municipio
            FROM STG_SGFood.dbo.STG_VentasFabricanteA
            WHERE ClienteId IS NOT NULL

            UNION

            SELECT ClienteId, ClienteNombre, Segmento, Canal, Departamento, Municipio
            FROM STG_SGFood.dbo.STG_VentasFabricanteB
            WHERE ClienteId IS NOT NULL

            UNION

            SELECT ClienteId, ClienteNombre, Segmento, Canal, Departamento, Municipio
            FROM STG_SGFood.dbo.STG_VentasExternas
            WHERE ClienteId IS NOT NULL

            UNION

            SELECT ClienteId, ClienteNombre, SegmentoCliente AS Segmento, CanalVenta AS Canal, Departamento, Municipio
            FROM STG_SGFood.dbo.STG_VentasOLTP
            WHERE ClienteId IS NOT NULL
        ) AS clientes_union
    ) AS origen
    ON destino.ClienteId = origen.ClienteId
    WHEN NOT MATCHED THEN
        INSERT (ClienteId, ClienteNombre, Segmento, Canal, Departamento, Municipio)
        VALUES (origen.ClienteId, origen.ClienteNombre, origen.Segmento,
                origen.Canal, origen.Departamento, origen.Municipio);

    PRINT 'DimCliente cargada: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros nuevos.';
END;
GO

-- ============================================================
-- SP 4: Cargar FactVentas
-- Descripcion: Consolida ventas de las 4 fuentes, resuelve las
--              claves surrogate de las dimensiones y carga FactVentas.
--              Se calculan ImporteNeto y CostoUnitario al momento de carga.
-- ============================================================
CREATE OR ALTER PROCEDURE dbo.SP_Cargar_FactVentas
AS
BEGIN
    SET NOCOUNT ON;

    -- Ventas del Fabricante A
    INSERT INTO dbo.FactVentas (
        FechaKey, ProductoKey, ClienteKey, FuenteKey,
        CantidadVendida, PrecioUnitario, Descuento, ImporteNeto, CostoUnitario
    )
    SELECT
        f.FechaKey,
        p.ProductoKey,
        c.ClienteKey,
        fu.FuenteKey,
        s.CantidadVendida,
        s.PrecioUnitario,
        s.Descuento,
        s.ImporteNeto,
        p.CostoUnitario
    FROM STG_SGFood.dbo.STG_VentasFabricanteA s
    INNER JOIN dbo.DimFecha    f  ON f.FechaKey     = CONVERT(INT, FORMAT(s.Fecha, 'yyyyMMdd'))
    INNER JOIN dbo.DimProducto p  ON p.SKU           = s.SKU
    INNER JOIN dbo.DimCliente  c  ON c.ClienteId     = s.ClienteId
    INNER JOIN dbo.DimFuente   fu ON fu.NombreFuente = s.FuenteRegistro
    WHERE s.Fecha IS NOT NULL AND s.SKU IS NOT NULL AND s.ClienteId IS NOT NULL;

    DECLARE @InsertadosA INT = @@ROWCOUNT;

    -- Ventas del Fabricante B
    INSERT INTO dbo.FactVentas (
        FechaKey, ProductoKey, ClienteKey, FuenteKey,
        CantidadVendida, PrecioUnitario, Descuento, ImporteNeto, CostoUnitario
    )
    SELECT
        f.FechaKey,
        p.ProductoKey,
        c.ClienteKey,
        fu.FuenteKey,
        s.CantidadVendida,
        s.PrecioUnitario,
        s.Descuento,
        s.ImporteNeto,
        p.CostoUnitario
    FROM STG_SGFood.dbo.STG_VentasFabricanteB s
    INNER JOIN dbo.DimFecha    f  ON f.FechaKey     = CONVERT(INT, FORMAT(s.Fecha, 'yyyyMMdd'))
    INNER JOIN dbo.DimProducto p  ON p.SKU           = s.SKU
    INNER JOIN dbo.DimCliente  c  ON c.ClienteId     = s.ClienteId
    INNER JOIN dbo.DimFuente   fu ON fu.NombreFuente = s.FuenteRegistro
    WHERE s.Fecha IS NOT NULL AND s.SKU IS NOT NULL AND s.ClienteId IS NOT NULL;

    DECLARE @InsertadosB INT = @@ROWCOUNT;

    -- Ventas del OLTP remoto (SGFoodOLTP)
    -- Los nombres de columna usan los de la tabla real: FechaTransaccion, ProductoSKU.
    -- CostoUnitario se toma de DimProducto por JOIN en SKU.
    -- Si el SKU no existe en DimProducto el registro es ignorado por el INNER JOIN.
    INSERT INTO dbo.FactVentas (
        FechaKey, ProductoKey, ClienteKey, FuenteKey,
        CantidadVendida, PrecioUnitario, Descuento, ImporteNeto, CostoUnitario
    )
    SELECT
        f.FechaKey,
        p.ProductoKey,
        c.ClienteKey,
        fu.FuenteKey,
        s.CantidadVendida,
        s.PrecioUnitario,
        s.Descuento,
        ISNULL(s.ImporteNeto,
               (s.CantidadVendida * s.PrecioUnitario) - s.Descuento),
        p.CostoUnitario
    FROM STG_SGFood.dbo.STG_VentasOLTP s
    INNER JOIN dbo.DimFecha    f  ON f.FechaKey     = CONVERT(INT, FORMAT(s.FechaTransaccion, 'yyyyMMdd'))
    INNER JOIN dbo.DimProducto p  ON p.SKU           = s.ProductoSKU
    INNER JOIN dbo.DimCliente  c  ON c.ClienteId     = s.ClienteId
    INNER JOIN dbo.DimFuente   fu ON fu.NombreFuente = s.FuenteRegistro
    WHERE s.FechaTransaccion IS NOT NULL AND s.ProductoSKU IS NOT NULL AND s.ClienteId IS NOT NULL;

    DECLARE @InsertadosOLTP INT = @@ROWCOUNT;

    -- Ventas externas (.vent)
    -- ImporteNeto calculado como: (Cantidad * Precio) - Descuento
    INSERT INTO dbo.FactVentas (
        FechaKey, ProductoKey, ClienteKey, FuenteKey,
        CantidadVendida, PrecioUnitario, Descuento, ImporteNeto, CostoUnitario
    )
    SELECT
        f.FechaKey,
        p.ProductoKey,
        c.ClienteKey,
        fu.FuenteKey,
        s.CantidadVendida,
        s.PrecioUnitario,
        s.Descuento,
        (s.CantidadVendida * s.PrecioUnitario) - s.Descuento,
        p.CostoUnitario
    FROM STG_SGFood.dbo.STG_VentasExternas s
    INNER JOIN dbo.DimFecha    f  ON f.FechaKey     = CONVERT(INT, FORMAT(s.Fecha, 'yyyyMMdd'))
    INNER JOIN dbo.DimProducto p  ON p.SKU           = s.SKU
    INNER JOIN dbo.DimCliente  c  ON c.ClienteId     = s.ClienteId
    INNER JOIN dbo.DimFuente   fu ON fu.NombreFuente = s.FuenteRegistro
    WHERE s.Fecha IS NOT NULL AND s.SKU IS NOT NULL AND s.ClienteId IS NOT NULL;

    DECLARE @InsertadosVent INT = @@ROWCOUNT;

    PRINT 'FactVentas cargada:';
    PRINT '  FabricanteA : ' + CAST(@InsertadosA    AS VARCHAR) + ' registros';
    PRINT '  FabricanteB : ' + CAST(@InsertadosB    AS VARCHAR) + ' registros';
    PRINT '  SGFoodOLTP  : ' + CAST(@InsertadosOLTP AS VARCHAR) + ' registros';
    PRINT '  VentasExt.  : ' + CAST(@InsertadosVent AS VARCHAR) + ' registros';
    PRINT '  TOTAL       : ' + CAST(@InsertadosA + @InsertadosB + @InsertadosOLTP + @InsertadosVent AS VARCHAR) + ' registros';
END;
GO

-- ============================================================
-- SP 5: Cargar FactInventario
-- Descripcion: Carga niveles de inventario desde el staging del
--              archivo inventario_externo.comp.
--              Resuelve las claves surrogate de FechaKey y ProductoKey.
-- ============================================================
CREATE OR ALTER PROCEDURE dbo.SP_Cargar_FactInventario
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.FactInventario (
        FechaKey, ProductoKey,
        InventarioInicial, InventarioFinal
    )
    SELECT
        f.FechaKey,
        p.ProductoKey,
        s.InventarioInicial,
        s.InventarioFinal
    FROM STG_SGFood.dbo.STG_InventarioExterno s
    INNER JOIN dbo.DimFecha    f ON f.FechaKey = CONVERT(INT, FORMAT(s.Fecha, 'yyyyMMdd'))
    INNER JOIN dbo.DimProducto p ON p.SKU      = s.SKU
    WHERE s.Fecha IS NOT NULL AND s.SKU IS NOT NULL;

    PRINT 'FactInventario cargada: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros.';
END;
GO

-- ============================================================
-- Procedimiento maestro: ejecutar toda la carga en orden correcto
-- ============================================================
CREATE OR ALTER PROCEDURE dbo.SP_Ejecutar_Carga_Completa
AS
BEGIN
    SET NOCOUNT ON;
    PRINT '=== Inicio carga Data Warehouse DW_SGFood ===';
    PRINT CAST(GETDATE() AS VARCHAR);

    EXEC dbo.SP_Cargar_DimFuente;
    EXEC dbo.SP_Cargar_DimProducto;
    EXEC dbo.SP_Cargar_DimCliente;
    EXEC dbo.SP_Cargar_FactVentas;
    EXEC dbo.SP_Cargar_FactInventario;

    PRINT '=== Carga completada ===';
    PRINT CAST(GETDATE() AS VARCHAR);
END;
GO

PRINT 'Stored Procedures de carga DW creados correctamente.';
GO