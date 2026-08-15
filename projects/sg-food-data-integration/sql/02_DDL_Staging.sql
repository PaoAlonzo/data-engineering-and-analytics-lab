-- ============================================================
-- Script:      02_DDL_Staging.sql
-- Descripcion: Creacion del area de staging (STG_SGFood) para el proceso ETL
--              SSIS cargara los datos de cada fuente a estas tablas antes
--              de transformarlos y cargarlos al Data Warehouse.
-- Base:        STG_SGFood
-- ============================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'STG_SGFood')
    DROP DATABASE [STG_SGFood];
GO

CREATE DATABASE [STG_SGFood];
GO

USE [STG_SGFood];
GO

-- ============================================================
-- STAGING: STG_VentasFabricanteA
-- Fuente: DB_FabricanteA (local SQL Server)
-- Query SSIS: JOIN de Ventas + Clientes + Productos
-- ============================================================
CREATE TABLE dbo.STG_VentasFabricanteA (
    STG_Id INT NOT NULL IDENTITY (1, 1),
    FuenteRegistro VARCHAR(50) NOT NULL DEFAULT 'DB_FabricanteA',
    Fecha DATE NULL,
    ClienteId VARCHAR(10) NULL,
    ClienteNombre VARCHAR(100) NULL,
    Segmento VARCHAR(50) NULL,
    Canal VARCHAR(50) NULL,
    Departamento VARCHAR(50) NULL,
    Municipio VARCHAR(50) NULL,
    SKU VARCHAR(10) NULL,
    NomProducto VARCHAR(100) NULL,
    Marca VARCHAR(50) NULL,
    Categoria VARCHAR(50) NULL,
    Subcategoria VARCHAR(50) NULL,
    CostoUnitario DECIMAL(10, 4) NULL,
    CantidadVendida INT NULL,
    PrecioUnitario DECIMAL(10, 4) NULL,
    Descuento DECIMAL(10, 4) NULL,
    ImporteNeto DECIMAL(10, 4) NULL,
    FechaStaging DATETIME NOT NULL DEFAULT GETDATE (),
    CONSTRAINT PK_STG_VentasFabricanteA PRIMARY KEY (STG_Id)
);
GO

-- ============================================================
-- STAGING: STG_VentasFabricanteB
-- Fuente: DB_FabricanteB (local SQL Server)
-- Query SSIS: JOIN de Ventas + Clientes + Productos
-- ============================================================
CREATE TABLE dbo.STG_VentasFabricanteB (
    STG_Id INT NOT NULL IDENTITY (1, 1),
    FuenteRegistro VARCHAR(50) NOT NULL DEFAULT 'DB_FabricanteB',
    Fecha DATE NULL,
    ClienteId VARCHAR(10) NULL,
    ClienteNombre VARCHAR(100) NULL,
    Segmento VARCHAR(50) NULL,
    Canal VARCHAR(50) NULL,
    Departamento VARCHAR(50) NULL,
    Municipio VARCHAR(50) NULL,
    SKU VARCHAR(10) NULL,
    NomProducto VARCHAR(100) NULL,
    Marca VARCHAR(50) NULL,
    Categoria VARCHAR(50) NULL,
    Subcategoria VARCHAR(50) NULL,
    CostoUnitario DECIMAL(10, 4) NULL,
    CantidadVendida INT NULL,
    PrecioUnitario DECIMAL(10, 4) NULL,
    Descuento DECIMAL(10, 4) NULL,
    ImporteNeto DECIMAL(10, 4) NULL,
    FechaStaging DATETIME NOT NULL DEFAULT GETDATE (),
    CONSTRAINT PK_STG_VentasFabricanteB PRIMARY KEY (STG_Id)
);
GO

-- ============================================================
-- STAGING: STG_VentasOLTP
-- Fuente: SGFoodOLTP.dbo.TransaccionesVenta (servidor 34.63.26.98)
-- Columnas verificadas el 2026-04-08 contra la tabla real.
-- La tabla OLTP tiene 1000 registros y esta desnormalizada:
-- incluye datos de cliente, producto e inventario por transaccion.
-- ============================================================
CREATE TABLE dbo.STG_VentasOLTP (
    STG_Id INT NOT NULL IDENTITY (1, 1),
    FuenteRegistro VARCHAR(50) NOT NULL DEFAULT 'SGFoodOLTP',
    -- Campos de fecha y cliente (nombres reales de la fuente)
    FechaTransaccion DATE NULL,
    ClienteId VARCHAR(20) NULL,
    ClienteNombre VARCHAR(120) NULL,
    SegmentoCliente VARCHAR(40) NULL,
    CanalVenta VARCHAR(30) NULL,
    Departamento VARCHAR(60) NULL,
    Municipio VARCHAR(60) NULL,
    -- Campos de producto
    ProductoSKU VARCHAR(20) NULL,
    ProductoNombre VARCHAR(120) NULL,
    Marca VARCHAR(60) NULL,
    Categoria VARCHAR(60) NULL,
    Subcategoria VARCHAR(60) NULL,
    Fabricante VARCHAR(60) NULL,
    -- Medidas de venta
    CantidadVendida INT NULL,
    PrecioUnitario DECIMAL(10, 4) NULL,
    Descuento DECIMAL(10, 4) NULL,
    ImporteNeto DECIMAL(10, 4) NULL,
    -- Medidas de inventario embebidas en la tabla OLTP
    ExistenciaAntesVenta INT NULL,
    ExistenciasDespuesVenta INT NULL,
    FechaStaging DATETIME NOT NULL DEFAULT GETDATE (),
    CONSTRAINT PK_STG_VentasOLTP PRIMARY KEY (STG_Id)
);
GO

-- ============================================================
-- STAGING: STG_VentasExternas
-- Fuente: ventas_externas.vent (archivo delimitado por "|")
-- Columnas fuente: Fecha|CodCliente|NomCliente|Segmento|Canal|
--                  Departamento|Municipio|SKU|Cantidad|PrecioUnitario|Descuento
-- ============================================================
CREATE TABLE dbo.STG_VentasExternas (
    STG_Id INT NOT NULL IDENTITY (1, 1),
    FuenteRegistro VARCHAR(50) NOT NULL DEFAULT 'VentasExternas',
    Fecha DATE NULL,
    ClienteId VARCHAR(10) NULL,
    ClienteNombre VARCHAR(100) NULL,
    Segmento VARCHAR(50) NULL,
    Canal VARCHAR(50) NULL,
    Departamento VARCHAR(50) NULL,
    Municipio VARCHAR(50) NULL,
    SKU VARCHAR(10) NULL,
    CantidadVendida INT NULL,
    PrecioUnitario DECIMAL(10, 4) NULL,
    Descuento DECIMAL(10, 4) NULL,
    FechaStaging DATETIME NOT NULL DEFAULT GETDATE (),
    CONSTRAINT PK_STG_VentasExternas PRIMARY KEY (STG_Id)
);
GO

-- ============================================================
-- STAGING: STG_InventarioExterno
-- Fuente: inventario_externo.comp (archivo delimitado por "|")
-- Columnas fuente: Fecha|SKU|NomProducto|InventarioInicial|InventarioFinal
-- ============================================================
CREATE TABLE dbo.STG_InventarioExterno (
    STG_Id INT NOT NULL IDENTITY (1, 1),
    FuenteRegistro VARCHAR(50) NOT NULL DEFAULT 'InventarioExterno',
    Fecha DATE NULL,
    SKU VARCHAR(10) NULL,
    NomProducto VARCHAR(100) NULL,
    InventarioInicial INT NULL,
    InventarioFinal INT NULL,
    FechaStaging DATETIME NOT NULL DEFAULT GETDATE (),
    CONSTRAINT PK_STG_InventarioExterno PRIMARY KEY (STG_Id)
);
GO

PRINT 'STG_SGFood creado correctamente con 5 tablas de staging.';
GO