# Proyecto 1 - SG-Food Business Intelligence

## Implementacion del flujo completo Microsoft: SSIS, Data Warehouse y SSAS


## 1. Descripcion general

SG-Food enfrenta dificultades en el analisis de ventas e inventarios: tiempos de respuesta lentos, sobrecarga en su base de datos transaccional y limitaciones para generar reportes flexibles.

La solucion implementada consta de tres capas:

- **ETL con SSIS:** extrae datos de 5 fuentes heterogeneas, los limpia y los carga en el area de staging.
- **Data Warehouse en SQL Server:** modelo dimensional (esquema estrella) con 4 dimensiones y 2 tablas de hechos.
- **Modelo analitico en SSAS:** cubo multidimensional con jerarquias, medidas y dimensiones listas para consultas en Excel o Power BI.

---

## 2. Fuentes de datos

| Fuente                  | Tipo                            | Descripcion                                                                | Registros |
| ----------------------- | ------------------------------- | -------------------------------------------------------------------------- | --------- |
| DB_FabricanteA          | SQL Server local                | Ventas de lacteos, snacks y abarrotes. Tablas: Ventas, Clientes, Productos | ~500      |
| DB_FabricanteB          | SQL Server local                | Ventas de bebidas, snacks y abarrotes. Tablas: Ventas, Clientes, Productos | ~500      |
| SGFoodOLTP              | SQL Server remoto (34.63.26.98) | Tabla unica TransaccionesVenta                                             | 1000      |
| ventas_externas.vent    | Archivo delimitado por \|       | Ventas de canales externos                                                 | ~150      |
| inventario_externo.comp | Archivo delimitado por \|       | Niveles de inventario diario por producto                                  | ~100      |

**Credenciales SGFoodOLTP:**

- Servidor: 34.63.26.98, Puerto 1433
- Base de datos: SGFoodOLTP
- Usuario: sgfood_reader
- Tabla: dbo.TransaccionesVenta

**Productos en el sistema (12 SKUs):**

| SKU     | Nombre                | Fabricante  |
| ------- | --------------------- | ----------- |
| LAC-001 | Leche Entera 1L       | FabricanteA |
| LAC-002 | Yogurt Fresa 200ml    | FabricanteA |
| SNK-001 | Papas Clasicas 45g    | FabricanteA |
| ABA-001 | Arroz 5lb             | FabricanteA |
| ABA-003 | Aceite 1L             | FabricanteA |
| CON-002 | Salsa Tomate 400g     | FabricanteA |
| BEB-001 | Soda Cola 2L          | FabricanteB |
| BEB-002 | Agua 600ml            | FabricanteB |
| BEB-003 | Jugo Naranja 1L       | FabricanteB |
| SNK-002 | Galletas Chocolate 6u | FabricanteB |
| ABA-002 | Frijol Negro 2lb      | FabricanteB |
| CON-001 | Atun 140g             | FabricanteB |

---

## 3. Arquitectura del sistema

```
[DB_FabricanteA]  [DB_FabricanteB]  [SGFoodOLTP]  [.vent]  [.comp]
       |                 |                |            |        |
       +--------+--------+----------------+------------+--------+
                |                SSIS - Extraccion y Transformacion
                |
       +--------+--------+
       |  STG_SGFood      |   (Area de Staging - base de datos intermedia)
       | STG_VentasFabA   |
       | STG_VentasFabB   |
       | STG_VentasOLTP   |
       | STG_VentasExt    |
       | STG_InventarioExt|
       +--------+---------+
                |                SSIS - Carga / Stored Procedures
                |
       +--------+--------------------------------------------------+
       |                     DW_SGFood                             |
       |  DimFecha  DimProducto  DimCliente  DimFuente             |
       |  FactVentas             FactInventario                     |
       +--------+--------------------------------------------------+
                |
       +--------+--------+
       |   SSAS Modelo   |   (Cubo multidimensional)
       |   Dimensiones   |
       |   Jerarquias    |
       |   Medidas       |
       +--------+--------+
                |
       +--------+--------+
       |  Excel / Power  |   (Consumo y reportes)
       |       BI        |
       +-----------------+
```

---

## 4. Modelo del Data Warehouse

### Esquema estrella

El modelo sigue un esquema estrella con dos tablas de hechos que comparten las dimensiones DimFecha y DimProducto.

### Dimensiones

**DimFecha**

- Clave: FechaKey (INT, formato YYYYMMDD)
- Atributos: Fecha, Anio, Semestre, Trimestre, Mes, NombreMes, Semana, DiaDelMes, DiaSemana, NombreDia
- Rango: 2025-01-01 al 2027-12-31 (1096 registros)
- Jerarquias SSAS: Anio > Semestre > Trimestre > Mes > Fecha

**DimProducto**

- Clave surrogate: ProductoKey (IDENTITY)
- Clave natural: SKU
- Atributos: Nombre, Marca, Categoria, Subcategoria, CostoUnitario, FabricanteOrigen
- 12 productos distintos (6 por fabricante)
- Jerarquias SSAS: Categoria > Subcategoria > SKU

**DimCliente**

- Clave surrogate: ClienteKey (IDENTITY)
- Clave natural: ClienteId (C-1001 a C-1010)
- Atributos: ClienteNombre, Segmento, Canal, Departamento, Municipio
- 10 clientes distintos
- Jerarquias SSAS: Segmento > Canal > Cliente; Departamento > Municipio > Cliente

**DimFuente**

- Clave surrogate: FuenteKey (IDENTITY)
- Atributos: NombreFuente, TipoFuente, Descripcion
- 5 fuentes: DB_FabricanteA, DB_FabricanteB, SGFoodOLTP, VentasExternas, InventarioExterno

### Tablas de hechos

**FactVentas**

- Granularidad: Una fila por transaccion de venta
- Dimensiones: FechaKey, ProductoKey, ClienteKey, FuenteKey
- Medidas: CantidadVendida, PrecioUnitario, Descuento, ImporteNeto, CostoUnitario
- Medida calculada (PERSISTED): MargenBruto = ImporteNeto - (CantidadVendida \* CostoUnitario)

**FactInventario**

- Granularidad: Una fila por producto por dia
- Dimensiones: FechaKey, ProductoKey
- Medidas: InventarioInicial, InventarioFinal
- Medida calculada (PERSISTED): VariacionInventario = InventarioFinal - InventarioInicial

---

## 5. Proceso ETL con SSIS

### Estructura de paquetes

El proyecto SSIS debe contener los siguientes paquetes dentro de una solucion de Visual Studio:

```
SolucionSSIS_SGFood.sln
  SGFood_ETL.dtproj
    Paquetes/
      PKG_00_Master.dtsx            <- Paquete maestro que llama a todos
      PKG_01_Load_STG_FabricanteA.dtsx
      PKG_02_Load_STG_FabricanteB.dtsx
      PKG_03_Load_STG_SGFoodOLTP.dtsx
      PKG_04_Load_STG_Archivos.dtsx
      PKG_05_Load_DW.dtsx
```

### PKG_01: Cargar staging Fabricante A

**Tarea:** Data Flow Task

**OLE DB Source - FabricanteA:**

- Connection Manager: apuntando a DB_FabricanteA (servidor local)
- Query de extraccion (JOIN de las 3 tablas):

```sql
SELECT
    'DB_FabricanteA'    AS FuenteRegistro,
    v.Fecha,
    c.ClienteId,
    c.ClienteNombre,
    c.Segmento,
    c.Canal,
    c.Departamento,
    c.Municipio,
    p.SKU,
    p.Nombre            AS NomProducto,
    p.Marca,
    p.Categoria,
    p.Subcategoria,
    p.CostoUnitario,
    v.CantidadVendida,
    v.PrecioUnitario,
    v.Descuento,
    v.ImporteNeto
FROM DB_FabricanteA.dbo.Ventas       v
INNER JOIN DB_FabricanteA.dbo.Clientes  c ON v.ClienteId = c.ClienteId
INNER JOIN DB_FabricanteA.dbo.Productos p ON v.SKU       = p.SKU
```

**OLE DB Destination:**

- Tabla destino: STG_SGFood.dbo.STG_VentasFabricanteA
- FastLoad activo

### PKG_02: Cargar staging Fabricante B

Mismo flujo que PKG_01 pero:

- Connection Manager apuntando a DB_FabricanteB
- FuenteRegistro = 'DB_FabricanteB'
- Tabla destino: STG_SGFood.dbo.STG_VentasFabricanteB

```sql
SELECT
    'DB_FabricanteB'    AS FuenteRegistro,
    v.Fecha,
    c.ClienteId,
    c.ClienteNombre,
    c.Segmento,
    c.Canal,
    c.Departamento,
    c.Municipio,
    p.SKU,
    p.Nombre            AS NomProducto,
    p.Marca,
    p.Categoria,
    p.Subcategoria,
    p.CostoUnitario,
    v.CantidadVendida,
    v.PrecioUnitario,
    v.Descuento,
    v.ImporteNeto
FROM DB_FabricanteB.dbo.Ventas       v
INNER JOIN DB_FabricanteB.dbo.Clientes  c ON v.ClienteId = c.ClienteId
INNER JOIN DB_FabricanteB.dbo.Productos p ON v.SKU       = p.SKU
```

### PKG_03: Cargar staging SGFoodOLTP

**OLE DB Source - SGFoodOLTP:**

- Connection Manager con servidor 34.63.26.98, puerto 1433
- Autenticacion SQL: sgfood_reader / SgFoodReader_2026!Sem2
- Query: `SELECT * FROM dbo.TransaccionesVenta`
- Nota: ajustar los nombres de columna segun la estructura real de la tabla remota.

**Derived Column Task:** agregar columna FuenteRegistro = 'SGFoodOLTP'

**OLE DB Destination:** STG_SGFood.dbo.STG_VentasOLTP

### PKG_04: Cargar staging desde archivos planos

**Fuente 1: ventas_externas.vent**

- Flat File Connection Manager
  - Ruta: `datos\fuentes\ventas_externas.vent`
  - Delimitador de columna: `|`
  - Primera fila como encabezado: Si
  - Mapeo de columnas: Fecha (DT_DBDATE), CodCliente -> ClienteId (DT_STR), NomCliente -> ClienteNombre (DT_STR), Segmento, Canal, Departamento, Municipio (DT_STR), SKU (DT_STR), Cantidad -> CantidadVendida (DT_I4), PrecioUnitario (DT_NUMERIC), Descuento (DT_NUMERIC)
- Derived Column: FuenteRegistro = 'VentasExternas'
- OLE DB Destination: STG_SGFood.dbo.STG_VentasExternas

**Fuente 2: inventario_externo.comp**

- Flat File Connection Manager
  - Ruta: `datos\fuentes\inventario_externo.comp`
  - Delimitador de columna: `|`
  - Primera fila como encabezado: Si
  - Mapeo: Fecha (DT_DBDATE), SKU (DT_STR), NomProducto (DT_STR), InventarioInicial (DT_I4), InventarioFinal (DT_I4)
- Derived Column: FuenteRegistro = 'InventarioExterno'
- OLE DB Destination: STG_SGFood.dbo.STG_InventarioExterno

### PKG_05: Cargar Data Warehouse

**Control Flow:**

1. Execute SQL Task: `EXEC DW_SGFood.dbo.SP_Cargar_DimFuente`
2. Execute SQL Task: `EXEC DW_SGFood.dbo.SP_Cargar_DimProducto`
3. Execute SQL Task: `EXEC DW_SGFood.dbo.SP_Cargar_DimCliente`
4. Execute SQL Task: `EXEC DW_SGFood.dbo.SP_Cargar_FactVentas`
5. Execute SQL Task: `EXEC DW_SGFood.dbo.SP_Cargar_FactInventario`

Conectar las tareas en secuencia (flechas verde). Si alguna falla, el flujo se detiene.

### PKG_00: Paquete maestro

**Control Flow con Execute Package Task en orden:**

1. Execute Package: PKG_01_Load_STG_FabricanteA
2. Execute Package: PKG_02_Load_STG_FabricanteB
3. Execute Package: PKG_03_Load_STG_SGFoodOLTP
4. Execute Package: PKG_04_Load_STG_Archivos
5. Execute Package: PKG_05_Load_DW

---

## 6. Modelo analitico con SSAS

### Configuracion del proyecto

1. En Visual Studio crear un nuevo proyecto de tipo **Analysis Services Multidimensional and Data Mining Project**.
2. Nombre del proyecto: `SGFood_SSAS`
3. Agregar Data Source: conexion a DW_SGFood en el servidor local.
4. Agregar Data Source View: incluir todas las tablas del DW (DimFecha, DimProducto, DimCliente, DimFuente, FactVentas, FactInventario).

### Dimensiones SSAS

**Dimension Tiempo (basada en DimFecha)**

- Atributo clave: FechaKey
- Jerarquia definida por el usuario: "Tiempo"
  - Nivel 1: Anio
  - Nivel 2: Trimestre
  - Nivel 3: Mes (usar NombreMes como nombre del miembro)
  - Nivel 4: Fecha
- Marcar como dimension de tiempo en las propiedades.

**Dimension Producto (basada en DimProducto)**

- Atributo clave: ProductoKey
- Atributos adicionales: SKU, Nombre, Marca, FabricanteOrigen
- Jerarquia: "Clasificacion de Producto"
  - Nivel 1: Categoria
  - Nivel 2: Subcategoria
  - Nivel 3: Nombre

**Dimension Cliente (basada en DimCliente)**

- Atributo clave: ClienteKey
- Jerarquia 1: "Segmentacion"
  - Nivel 1: Segmento
  - Nivel 2: Canal
  - Nivel 3: ClienteNombre
- Jerarquia 2: "Geografia"
  - Nivel 1: Departamento
  - Nivel 2: Municipio
  - Nivel 3: ClienteNombre

**Dimension Fuente (basada en DimFuente)**

- Atributo clave: FuenteKey
- Atributos: NombreFuente, TipoFuente

### Cubo Ventas (basado en FactVentas)

**Medidas del grupo de medidas FactVentas:**

| Medida SSAS             | Columna en FactVentas | Funcion de agregacion |
| ----------------------- | --------------------- | --------------------- |
| Cantidad Vendida        | CantidadVendida       | Sum                   |
| Importe Neto            | ImporteNeto           | Sum                   |
| Margen Bruto            | MargenBruto           | Sum                   |
| Precio Promedio         | PrecioUnitario        | Average               |
| Descuento Total         | Descuento             | Sum                   |
| Numero de Transacciones | VentaKey              | Count                 |

**Medida calculada (Calculated Member):**

```mdx
[Measures].[Porcentaje Margen] =
IIF([Measures].[Importe Neto] = 0, NULL,
[Measures].[Margen Bruto] / [Measures].[Importe Neto] \* 100)
```

**Relaciones de dimensiones:**

| Dimension          | Tabla de hechos | Tipo    | Columna clave |
| ------------------ | --------------- | ------- | ------------- |
| Dimension Tiempo   | FactVentas      | Regular | FechaKey      |
| Dimension Producto | FactVentas      | Regular | ProductoKey   |
| Dimension Cliente  | FactVentas      | Regular | ClienteKey    |
| Dimension Fuente   | FactVentas      | Regular | FuenteKey     |

### Cubo Inventario (basado en FactInventario)

**Medidas:**

| Medida SSAS          | Columna             | Funcion |
| -------------------- | ------------------- | ------- |
| Inventario Inicial   | InventarioInicial   | Sum     |
| Inventario Final     | InventarioFinal     | Sum     |
| Variacion Inventario | VariacionInventario | Sum     |
| Dias con Registro    | InventarioKey       | Count   |

**Relaciones:**

| Dimension          | Tipo    | Columna clave |
| ------------------ | ------- | ------------- |
| Dimension Tiempo   | Regular | FechaKey      |
| Dimension Producto | Regular | ProductoKey   |

### Procesamiento del modelo SSAS

Una vez configurado, procesar el modelo desde Visual Studio:

1. Clic derecho sobre el proyecto SSAS > Deploy
2. Clic derecho > Process
3. Seleccionar Process Full para procesar desde cero
4. Verificar en el visor de browser que las dimensiones y medidas se muestran correctamente

---

## 7. Instrucciones de implementacion

Ejecutar los pasos en este orden exacto:

**Paso 1: Preparar el entorno SQL Server**

Ejecutar los scripts SQL en SSMS en el siguiente orden:

```
1. sql/01_DDL_DataWarehouse.sql    -> Crea DW_SGFood
2. sql/02_DDL_Staging.sql          -> Crea STG_SGFood
3. sql/03_SP_Poblar_DimFecha.sql   -> Puebla DimFecha con 3 anios
4. sql/04_SP_Carga_DW.sql          -> Crea los stored procedures de carga
```

**Paso 2: Crear bases de datos fuente locales**

Ejecutar en SSMS:

```
datos/fuentes/00_DB_FabricanteA_source.sql   -> Crea DB_FabricanteA con datos
datos/fuentes/00_DB_FabricanteB_source.sql   -> Crea DB_FabricanteB con datos
```

**Paso 3: Construir y ejecutar el proyecto SSIS en Visual Studio**

- Crear proyecto SSIS segun la estructura descrita en la seccion 5.
- Configurar todos los Connection Managers.
- Ejecutar el paquete maestro PKG_00_Master.dtsx.

**Paso 4: Verificar la carga**

Ejecutar en SSMS:

```
sql/05_Validaciones.sql
```

Todos los "Huerfanos" deben ser 0. El total de FactVentas debe ser mayor a 1000 registros.

**Paso 5: Crear y procesar el modelo SSAS**

- Crear proyecto SSAS segun la seccion 6.
- Deploy al servidor local.
- Process Full.
- Conectar Excel o Power BI al cubo para validar las medidas.

**Paso 6: Ejecutar consultas analiticas**

```
sql/06_Consultas_Analiticas.sql
```

---

## 8. Validacion

Los resultados esperados despues de la carga completa son:

| Verifica                  | Valor esperado               |
| ------------------------- | ---------------------------- |
| DimFecha registros        | 1096 (rango 2025-2027)       |
| DimProducto registros     | 12 SKUs                      |
| DimCliente registros      | 10 clientes                  |
| DimFuente registros       | 5 fuentes                    |
| FactVentas FabricanteA    | ~500 transacciones           |
| FactVentas FabricanteB    | ~500 transacciones           |
| FactVentas SGFoodOLTP     | ~1000 transacciones          |
| FactVentas VentasExternas | ~150 transacciones           |
| FactInventario            | registros por dia x producto |
| Huerfanos en FactVentas   | 0 en todas las dimensiones   |

---

## 9. Estructura del repositorio

```
Proyecto1/
  datos/
    fuentes/
      00_DB_FabricanteA_source.sql     <- Script fuente Fabricante A
      00_DB_FabricanteB_source.sql     <- Script fuente Fabricante B
      inventario_externo.comp          <- Archivo inventario (delimitado |)
      ventas_externas.vent             <- Archivo ventas externas (delimitado |)
  sql/
    01_DDL_DataWarehouse.sql           <- DDL del Data Warehouse (DW_SGFood)
    02_DDL_Staging.sql                 <- DDL del area de staging (STG_SGFood)
    03_SP_Poblar_DimFecha.sql          <- Script para poblar la dimension de tiempo
    04_SP_Carga_DW.sql                 <- Stored Procedures de carga DW desde staging
    05_Validaciones.sql                <- Consultas de validacion e integridad
    06_Consultas_Analiticas.sql        <- Consultas analiticas (T-SQL)
  documentacion/
    README.md                          <- Este documento
  SGFood_Proyecto1_Muestra.xlsx        <- Archivo Excel complementario fuente
```
