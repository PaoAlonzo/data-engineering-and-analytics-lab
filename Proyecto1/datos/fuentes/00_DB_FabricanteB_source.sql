-- ============================================================
-- Base de datos fuente: DB_FabricanteB
-- Fabricante B: datos transaccionales de ventas
-- ============================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DB_FabricanteB')
    DROP DATABASE [DB_FabricanteB];
GO

CREATE DATABASE [DB_FabricanteB];
GO

USE [DB_FabricanteB];
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
INSERT INTO Productos VALUES ('BEB-001', 'Soda Cola 2L', 'Fizzy', 'Bebidas', 'Gaseosas', 4.7500);
INSERT INTO Productos VALUES ('BEB-002', 'Agua 600ml', 'AquaPure', 'Bebidas', 'Agua', 1.8500);
INSERT INTO Productos VALUES ('SNK-002', 'Galletas Chocolate 6u', 'Dulci', 'Snacks', 'Galletas', 2.9500);
INSERT INTO Productos VALUES ('ABA-002', 'Frijol Negro 2lb', 'GranoFino', 'Abarrotes', 'Granos', 8.6000);
INSERT INTO Productos VALUES ('CON-001', 'Atun 140g', 'MarAzul', 'Abarrotes', 'Enlatados', 5.3500);
INSERT INTO Productos VALUES ('BEB-003', 'Jugo Naranja 1L', 'VitaFruit', 'Bebidas', 'Jugos', 5.1000);
GO

-- Insertar Clientes
INSERT INTO Clientes VALUES ('C-1003', 'Hotel Mirador', 'HORECA', 'Institucional', 'Sacatepequez', 'Antigua Guatemala');
INSERT INTO Clientes VALUES ('C-1004', 'Restaurante El Buen Sabor', 'HORECA', 'Institucional', 'Guatemala', 'Villa Nueva');
INSERT INTO Clientes VALUES ('C-1006', 'MiniMarket Los Pinos', 'Tienda', 'Minorista', 'Quetzaltenango', 'Quetzaltenango');
INSERT INTO Clientes VALUES ('C-1008', 'Super Ahorro Xela', 'Supermercado', 'Mayorista', 'Quetzaltenango', 'Quetzaltenango');
INSERT INTO Clientes VALUES ('C-1010', 'Bodega Sur', 'Mayorista', 'Mayorista', 'Escuintla', 'Escuintla');
INSERT INTO Clientes VALUES ('C-1002', 'Tienda La Esquina', 'Tienda', 'Minorista', 'Guatemala', 'Mixco');
INSERT INTO Clientes VALUES ('C-1005', 'Market Online GT', 'Online', 'Ecommerce', 'Guatemala', 'Guatemala');
INSERT INTO Clientes VALUES ('C-1007', 'Distribuidora Norte', 'Mayorista', 'Mayorista', 'Alta Verapaz', 'Coban');
INSERT INTO Clientes VALUES ('C-1009', 'Comedor Universitario', 'Institucional', 'Institucional', 'Guatemala', 'Guatemala');
INSERT INTO Clientes VALUES ('C-1001', 'Super Mercado Central', 'Supermercado', 'Mayorista', 'Guatemala', 'Guatemala');
GO

-- Insertar Ventas (400 de 500 registros)
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-29', 'C-1003', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-28', 'C-1004', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-26', 'C-1006', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-24', 'C-1008', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-22', 'C-1010', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-20', 'C-1002', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-17', 'C-1005', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-16', 'C-1006', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-14', 'C-1008', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-12', 'C-1010', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-10', 'C-1002', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-08', 'C-1004', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-05', 'C-1007', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-04', 'C-1008', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-02', 'C-1010', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-28', 'C-1002', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-26', 'C-1004', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-24', 'C-1006', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-21', 'C-1009', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-20', 'C-1010', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-18', 'C-1002', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-16', 'C-1004', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-14', 'C-1006', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-12', 'C-1008', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-09', 'C-1001', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-08', 'C-1002', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-06', 'C-1004', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-04', 'C-1006', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-02', 'C-1008', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-31', 'C-1010', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-28', 'C-1003', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-27', 'C-1004', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-25', 'C-1006', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-23', 'C-1008', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-21', 'C-1010', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-19', 'C-1002', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-16', 'C-1005', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-15', 'C-1006', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-13', 'C-1008', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-11', 'C-1010', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-09', 'C-1002', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-07', 'C-1004', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-04', 'C-1007', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-03', 'C-1008', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-01', 'C-1010', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-30', 'C-1002', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-28', 'C-1004', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-26', 'C-1006', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-23', 'C-1009', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-22', 'C-1010', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-20', 'C-1002', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-18', 'C-1004', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-16', 'C-1006', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-14', 'C-1008', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-11', 'C-1001', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-10', 'C-1002', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-08', 'C-1004', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-06', 'C-1006', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-04', 'C-1008', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-04-01', 'C-1010', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-29', 'C-1003', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-28', 'C-1004', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-26', 'C-1006', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-24', 'C-1008', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-22', 'C-1010', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-20', 'C-1002', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-17', 'C-1005', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-16', 'C-1006', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-14', 'C-1008', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-12', 'C-1010', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-10', 'C-1002', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-08', 'C-1004', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-05', 'C-1007', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-04', 'C-1008', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-02', 'C-1010', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-28', 'C-1002', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-26', 'C-1004', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-24', 'C-1006', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-21', 'C-1009', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-20', 'C-1010', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-18', 'C-1002', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-16', 'C-1004', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-14', 'C-1006', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-12', 'C-1008', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-09', 'C-1001', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-08', 'C-1002', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-06', 'C-1004', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-04', 'C-1006', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-02', 'C-1008', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-31', 'C-1010', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-28', 'C-1003', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-27', 'C-1004', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-25', 'C-1006', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-23', 'C-1008', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-21', 'C-1010', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-19', 'C-1002', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-16', 'C-1005', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-15', 'C-1006', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-13', 'C-1008', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-11', 'C-1010', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-09', 'C-1002', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-07', 'C-1004', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-04', 'C-1007', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-03', 'C-1008', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-01', 'C-1010', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-30', 'C-1002', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-28', 'C-1004', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-26', 'C-1006', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-23', 'C-1009', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-22', 'C-1010', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-20', 'C-1002', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-18', 'C-1004', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-16', 'C-1006', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-14', 'C-1008', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-11', 'C-1001', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-10', 'C-1002', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-08', 'C-1004', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-06', 'C-1006', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-04', 'C-1008', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-04-01', 'C-1010', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-29', 'C-1003', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-28', 'C-1004', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-26', 'C-1006', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-24', 'C-1008', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-22', 'C-1010', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-20', 'C-1002', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-17', 'C-1005', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-16', 'C-1006', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-14', 'C-1008', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-12', 'C-1010', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-10', 'C-1002', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-08', 'C-1004', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-05', 'C-1007', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-04', 'C-1008', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-02', 'C-1010', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-28', 'C-1002', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-26', 'C-1004', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-24', 'C-1006', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-21', 'C-1009', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-20', 'C-1010', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-18', 'C-1002', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-16', 'C-1004', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-14', 'C-1006', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-12', 'C-1008', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-09', 'C-1001', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-08', 'C-1002', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-06', 'C-1004', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-04', 'C-1006', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-02', 'C-1008', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-31', 'C-1010', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-28', 'C-1003', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-27', 'C-1004', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-25', 'C-1006', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-23', 'C-1008', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-21', 'C-1010', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-19', 'C-1002', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-16', 'C-1005', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-15', 'C-1006', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-13', 'C-1008', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-11', 'C-1010', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-09', 'C-1002', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-07', 'C-1004', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-04', 'C-1007', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-03', 'C-1008', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-01', 'C-1010', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-30', 'C-1002', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-28', 'C-1004', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-26', 'C-1006', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-23', 'C-1009', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-22', 'C-1010', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-20', 'C-1002', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-18', 'C-1004', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-16', 'C-1006', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-14', 'C-1008', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-11', 'C-1001', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-10', 'C-1002', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-08', 'C-1004', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-06', 'C-1006', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-04', 'C-1008', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-04-01', 'C-1010', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-29', 'C-1003', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-28', 'C-1004', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-26', 'C-1006', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-24', 'C-1008', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-22', 'C-1010', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-20', 'C-1002', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-17', 'C-1005', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-16', 'C-1006', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-14', 'C-1008', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-12', 'C-1010', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-10', 'C-1002', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-08', 'C-1004', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-05', 'C-1007', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-04', 'C-1008', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-02', 'C-1010', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-28', 'C-1002', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-26', 'C-1004', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-24', 'C-1006', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-21', 'C-1009', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-20', 'C-1010', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-18', 'C-1002', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-16', 'C-1004', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-14', 'C-1006', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-12', 'C-1008', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-09', 'C-1001', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-08', 'C-1002', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-06', 'C-1004', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-04', 'C-1006', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-02', 'C-1008', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-31', 'C-1010', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-28', 'C-1003', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-27', 'C-1004', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-25', 'C-1006', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-23', 'C-1008', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-21', 'C-1010', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-19', 'C-1002', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-16', 'C-1005', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-15', 'C-1006', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-13', 'C-1008', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-11', 'C-1010', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-09', 'C-1002', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-07', 'C-1004', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-04', 'C-1007', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-03', 'C-1008', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-01', 'C-1010', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-30', 'C-1002', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-28', 'C-1004', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-26', 'C-1006', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-23', 'C-1009', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-22', 'C-1010', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-20', 'C-1002', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-18', 'C-1004', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-16', 'C-1006', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-14', 'C-1008', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-11', 'C-1001', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-10', 'C-1002', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-08', 'C-1004', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-06', 'C-1006', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-04', 'C-1008', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-04-01', 'C-1010', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-29', 'C-1003', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-28', 'C-1004', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-26', 'C-1006', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-24', 'C-1008', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-22', 'C-1010', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-20', 'C-1002', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-17', 'C-1005', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-16', 'C-1006', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-14', 'C-1008', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-12', 'C-1010', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-10', 'C-1002', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-08', 'C-1004', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-05', 'C-1007', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-04', 'C-1008', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-02', 'C-1010', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-28', 'C-1002', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-26', 'C-1004', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-24', 'C-1006', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-21', 'C-1009', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-20', 'C-1010', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-18', 'C-1002', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-16', 'C-1004', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-14', 'C-1006', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-12', 'C-1008', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-09', 'C-1001', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-08', 'C-1002', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-06', 'C-1004', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-04', 'C-1006', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-02', 'C-1008', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-31', 'C-1010', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-28', 'C-1003', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-27', 'C-1004', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-25', 'C-1006', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-23', 'C-1008', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-21', 'C-1010', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-19', 'C-1002', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-16', 'C-1005', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-15', 'C-1006', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-13', 'C-1008', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-11', 'C-1010', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-09', 'C-1002', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-07', 'C-1004', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-04', 'C-1007', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-03', 'C-1008', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-01', 'C-1010', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-30', 'C-1002', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-28', 'C-1004', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-26', 'C-1006', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-23', 'C-1009', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-22', 'C-1010', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-20', 'C-1002', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-18', 'C-1004', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-16', 'C-1006', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-14', 'C-1008', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-11', 'C-1001', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-10', 'C-1002', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-08', 'C-1004', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-06', 'C-1006', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-04', 'C-1008', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-04-01', 'C-1010', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-29', 'C-1003', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-28', 'C-1004', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-26', 'C-1006', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-24', 'C-1008', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-22', 'C-1010', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-20', 'C-1002', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-17', 'C-1005', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-16', 'C-1006', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-14', 'C-1008', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-12', 'C-1010', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-10', 'C-1002', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-08', 'C-1004', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-05', 'C-1007', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-04', 'C-1008', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-02', 'C-1010', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-28', 'C-1002', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-26', 'C-1004', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-24', 'C-1006', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-21', 'C-1009', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-20', 'C-1010', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-18', 'C-1002', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-16', 'C-1004', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-14', 'C-1006', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-12', 'C-1008', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-09', 'C-1001', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-08', 'C-1002', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-06', 'C-1004', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-04', 'C-1006', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-02', 'C-1008', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-31', 'C-1010', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-28', 'C-1003', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-27', 'C-1004', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-25', 'C-1006', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-23', 'C-1008', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-21', 'C-1010', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-19', 'C-1002', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-16', 'C-1005', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-15', 'C-1006', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-13', 'C-1008', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-11', 'C-1010', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-09', 'C-1002', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-07', 'C-1004', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-04', 'C-1007', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-03', 'C-1008', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-01', 'C-1010', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-30', 'C-1002', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-28', 'C-1004', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-26', 'C-1006', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-23', 'C-1009', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-22', 'C-1010', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-20', 'C-1002', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-18', 'C-1004', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-16', 'C-1006', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-14', 'C-1008', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-11', 'C-1001', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-10', 'C-1002', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-08', 'C-1004', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-06', 'C-1006', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2025-12-04', 'C-1008', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-04-01', 'C-1010', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-29', 'C-1003', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-28', 'C-1004', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-26', 'C-1006', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-24', 'C-1008', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-22', 'C-1010', 'CON-001', 11, 7.8000, 0.7500, 85.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-20', 'C-1002', 'BEB-003', 13, 7.2000, 2.2500, 91.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-17', 'C-1005', 'BEB-001', 16, 6.5000, 4.5000, 99.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-16', 'C-1006', 'BEB-002', 17, 2.8000, 5.2500, 42.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-14', 'C-1008', 'SNK-002', 19, 4.9500, 0.0000, 94.0500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-12', 'C-1010', 'ABA-002', 21, 11.9000, 1.5000, 248.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-10', 'C-1002', 'CON-001', 23, 7.8000, 3.0000, 176.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-08', 'C-1004', 'BEB-003', 1, 7.2000, 4.5000, 2.7000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-05', 'C-1007', 'BEB-001', 4, 6.5000, 0.0000, 26.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-04', 'C-1008', 'BEB-002', 5, 2.8000, 0.7500, 13.2500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-03-02', 'C-1010', 'SNK-002', 7, 4.9500, 2.2500, 32.4000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-28', 'C-1002', 'ABA-002', 9, 11.9000, 3.7500, 103.3500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-26', 'C-1004', 'CON-001', 11, 7.8000, 5.2500, 80.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-24', 'C-1006', 'BEB-003', 13, 7.2000, 0.0000, 93.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-21', 'C-1009', 'BEB-001', 16, 6.5000, 2.2500, 101.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-20', 'C-1010', 'BEB-002', 17, 2.8000, 3.0000, 44.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-18', 'C-1002', 'SNK-002', 19, 4.9500, 4.5000, 89.5500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-16', 'C-1004', 'ABA-002', 21, 11.9000, 6.0000, 243.9000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-14', 'C-1006', 'CON-001', 23, 7.8000, 0.7500, 178.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-12', 'C-1008', 'BEB-003', 1, 7.2000, 2.2500, 4.9500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-09', 'C-1001', 'BEB-001', 4, 6.5000, 4.5000, 21.5000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-08', 'C-1002', 'BEB-002', 5, 2.8000, 5.2500, 8.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-06', 'C-1004', 'SNK-002', 7, 4.9500, 0.0000, 34.6500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-04', 'C-1006', 'ABA-002', 9, 11.9000, 1.5000, 105.6000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-02-02', 'C-1008', 'CON-001', 11, 7.8000, 3.0000, 82.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-31', 'C-1010', 'BEB-003', 13, 7.2000, 4.5000, 89.1000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-28', 'C-1003', 'BEB-001', 16, 6.5000, 0.0000, 104.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-27', 'C-1004', 'BEB-002', 17, 2.8000, 0.7500, 46.8500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-25', 'C-1006', 'SNK-002', 19, 4.9500, 2.2500, 91.8000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-23', 'C-1008', 'ABA-002', 21, 11.9000, 3.7500, 246.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-21', 'C-1010', 'CON-001', 23, 7.8000, 5.2500, 174.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-19', 'C-1002', 'BEB-003', 1, 7.2000, 0.0000, 7.2000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-16', 'C-1005', 'BEB-001', 4, 6.5000, 2.2500, 23.7500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-15', 'C-1006', 'BEB-002', 5, 2.8000, 3.0000, 11.0000);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-13', 'C-1008', 'SNK-002', 7, 4.9500, 4.5000, 30.1500);
INSERT INTO Ventas (Fecha, ClienteId, SKU, CantidadVendida, PrecioUnitario, Descuento, ImporteNeto) VALUES ('2026-01-11', 'C-1010', 'ABA-002', 9, 11.9000, 6.0000, 101.1000);
GO

-- Verificar carga
SELECT COUNT(*) AS TotalVentas    FROM Ventas;
SELECT COUNT(*) AS TotalProductos FROM Productos;
SELECT COUNT(*) AS TotalClientes  FROM Clientes;
GO