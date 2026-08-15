-- ============================================================
-- Script:      01_DDL_DataWarehouse.sql
-- Descripcion: Creacion del Data Warehouse dimensional para SG-Food
-- Modelo:      Esquema estrella con 4 dimensiones y 2 tablas de hechos
-- Base:        DW_SGFood
-- ============================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DW_SGFood')
    DROP DATABASE [DW_SGFood];
GO

CREATE DATABASE [DW_SGFood];
GO

USE [DW_SGFood];
GO

-- ============================================================
-- DIMENSION: DimFecha
-- Descripcion: Dimension de tiempo para analisis por periodo
-- Granularidad: Un registro por dia del calendario
-- ============================================================
CREATE TABLE dbo.DimFecha (
    FechaKey INT NOT NULL, -- Clave natural en formato YYYYMMDD
    Fecha DATE NOT NULL,
    Anio INT NOT NULL,
    Semestre INT NOT NULL, -- 1 o 2
    Trimestre INT NOT NULL, -- 1, 2, 3 o 4
    Mes INT NOT NULL, -- 1 a 12
    NombreMes VARCHAR(20) NOT NULL,
    Semana INT NOT NULL, -- Numero de semana del anio
    DiaDelMes INT NOT NULL,
    DiaSemana INT NOT NULL, -- 1=Domingo, 7=Sabado
    NombreDia VARCHAR(20) NOT NULL,
    CONSTRAINT PK_DimFecha PRIMARY KEY (FechaKey)
);
GO

-- ============================================================
-- DIMENSION: DimProducto
-- Descripcion: Productos unificados de todas las fuentes
--              FabricanteA: LAC-001/002, SNK-001, ABA-001/003, CON-002
--              FabricanteB: BEB-001/002/003, SNK-002, ABA-002, CON-001
-- ============================================================
CREATE TABLE dbo.DimProducto (
    ProductoKey INT NOT NULL IDENTITY (1, 1),
    SKU VARCHAR(10) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    Subcategoria VARCHAR(50) NOT NULL,
    CostoUnitario DECIMAL(10, 4) NOT NULL,
    FabricanteOrigen VARCHAR(50) NOT NULL, -- DB_FabricanteA o DB_FabricanteB
    CONSTRAINT PK_DimProducto PRIMARY KEY (ProductoKey),
    CONSTRAINT UQ_DimProducto_SKU UNIQUE (SKU)
);
GO

-- ============================================================
-- DIMENSION: DimCliente
-- Descripcion: Clientes unificados de todas las fuentes
--              10 clientes: C-1001 a C-1010 en diferentes departamentos
-- ============================================================
CREATE TABLE dbo.DimCliente (
    ClienteKey INT NOT NULL IDENTITY (1, 1),
    ClienteId VARCHAR(10) NOT NULL,
    ClienteNombre VARCHAR(100) NOT NULL,
    Segmento VARCHAR(50) NULL, -- Supermercado, Tienda, HORECA, Mayorista, etc.
    Canal VARCHAR(50) NULL, -- Mayorista, Minorista, Institucional, Ecommerce
    Departamento VARCHAR(50) NULL,
    Municipio VARCHAR(50) NULL,
    CONSTRAINT PK_DimCliente PRIMARY KEY (ClienteKey),
    CONSTRAINT UQ_DimCliente_ClienteId UNIQUE (ClienteId)
);
GO

-- ============================================================
-- DIMENSION: DimFuente
-- Descripcion: Origen de cada registro para trazabilidad ETL
--              Permite identificar de cual sistema provino cada transaccion
-- ============================================================
CREATE TABLE dbo.DimFuente (
    FuenteKey INT NOT NULL IDENTITY (1, 1),
    NombreFuente VARCHAR(100) NOT NULL,
    TipoFuente VARCHAR(50) NOT NULL, -- BdDatos, ArchivoDelimitado
    Descripcion VARCHAR(200) NULL,
    CONSTRAINT PK_DimFuente PRIMARY KEY (FuenteKey)
);
GO

-- ============================================================
-- TABLA DE HECHOS: FactVentas
-- Descripcion: Transacciones de venta consolidadas de todas las fuentes
-- Granularidad: Una fila por transaccion individual de venta
-- Medidas:      CantidadVendida, PrecioUnitario, Descuento,
--               ImporteNeto, CostoUnitario, MargenBruto (calculado)
-- ============================================================
CREATE TABLE dbo.FactVentas (
    VentaKey INT NOT NULL IDENTITY (1, 1),
    FechaKey INT NOT NULL,
    ProductoKey INT NOT NULL,
    ClienteKey INT NOT NULL,
    FuenteKey INT NOT NULL,
    CantidadVendida INT NOT NULL,
    PrecioUnitario DECIMAL(10, 4) NOT NULL,
    Descuento DECIMAL(10, 4) NOT NULL DEFAULT 0,
    ImporteNeto DECIMAL(10, 4) NOT NULL,
    CostoUnitario DECIMAL(10, 4) NOT NULL, -- Denormalizado desde DimProducto al momento de carga
    MargenBruto AS (
        ImporteNeto - (
            CantidadVendida * CostoUnitario
        )
    ) PERSISTED,
    CONSTRAINT PK_FactVentas PRIMARY KEY (VentaKey),
    CONSTRAINT FK_FactVentas_Fecha FOREIGN KEY (FechaKey) REFERENCES dbo.DimFecha (FechaKey),
    CONSTRAINT FK_FactVentas_Producto FOREIGN KEY (ProductoKey) REFERENCES dbo.DimProducto (ProductoKey),
    CONSTRAINT FK_FactVentas_Cliente FOREIGN KEY (ClienteKey) REFERENCES dbo.DimCliente (ClienteKey),
    CONSTRAINT FK_FactVentas_Fuente FOREIGN KEY (FuenteKey) REFERENCES dbo.DimFuente (FuenteKey)
);
GO

-- ============================================================
-- TABLA DE HECHOS: FactInventario
-- Descripcion: Niveles de inventario diario por producto
--              Fuente: archivo inventario_externo.comp
-- Granularidad: Una fila por producto por dia
-- Medidas:      InventarioInicial, InventarioFinal, VariacionInventario (calculado)
-- ============================================================
CREATE TABLE dbo.FactInventario (
    InventarioKey INT NOT NULL IDENTITY (1, 1),
    FechaKey INT NOT NULL,
    ProductoKey INT NOT NULL,
    InventarioInicial INT NOT NULL,
    InventarioFinal INT NOT NULL,
    VariacionInventario AS (
        InventarioFinal - InventarioInicial
    ) PERSISTED,
    CONSTRAINT PK_FactInventario PRIMARY KEY (InventarioKey),
    CONSTRAINT FK_FactInventario_Fecha FOREIGN KEY (FechaKey) REFERENCES dbo.DimFecha (FechaKey),
    CONSTRAINT FK_FactInventario_Producto FOREIGN KEY (ProductoKey) REFERENCES dbo.DimProducto (ProductoKey)
);
GO

-- ============================================================
-- Indices adicionales para mejorar rendimiento en consultas analiticas
-- ============================================================
CREATE INDEX IX_FactVentas_Fecha ON dbo.FactVentas (FechaKey);

CREATE INDEX IX_FactVentas_Producto ON dbo.FactVentas (ProductoKey);

CREATE INDEX IX_FactVentas_Cliente ON dbo.FactVentas (ClienteKey);

CREATE INDEX IX_FactVentas_Fuente ON dbo.FactVentas (FuenteKey);

CREATE INDEX IX_FactInventario_Fecha ON dbo.FactInventario (FechaKey);

CREATE INDEX IX_FactInventario_Producto ON dbo.FactInventario (ProductoKey);
GO

PRINT 'DW_SGFood creado correctamente con 4 dimensiones y 2 tablas de hechos.';
GO