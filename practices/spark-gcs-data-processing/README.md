#  Procesamiento de Datos con Apache Spark y Google Cloud Storage

**Nombre:** Claudia Paola Alonzo Hernández

## Descripción

Implementación de un proceso de procesamiento de datos utilizando **Apache Spark (PySpark)** y **Google Cloud Storage (GCS)**.

El objetivo de la práctica es integrar una herramienta de procesamiento distribuido como Apache Spark con un servicio de almacenamiento en la nube como Google Cloud Storage, permitiendo trabajar con datos almacenados mediante rutas utilizando el protocolo `gs://`.

El proyecto utiliza `SparkSession` como punto de entrada para ejecutar el proceso de Spark y trabajar con los datos mediante DataFrames.


## Objetivos

- Configurar un entorno de procesamiento utilizando PySpark.
- Crear y utilizar una `SparkSession`.
- Establecer comunicación entre Apache Spark y Google Cloud Storage.
- Acceder a datos almacenados en Google Cloud Storage.
- Procesar información utilizando DataFrames de PySpark.
- Utilizar rutas `gs://` para trabajar con objetos almacenados en GCS.
- Integrar procesamiento de datos local con almacenamiento en la nube.
- Aplicar conceptos básicos de procesamiento distribuido de datos.
- Validar la correcta ejecución del proceso y el almacenamiento de los resultados.


## Tecnologías Utilizadas

- **Python 3**
- **Apache Spark**
- **PySpark**
- **Google Cloud Platform (GCP)**
- **Google Cloud Storage (GCS)**
- **Google Cloud SDK**
- **Hadoop GCS Connector**


## Arquitectura

El flujo general de la práctica se puede representar de la siguiente manera:

```text
                    Google Cloud Platform
┌──────────────────────────────────────────────────────────┐
│                                                          │
│   ┌───────────────────┐                                  │
│   │ Google Cloud      │                                  │
│   │ Storage           │                                  │
│   │                   │                                  │
│   │ Datos / Bucket    │                                  │
│   └─────────┬─────────┘                                  │
│             │                                            │
│             │ gs://                                      │
│             ▼                                            │
│   ┌─────────────────────────────────────────────┐        │
│   │              Apache Spark                  │        │
│   │                                             │        │
│   │  SparkSession                              │        │
│   │       ↓                                     │        │
│   │  DataFrame                                  │        │
│   │       ↓                                     │        │
│   │  Procesamiento / Transformaciones            │        │
│   └─────────────────────┬───────────────────────┘        │
│                         │                                │
│                         │ Resultado                      │
│                         ▼                                │
│   ┌─────────────────────────────────────────────┐        │
│   │ Google Cloud Storage                        │        │
│   │                                             │        │
│   │ Datos procesados                            │        │
│   └─────────────────────────────────────────────┘        │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

## Conclusiones

La práctica permitió implementar un flujo básico de procesamiento de datos utilizando Apache Spark y Google Cloud Storage.

La integración permitió comprender cómo un motor de procesamiento como PySpark puede trabajar con datos almacenados en la nube y cómo los servicios cloud pueden incorporarse dentro de procesos de ingeniería de datos.

El ejercicio también permitió reforzar conceptos relacionados con procesamiento distribuido, DataFrames, almacenamiento de objetos y comunicación entre herramientas de procesamiento y servicios cloud.

## Referencias
- Apache Spark Documentation
- PySpark Documentation
- PySpark DataFrames
- Google Cloud Storage Documentation
- Google Cloud SDK Documentation

