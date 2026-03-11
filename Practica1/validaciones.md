# Resumen de Validación - Consultas Analíticas

**Práctica 1: ETL con Python - Análisis de Vuelos**

**Estudiante:** Claudia Paola Alonzo Hernández

**Carnet:** 201902246

## 1. Validación de Carga de Datos

### 1.1 Conteo de Registros por Tabla

| Tabla          | Total de Registros |
| -------------- | ------------------ |
| dim_aerolinea  | 12                 |
| dim_aeropuerto | 15                 |
| dim_pasajero   | 10,000             |
| dim_avion      | 48                 |
| dim_fecha      | 4,018              |
| **fact_vuelo** | **10,000**         |

**Estado:** Todos los registros del dataset (10,000) fueron cargados exitosamente.

### 1.2 Verificación de Integridad Referencial

- Vuelos sin aerolínea: **0**
- Vuelos sin aeropuerto origen: **0**
- Vuelos sin aeropuerto destino: **0**
- Vuelos sin pasajero: **0**

**Estado:** Integridad referencial verificada correctamente.

## 2. Indicadores de Negocio

### 2.1 Top 5 Aerolíneas con Más Vuelos

| Código | Aerolínea     | Total de Vuelos |
| ------ | ------------- | --------------- |
| CM     | Copa Airlines | 888             |
| WN     | Southwest     | 868             |
| IB     | Iberia        | 867             |
| B6     | Jetblue       | 853             |
| FR     | Ryanair       | 850             |

### 2.2 Distribución por Estado de Vuelo

| Estado    | Total de Vuelos | Porcentaje |
| --------- | --------------- | ---------- |
| ON_TIME   | 7,278           | 72.78%     |
| DELAYED   | 1,970           | 19.70%     |
| CANCELLED | 560             | 5.60%      |
| DIVERTED  | 192             | 1.92%      |

**Análisis:** El 72.78% de los vuelos llegaron a tiempo, mientras que aproximadamente el 20% sufrieron retrasos.

### 2.3 Distribución por Género de Pasajeros

| Género          | Total de Vuelos |
| --------------- | --------------- |
| Masculino       | 4,912           |
| Femenino        | 4,698           |
| Otro            | 346             |
| No especificado | 44              |

**Análisis:** Distribución equilibrada entre géneros, con leve mayoría masculina.

---

## 3. Consultas Analíticas Ejecutadas

El archivo [consultas.sql](consultas.sql) incluye secciones de análisis:

1. **Validación de Datos**
   - Conteo de registros por tabla
   - Verificación de integridad referencial

2. **Análisis de Vuelos**
   - Total de vuelos
   - Top 10 aerolíneas
   - Top 10 rutas más frecuentes
   - Top 10 destinos más populares
   - Top 10 orígenes más frecuentes

3. **Análisis de Estado de Vuelos**
   - Distribución por estado
   - Análisis de demoras (promedio, mínimo, máximo)
   - Aerolíneas con más demoras
   - Vuelos cancelados por aerolínea

4. **Análisis de Pasajeros**
   - Distribución por género
   - Distribución por rango de edad
   - Top 10 nacionalidades con más vuelos

5. **Análisis Financiero**
   - Resumen de ventas
   - Ventas por canal de venta
   - Ventas por método de pago
   - Top 10 aerolíneas por ingresos

6. **Análisis de Clase de Cabina**
   - Distribución por clase
   - Top 10 tipos de aeronave más utilizados

7. **Análisis Temporal**
   - Vuelos por año
   - Vuelos por mes
   - Vuelos por día de la semana

8. **Análisis de Equipaje**
   - Distribución de equipaje total
   - Promedio de equipaje por clase de cabina

9. **Consultas Complejas**
   - Perfil del viajero frecuente (Top 10)
   - Top 10 rutas más rentables
   - Comparación de puntualidad por aerolínea

---

## 4. Archivos de Resultados

- **Archivo de resultados completos:** [resultados_consultas.txt](resultados_consultas.txt)
- **Tamaño:** 29 KB
- **Número de consultas ejecutadas:** 24+
- **Todas las consultas ejecutadas exitosamente:**

---

## 5. Conclusiones de Validación

1. **Extracción:** El proceso leyó correctamente 10,000 registros del dataset CSV.

2. **Transformación:** Todos los datos fueron limpiados, normalizados y estandarizados:
   - Fechas parseadas en múltiples formatos
   - Códigos de aeropuerto normalizados (mayúsculas)
   - Género estandarizado (M, F, X)
   - Sin duplicados encontrados

3. **Carga:** Los 10,000 registros fueron insertados exitosamente en SQL Server:
   - Integridad referencial mantenida
   - Todas las dimensiones pobladas correctamente
   - Tabla de hechos con relaciones válidas

4. **Consultas Analíticas:** Todas las consultas ejecutadas exitosamente demuestran:
   - Modelo multidimensional funcional
   - Datos consistentes y válidos
   - Capacidad de generar indicadores de negocio útiles

---

## 6. Tiempo de Ejecución del ETL

- **Duración total:** 1 minuto 54 segundos
- **Registros procesados:** 10,000
- **Velocidad promedio:** ~85 registros/segundo

---

**Estado Final:** Validacion completada
