# Práctica 1: ETL con Python - Análisis de Vuelos

**Curso:** Seminario de Sistemas 2

**Nombre:** Claudia Paola Alonzo Hernández

**Carnet:** 201902246

## Descripción

Implementación de un proceso ETL (Extracción, Transformación y Carga) completo utilizando Python y SQL Server para analizar datos de vuelos. El proyecto incluye:

- Extracción de datos desde CSV
- Transformación y limpieza de datos
- Modelo multidimensional de inteligencia de negocios
- Carga de datos en SQL Server
- Consultas analíticas

## Objetivos

- Desarrollar un proceso ETL funcional en Python
- Implementar un modelo multidimensional para análisis de vuelos
- Generar indicadores de negocio mediante consultas SQL
- Aplicar buenas prácticas de ingeniería de datos

## Estructura del Proyecto

```
Practica1/
├── dataset_vuelos_crudo.csv      # Dataset original
├── create_database.sql            # Script de creación de BD
├── etl-vuelos.py                  # Script ETL principal ✅
├── consultas.sql                  # Consultas SQL ✅
├── config.py                      # Configuración de conexión
├── test_setup.py                  # Script de prueba
├── requirements.txt               # Dependencias Python
├── GUIA_EJECUCION.md             # Guía detallada de ejecución
├── INSTRUCCIONES_SETUP.md        # Guía de configuración
└── README.md                      # Este archivo
```

## Modelo de Datos

### Dimensiones:

- **dim_aerolinea**: Información de aerolíneas
- **dim_aeropuerto**: Catálogo de aeropuertos
- **dim_pasajero**: Datos de pasajeros
- **dim_fecha**: Dimensión temporal
- **dim_avion**: Tipos de aeronave y clase de cabina

### Tabla de Hechos:

- **fact_vuelo**: Registro de cada vuelo con métricas y relaciones

## Instalación y Configuración

### 1. Requisitos Previos

- Python 3.10 o superior
- Microsoft SQL Server
- Driver ODBC para SQL Server

### 2. Configurar Entorno Virtual

```powershell
# Navegar a la carpeta del proyecto
cd Practica1

# Crear entorno virtual
python -m venv .venv

# Activar entorno virtual
.\.venv\Scripts\Activate.ps1

# Instalar dependencias
pip install -r requirements.txt
```

### 3. Configurar Base de Datos

```powershell
# Ejecutar el script SQL en SQL Server Management Studio
# o mediante sqlcmd:
sqlcmd -S localhost -i create_database.sql
```

## Problemas Identificados en el Dataset

### 1. **Formatos de Fecha Inconsistentes**

- Formato 1: `DD/MM/YYYY HH:MM`
- Formato 2: `MM-DD-YYYY HH:MM AM/PM`

### 2. **Códigos de Aeropuerto**

- Algunos en minúsculas: `jfk`, `sjo`, `hav`
- Deben estandarizarse a mayúsculas

### 3. **Género Inconsistente**

- Valores encontrados: `M`, `F`, `X`, `Masculino`, `Femenino`, `m`, `masculino`
- Se normalizarán a: `M`, `F`, `X`

### 4. **Valores Nulos**

- Edad de pasajeros
- Nacionalidad
- Información de vuelos cancelados

### 5. **Nombres de Aerolíneas**

- Formato inconsistente (mayúsculas/minúsculas)

## Proceso ETL

### Extracción

- Lectura del archivo CSV `dataset_vuelos_crudo.csv`
- Validación de estructura y columnas

### Transformación

1. Limpieza de datos nulos y duplicados
2. Estandarización de formatos de fecha
3. Normalización de códigos de aeropuerto (UPPER)
4. Homologación de valores de género
5. Conversión de monedas a USD
6. Creación de dimensiones y tabla de hechos

### Carga

1. Inserción de dimensiones (sin duplicados)
2. Obtención de claves foráneas
3. Carga de tabla de hechos con relaciones
   ✅

El archivo `consultas.sql` incluye 9 secciones completas de análisis:

### Sección 1: Validación de Datos

- Conteo de registros por tabla
- Verificación de integridad referencial

### Sección 2: Análisis de Vuelos

- Total de vuelos registrados
- Top 10 aerolíneas con más vuelos
- Top 10 rutas más frecuentes
- Top 10 destinos más populares
- Top 10 orígenes más frecuentes

### Sección 3: Análisis de Estado de Vuelos

- Distribución por estado (ON_TIME, DELAYED, CANCELLED, DIVERTED)
- Análisis de demoras (promedio, mínimo, máximo)
- Aerolíneas con más demoras
- Vuelos cancelados por aerolínea

### Sección 4: Análisis de Pasajeros

- Distribución por género
- Distribución por rango de edad
- Top 10 nacionaliProyecto

### Paso 1: Configurar Base de Datos

```powershell
# Ejecutar en SQL Server Management Studio (SSMS)
# Abrir y ejecutar: create_database.sql
```

### Paso 2: Verificar Configuración (Opcional)

```powershell
# AcCaracterísticas del ETL Implementado

### Extracción
- ✅ Lectura robusta del CSV con manejo de encoding UTF-8
- ✅ Validación de estructura y registros

### Transformación
- ✅ Parseo flexible de fechas (múltiples formatos soportados)
- ✅ Normalización de códigos de aeropuerto (a mayúsculas)
- ✅ Normalización de género (M, F, X)
- ✅ Limpieza de precios (eliminación de comas, conversión a float)
- ✅ Estandarización de códigos de aerolínea y nombres
- ✅ Normalización de status, cabin_class, payment_method
- ✅ Eliminación de duplicados por record_id
- ✅ Manejo de valores nulos

### Carga
- ✅ Carga incremental de dimensiones (evita duplicados)
- ✅ Validación de claves foráneas antes de insertar en fact_vuelo
- ✅ Inserción por lotes para optimizar rendimiento
- ✅ Logging detallado del proceso
- ✅ Manejo de excepciones y errores
- ✅ Resumen de estadísticas al finalizar

### Características Adicionales
- ✅ Sistema de logging completo (archivo + consola)
- ✅ Contador de progreso durante la carga
- ✅ Reporte de tiempo de ejecución
- ✅ Limpieza automática de fact_vuelo en re-ejecuciones
# Ejecutar pruebas
python test_setup.py
```

### Paso 3: Ejecutar ETL

```powershell
# Activar entorno virtual (si no está activo)
.\.venv\Scripts\Activate.ps1

# Ejecutar el script ETL
python etl-vuelos.py

# Tiempo estimado: 5-15 minutos
# Se generará un archivo etl_vuelos.log con el detalle del proceso
```

### Paso 4: Ejecutar Consultas Analíticas

```powershell
# Desde SSMS: Abrir y ejecutar consultas.sql
# O desde PowerShell:
sqlcmd -S localhost -d DW_Vuelos -i consultas.sql -o resultados.txt
```

### 📖 Documentación Detallada

- **[GUIA_EJECUCION.md](GUIA_EJECUCION.md)**: Guía completa paso a paso de ejecución
- **[INSTRUCCIONES_SETUP.md](INSTRUCCIONES_SETUP.md)**: Instrucciones de configuración inicial Sección 6: Análisis de Clase de Cabina
- Distribución por clase (ECONOMY, BUSINESS, PREMIUM_ECONOMY, FIRST)
- Top 10 tipos de aeronave más utilizados

### Sección 7: Análisis Temporal

- Vuelos por año
- Vuelos por mes
- Vuelos por día de la semana

### Sección 8: Análisis de Equipaje

- Distribución de equipaje total
- Promedio de equipaje por clase de cabina

### Sección 9: Consultas Complejas

- Perfil del viajero frecuente (Top 10)
- Top 10 rutas más rentables
- Comparación de puntualidad por aerolíneaELAYED, CANCELLED)
- Análisis de demoras promedio
- Distribución por género de pasajeros
- Ventas por canal (APP, WEB, AEROPUERTO, etc.)

## Tecnologías Utilizadas

- **Python 3.10+**
- **Pandas**: Manipulación de datos
- **PyODBC**: Conexión con SQL Server
- **SQLAlchemy**: ORM y gestión de conexiones
- **SQL Server**: Base de datos relacional

## Ejecución del ETL

```powershell
# Activar entorno virtual
.\.venv\Scripts\Activate.ps1

# Ejecutar el script ETL
python etl_vuelos.py
```

## Resultados Esperados

(Se actualizará con los resultados del análisis)

## Referencias

- [Documentación de Pandas](https://pandas.pydata.org/docs/)
- [PyODBC Documentation](https://github.com/mkleehammer/pyodbc/wiki)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [Kimball Group - Dimensional Modeling](https://www.kimballgroup.com/)
