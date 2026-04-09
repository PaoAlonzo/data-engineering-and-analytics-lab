-- ============================================================
-- Base de datos fuente: DB_FabricanteA
-- Fabricante A: datos transaccionales de ventas
-- ============================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DB_FabricanteA')
    DROP DATABASE [DB_FabricanteA];
GO

CREATE DATABASE [DB_FabricanteA];
GO

USE [DB_FabricanteA];
GO

-- Tabla de Productos
CREATE TABLE Productos (
    SKU             VARCHAR(10)     NOT NULL PRIMARY KEY,
    Nombre          VARCHAR(100)    NOT NULL,
    Marca           VARCHAR(50)     NOT NULL,
    Categoria       VARCHAR(50)     NOT NULL,
    Subcategoria    VARCHAR(50)     NOT NULL,
    CostoUnitario   DECIMAL(10,4)   NOT NULL
);
GO

-- Tabla de Clientes
CREATE TABLE Clientes (
    ClienteId       VARCHAR(10)     NOT NULL PRIMARY KEY,
    ClienteNombre   VARCHAR(100)    NOT NULL,
    Segmento        VARCHAR(50),
    Canal           VARCHAR(50),
    Departamento    VARCHAR(50),
    Municipio       VARCHAR(50)
);
GO

-- Tabla de Ventas
CREATE TABLE Ventas (
    VentaId         INT             NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Fecha           DATE            NOT NULL,
    ClienteId       VARCHAR(10)     NOT NULL REFERENCES Clientes(ClienteId),
    SKU             VARCHAR(10)     NOT NULL REFERENCES Productos(SKU),
    CantidadVendida INT             NOT NULL,
    PrecioUnitario  DECIMAL(10,4)   NOT NULL,
    Descuento       DECIMAL(10,4)   NOT NULL DEFAULT 0,
    ImporteNeto     DECIMAL(10,4)   NOT NULL
);
GO

-- Insertar Productos
INSERT INTO Productos VALUES ('LAC-001', 'Leche Entera 1L', 'LactoPlus', 'Lacteos', 'Leche', 6.1000);
INSERT INTO Productos VALUES ('LAC-002', 'Yogurt Fresa 200ml', 'LactoPlus', 'Lacteos', 'Yogurt', 3.0500);
INSERT INTO Productos VALUES ('SNK-001', 'Papas Clasicas 45g', 'Crunchy', 'Snacks', 'Papas', 2.4000);
INSERT INTO Productos VALUES ('ABA-001', 'Arroz 5lb', 'GranoFino', 'Abarrotes', 'Granos', 18.4000);
INSERT INTO Productos VALUES ('ABA-003', 'Aceite 1L', 'CocinaMax', 'Abarrotes', 'Aceites', 12.2000);
INSERT INTO Productos VALUES ('CON-002', 'Salsa Tomate 400g', 'CasaRoja', 'Abarrotes', 'Salsas', 4.2000);
GO

-- Insertar Clientes
INSERT INTO Clientes VALUES ('C-1001', 'Super Mercado Central', 'Supermercado', 'Mayorista', 'Guatemala', 'Guatemala');
INSERT INTO Clientes VALUES ('C-1002', 'Tienda La Esquina', 'Tienda', 'Minorista', 'Guatemala', 'Mixco');
INSERT INTO Clientes VALUES ('C-1005', 'Market Online GT', 'Online', 'Ecommerce', 'Guatemala', 'Guatemala');
INSERT INTO Clientes VALUES ('C-1007', 'Distribuidora Norte', 'Mayorista', 'Mayorista', 'Alta Verapaz', 'Coban');
INSERT INTO Clientes VALUES ('C-1009', 'Comedor Universitario', 'Institucional', 'Institucional', 'Guatemala', 'Guatemala');
INSERT INTO Clientes VALUES ('C-1003', 'Hotel Mirador', 'HORECA', 'Institucional', 'Sacatepequez', 'Antigua Guatemala');
INSERT INTO Clientes VALUES ('C-1004', 'Restaurante El Buen Sabor', 'HORECA', 'Institucional', 'Guatemala', 'Villa Nueva');
INSERT INTO Clientes VALUES ('C-1006', 'MiniMarket Los Pinos', 'Tienda', 'Minorista', 'Quetzaltenango', 'Quetzaltenango');
INSERT INTO Clientes VALUES ('C-1008', 'Super Ahorro Xela', 'Supermercado', 'Mayorista', 'Quetzaltenango', 'Quetzaltenango');
INSERT INTO Clientes VALUES ('C-1010', 'Bodega Sur', 'Mayorista', 'Mayorista', 'Escuintla', 'Escuintla');
GO

-- Insertar Ventas (400 de 500 registros)
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-31', 'C-1001', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-30', 'C-1002', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-27', 'C-1005', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-25', 'C-1007', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-23', 'C-1009', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-21', 'C-1001', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-19', 'C-1003', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-18', 'C-1004', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-15', 'C-1007', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-13', 'C-1009', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-11', 'C-1001', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-09', 'C-1003', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-07', 'C-1005', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-06', 'C-1006', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-03', 'C-1009', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-01', 'C-1001', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-27', 'C-1003', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-25', 'C-1005', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-23', 'C-1007', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-22', 'C-1008', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-19', 'C-1001', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-17', 'C-1003', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-15', 'C-1005', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-13', 'C-1007', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-11', 'C-1009', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-10', 'C-1010', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-07', 'C-1003', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-05', 'C-1005', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-03', 'C-1007', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-01', 'C-1009', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-30', 'C-1001', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-29', 'C-1002', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-26', 'C-1005', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-24', 'C-1007', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-22', 'C-1009', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-20', 'C-1001', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-18', 'C-1003', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-17', 'C-1004', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-14', 'C-1007', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-12', 'C-1009', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-10', 'C-1001', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-08', 'C-1003', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-06', 'C-1005', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-05', 'C-1006', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-02', 'C-1009', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-31', 'C-1001', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-29', 'C-1003', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-27', 'C-1005', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-25', 'C-1007', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-24', 'C-1008', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-21', 'C-1001', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-19', 'C-1003', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-17', 'C-1005', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-15', 'C-1007', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-13', 'C-1009', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-12', 'C-1010', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-09', 'C-1003', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-07', 'C-1005', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-05', 'C-1007', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-03', 'C-1009', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-31', 'C-1001', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-30', 'C-1002', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-27', 'C-1005', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-25', 'C-1007', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-23', 'C-1009', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-21', 'C-1001', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-19', 'C-1003', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-18', 'C-1004', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-15', 'C-1007', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-13', 'C-1009', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-11', 'C-1001', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-09', 'C-1003', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-07', 'C-1005', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-06', 'C-1006', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-03', 'C-1009', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-01', 'C-1001', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-27', 'C-1003', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-25', 'C-1005', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-23', 'C-1007', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-22', 'C-1008', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-19', 'C-1001', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-17', 'C-1003', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-15', 'C-1005', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-13', 'C-1007', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-11', 'C-1009', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-10', 'C-1010', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-07', 'C-1003', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-05', 'C-1005', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-03', 'C-1007', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-01', 'C-1009', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-30', 'C-1001', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-29', 'C-1002', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-26', 'C-1005', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-24', 'C-1007', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-22', 'C-1009', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-20', 'C-1001', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-18', 'C-1003', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-17', 'C-1004', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-14', 'C-1007', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-12', 'C-1009', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-10', 'C-1001', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-08', 'C-1003', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-06', 'C-1005', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-05', 'C-1006', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-02', 'C-1009', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-31', 'C-1001', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-29', 'C-1003', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-27', 'C-1005', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-25', 'C-1007', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-24', 'C-1008', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-21', 'C-1001', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-19', 'C-1003', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-17', 'C-1005', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-15', 'C-1007', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-13', 'C-1009', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-12', 'C-1010', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-09', 'C-1003', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-07', 'C-1005', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-05', 'C-1007', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-03', 'C-1009', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-31', 'C-1001', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-30', 'C-1002', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-27', 'C-1005', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-25', 'C-1007', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-23', 'C-1009', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-21', 'C-1001', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-19', 'C-1003', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-18', 'C-1004', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-15', 'C-1007', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-13', 'C-1009', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-11', 'C-1001', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-09', 'C-1003', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-07', 'C-1005', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-06', 'C-1006', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-03', 'C-1009', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-01', 'C-1001', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-27', 'C-1003', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-25', 'C-1005', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-23', 'C-1007', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-22', 'C-1008', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-19', 'C-1001', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-17', 'C-1003', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-15', 'C-1005', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-13', 'C-1007', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-11', 'C-1009', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-10', 'C-1010', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-07', 'C-1003', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-05', 'C-1005', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-03', 'C-1007', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-01', 'C-1009', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-30', 'C-1001', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-29', 'C-1002', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-26', 'C-1005', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-24', 'C-1007', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-22', 'C-1009', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-20', 'C-1001', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-18', 'C-1003', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-17', 'C-1004', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-14', 'C-1007', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-12', 'C-1009', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-10', 'C-1001', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-08', 'C-1003', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-06', 'C-1005', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-05', 'C-1006', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-02', 'C-1009', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-31', 'C-1001', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-29', 'C-1003', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-27', 'C-1005', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-25', 'C-1007', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-24', 'C-1008', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-21', 'C-1001', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-19', 'C-1003', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-17', 'C-1005', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-15', 'C-1007', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-13', 'C-1009', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-12', 'C-1010', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-09', 'C-1003', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-07', 'C-1005', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-05', 'C-1007', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-03', 'C-1009', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-31', 'C-1001', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-30', 'C-1002', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-27', 'C-1005', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-25', 'C-1007', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-23', 'C-1009', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-21', 'C-1001', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-19', 'C-1003', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-18', 'C-1004', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-15', 'C-1007', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-13', 'C-1009', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-11', 'C-1001', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-09', 'C-1003', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-07', 'C-1005', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-06', 'C-1006', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-03', 'C-1009', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-01', 'C-1001', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-27', 'C-1003', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-25', 'C-1005', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-23', 'C-1007', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-22', 'C-1008', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-19', 'C-1001', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-17', 'C-1003', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-15', 'C-1005', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-13', 'C-1007', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-11', 'C-1009', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-10', 'C-1010', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-07', 'C-1003', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-05', 'C-1005', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-03', 'C-1007', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-01', 'C-1009', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-30', 'C-1001', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-29', 'C-1002', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-26', 'C-1005', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-24', 'C-1007', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-22', 'C-1009', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-20', 'C-1001', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-18', 'C-1003', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-17', 'C-1004', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-14', 'C-1007', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-12', 'C-1009', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-10', 'C-1001', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-08', 'C-1003', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-06', 'C-1005', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-05', 'C-1006', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-02', 'C-1009', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-31', 'C-1001', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-29', 'C-1003', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-27', 'C-1005', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-25', 'C-1007', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-24', 'C-1008', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-21', 'C-1001', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-19', 'C-1003', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-17', 'C-1005', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-15', 'C-1007', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-13', 'C-1009', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-12', 'C-1010', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-09', 'C-1003', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-07', 'C-1005', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-05', 'C-1007', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-03', 'C-1009', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-31', 'C-1001', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-30', 'C-1002', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-27', 'C-1005', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-25', 'C-1007', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-23', 'C-1009', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-21', 'C-1001', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-19', 'C-1003', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-18', 'C-1004', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-15', 'C-1007', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-13', 'C-1009', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-11', 'C-1001', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-09', 'C-1003', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-07', 'C-1005', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-06', 'C-1006', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-03', 'C-1009', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-01', 'C-1001', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-27', 'C-1003', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-25', 'C-1005', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-23', 'C-1007', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-22', 'C-1008', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-19', 'C-1001', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-17', 'C-1003', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-15', 'C-1005', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-13', 'C-1007', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-11', 'C-1009', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-10', 'C-1010', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-07', 'C-1003', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-05', 'C-1005', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-03', 'C-1007', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-01', 'C-1009', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-30', 'C-1001', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-29', 'C-1002', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-26', 'C-1005', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-24', 'C-1007', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-22', 'C-1009', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-20', 'C-1001', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-18', 'C-1003', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-17', 'C-1004', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-14', 'C-1007', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-12', 'C-1009', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-10', 'C-1001', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-08', 'C-1003', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-06', 'C-1005', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-05', 'C-1006', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-02', 'C-1009', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-31', 'C-1001', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-29', 'C-1003', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-27', 'C-1005', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-25', 'C-1007', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-24', 'C-1008', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-21', 'C-1001', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-19', 'C-1003', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-17', 'C-1005', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-15', 'C-1007', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-13', 'C-1009', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-12', 'C-1010', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-09', 'C-1003', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-07', 'C-1005', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-05', 'C-1007', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-03', 'C-1009', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-31', 'C-1001', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-30', 'C-1002', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-27', 'C-1005', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-25', 'C-1007', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-23', 'C-1009', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-21', 'C-1001', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-19', 'C-1003', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-18', 'C-1004', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-15', 'C-1007', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-13', 'C-1009', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-11', 'C-1001', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-09', 'C-1003', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-07', 'C-1005', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-06', 'C-1006', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-03', 'C-1009', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-01', 'C-1001', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-27', 'C-1003', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-25', 'C-1005', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-23', 'C-1007', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-22', 'C-1008', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-19', 'C-1001', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-17', 'C-1003', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-15', 'C-1005', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-13', 'C-1007', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-11', 'C-1009', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-10', 'C-1010', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-07', 'C-1003', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-05', 'C-1005', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-03', 'C-1007', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-01', 'C-1009', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-30', 'C-1001', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-29', 'C-1002', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-26', 'C-1005', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-24', 'C-1007', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-22', 'C-1009', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-20', 'C-1001', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-18', 'C-1003', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-17', 'C-1004', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-14', 'C-1007', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-12', 'C-1009', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-10', 'C-1001', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-08', 'C-1003', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-06', 'C-1005', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-05', 'C-1006', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-02', 'C-1009', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-31', 'C-1001', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-29', 'C-1003', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-27', 'C-1005', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-25', 'C-1007', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-24', 'C-1008', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-21', 'C-1001', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-19', 'C-1003', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-17', 'C-1005', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-15', 'C-1007', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-13', 'C-1009', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-12', 'C-1010', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-09', 'C-1003', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-07', 'C-1005', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-05', 'C-1007', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-03', 'C-1009', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-31', 'C-1001', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-30', 'C-1002', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-27', 'C-1005', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-25', 'C-1007', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-23', 'C-1009', 'ABA-003', 10, 15.9000, 0.0000, 159.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-21', 'C-1001', 'CON-002', 12, 6.2500, 1.5000, 73.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-19', 'C-1003', 'LAC-001', 14, 8.1500, 3.0000, 111.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-18', 'C-1004', 'LAC-002', 15, 4.9500, 3.7500, 70.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-15', 'C-1007', 'SNK-001', 18, 3.9500, 6.0000, 65.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-13', 'C-1009', 'ABA-001', 20, 22.5000, 0.7500, 449.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-11', 'C-1001', 'ABA-003', 22, 15.9000, 2.2500, 347.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-09', 'C-1003', 'CON-002', 24, 6.2500, 3.7500, 146.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-07', 'C-1005', 'LAC-001', 2, 8.1500, 5.2500, 11.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-06', 'C-1006', 'LAC-002', 3, 4.9500, 6.0000, 8.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-03', 'C-1009', 'SNK-001', 6, 3.9500, 1.5000, 22.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-01', 'C-1001', 'ABA-001', 8, 22.5000, 3.0000, 177.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-27', 'C-1003', 'ABA-003', 10, 15.9000, 4.5000, 154.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-25', 'C-1005', 'CON-002', 12, 6.2500, 6.0000, 69.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-23', 'C-1007', 'LAC-001', 14, 8.1500, 0.7500, 113.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-22', 'C-1008', 'LAC-002', 15, 4.9500, 1.5000, 72.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-19', 'C-1001', 'SNK-001', 18, 3.9500, 3.7500, 67.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-17', 'C-1003', 'ABA-001', 20, 22.5000, 5.2500, 444.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-15', 'C-1005', 'ABA-003', 22, 15.9000, 0.0000, 349.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-13', 'C-1007', 'CON-002', 24, 6.2500, 1.5000, 148.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-11', 'C-1009', 'LAC-001', 2, 8.1500, 3.0000, 13.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-10', 'C-1010', 'LAC-002', 3, 4.9500, 3.7500, 11.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-07', 'C-1003', 'SNK-001', 6, 3.9500, 6.0000, 17.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-05', 'C-1005', 'ABA-001', 8, 22.5000, 0.7500, 179.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-03', 'C-1007', 'ABA-003', 10, 15.9000, 2.2500, 156.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-01', 'C-1009', 'CON-002', 12, 6.2500, 3.7500, 71.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-30', 'C-1001', 'LAC-001', 14, 8.1500, 5.2500, 108.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-29', 'C-1002', 'LAC-002', 15, 4.9500, 6.0000, 68.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-26', 'C-1005', 'SNK-001', 18, 3.9500, 1.5000, 69.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-24', 'C-1007', 'ABA-001', 20, 22.5000, 3.0000, 447.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-22', 'C-1009', 'ABA-003', 22, 15.9000, 4.5000, 345.3000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-20', 'C-1001', 'CON-002', 24, 6.2500, 6.0000, 144.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-18', 'C-1003', 'LAC-001', 2, 8.1500, 0.7500, 15.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-17', 'C-1004', 'LAC-002', 3, 4.9500, 1.5000, 13.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-14', 'C-1007', 'SNK-001', 6, 3.9500, 3.7500, 19.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-12', 'C-1009', 'ABA-001', 8, 22.5000, 5.2500, 174.7500);
GO

-- Verificar carga
SELECT COUNT(*) AS TotalVentas    FROM Ventas;
SELECT COUNT(*) AS TotalProductos FROM Productos;
SELECT COUNT(*) AS TotalClientes  FROM Clientes;
GO