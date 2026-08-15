

# Diseño de Dashboard y KPIs con Power BI

## 1. Descripción general

En esta práctica se conectó Power BI Desktop a la base de datos relacional en SQL Server creada en la Práctica 1 para construir un modelo tabular y un dashboard interactivo de vuelos.

El objetivo fue transformar datos operativos en indicadores clave (KPIs) para apoyar la toma de decisiones mediante visualizaciones claras.

## 2. Problema que se resolvió

Los datos transaccionales por sí solos no facilitan el análisis estratégico. Por eso se diseñó un modelo de análisis y un tablero que permite responder preguntas como:

- Cuántos vuelos se realizaron.
- Cuál fue el retraso acumulado.
- Qué aerolíneas y aeropuertos concentran mayor operación o mayor retraso.
- Cómo cambia el volumen de vuelos en el tiempo.

## 3. Alcance cumplido

Se completaron los siguientes puntos obligatorios:

- Conexión de Power BI a la base de datos en SQL Server de la práctica anterior.
- Diseño de un modelo tabular con relaciones entre tablas y jerarquías en dimensiones.
- Creación de medidas DAX para indicadores principales.
- Construcción de dashboard con varias visualizaciones interactivas.
- Uso de formato condicional en tarjetas KPI para reflejar desempeño mediante indicador visual tipo semáforo.
- Documentación del diseño y la interpretación de resultados en este README.

## 4. Modelo de datos

Se implementó un esquema estrella:

- Tabla de hechos: fact_vuelo.
- Dimensiones: dim_fecha, dim_aerolinea, dim_pasajero, dim_avion, dim_aeropuerto.

![Diagrama del Modelo de Datos](image/db.jpg)

La tabla fact_vuelo centraliza métricas operativas (duración, retraso, identificadores de vuelo) y se relaciona con dimensiones descriptivas para facilitar análisis por tiempo, aerolínea y aeropuerto.

Dentro de la dimensión `dim_fecha` se definió una jerarquía temporal para facilitar el análisis y la navegación en las visualizaciones. La jerarquía utilizada fue:

- Año
- Mes
- Día

![Jerarquia](image/her.jpg)

## 5. Medidas DAX implementadas

Las medidas principales usadas en el dashboard fueron:

1. Total de vuelos

   Total Vuelos = COUNT(fact_vuelo[flight_id])

2. Promedio de duración

   Promedio Duración = AVERAGE(fact_vuelo[duration_min])

3. Total de retraso

   Total Delay = SUM(fact_vuelo[delay_min])

4. Total pasajeros

   Total Pasajeros = SUM(fact_vuelo[passenger_key])

5. KPI de vuelos por año

   Vuelos por Año =
   CALCULATE(
   [Total Vuelos],
   ALLEXCEPT(dim_fecha, dim_fecha[anio])
   )

## 6. Dashboard desarrollado

El dashboard incluye, como mínimo, las siguientes visualizaciones:

- Tarjetas con formato condicional para representar un semáforo visual de desempeño.
- Tarjeta KPI de Total de Vuelos.
- Tarjeta KPI de Promedio de Duración.
- Tarjeta KPI de Total de Retraso.

![Semaforo](image/semaforo.jpg)

- Gráfico circular de total de vuelos por aerolínea.

![Gráfico Circular](image/vuelos.jpg)

- Gráfico de barras de retraso acumulado por aerolínea.

![Gráfico de Barras](image/delay.jpg)

- Serie temporal de vuelos por año, mes y día.

![Serie Temporal](image/serie5.jpg)

- Gráfico combinado (columnas y línea) de vuelos y retraso por aeropuerto.

![Gráfico Combinado](image/del.jpg)

El semáforo visual se implementó mediante colores condicionales en las tarjetas KPI para facilitar una lectura rápida del estado de los indicadores:

- Verde: comportamiento favorable.
- Amarillo: indicador en observación.
- Rojo: indicador crítico.

Estas vistas permiten analizar tanto distribución (por aerolínea y aeropuerto) como comportamiento temporal.

## 7. Interpretación de resultados

Con este tablero se puede identificar:

- Qué aerolíneas tienen mayor volumen de vuelos.
- Qué aerolíneas acumulan más minutos de retraso.
- Qué aeropuertos presentan mejor o peor equilibrio entre operación y puntualidad.
- Variaciones de demanda y operación a lo largo del tiempo.

Esto facilita priorizar acciones de mejora operativa y monitorear desempeño con indicadores cuantificables.

La jerarquía temporal permite profundizar desde una vista anual hasta detalle por día, mientras que el semáforo visual ayuda a identificar rápidamente indicadores en estado favorable, intermedio o crítico para apoyar decisiones estratégicas.

## 8. Requerimientos técnicos utilizados

- Fuente de datos: base de datos relacional de la Práctica 1 en SQL Server.
- Herramienta de análisis: Microsoft Power BI Desktop.
- Lenguaje de expresiones: DAX.
- Conocimientos aplicados: modelado tabular, relaciones, jerarquías, medidas, KPIs y visualización de datos.

## 9. Conclusión

El modelo estrella y las medidas DAX permiten análisis multidimensional, mientras que el dashboard resume el estado operativo en indicadores claros e interactivos.
