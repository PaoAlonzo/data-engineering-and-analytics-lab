
import pandas as pd
import pyodbc
import logging
from datetime import datetime
from dateutil import parser
import sys
import re
from config import get_connection_string, DATASET_PATH, LOG_CONFIG


# CONFIGURACIÓN DE LOGGING
if LOG_CONFIG['enabled']:
    logging.basicConfig(
        level=getattr(logging, LOG_CONFIG['level']),
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(LOG_CONFIG['log_file'], encoding='utf-8'),
            logging.StreamHandler(sys.stdout)
        ]
    )
else:
    logging.basicConfig(level=logging.INFO, format='%(message)s')

logger = logging.getLogger(__name__)



# FUNCIONES DE EXTRACCIÓN

def extract_data(file_path):

    logger.info("=" * 70)
    logger.info("FASE 1: EXTRACCIÓN DE DATOS")
    logger.info("=" * 70)
    
    try:
        logger.info(f"Leyendo archivo: {file_path}")
        df = pd.read_csv(file_path, encoding='utf-8')
        
        logger.info(f"✓ Registros leídos: {len(df):,}")
        logger.info(f"✓ Columnas encontradas: {len(df.columns)}")
        logger.info(f"  Columnas: {', '.join(df.columns[:5])}...")
        
        return df
        
    except FileNotFoundError:
        logger.error(f"✗ Error: No se encontró el archivo {file_path}")
        sys.exit(1)
    except Exception as e:
        logger.error(f"✗ Error al leer el archivo: {e}")
        sys.exit(1)



# FUNCIONES DE TRANSFORMACIÓN

def parse_datetime_flexible(date_str):

    if pd.isna(date_str) or date_str == '':
        return None
    
    try:
        # Intentar parsear con dateutil (muy flexible)
        return parser.parse(str(date_str), dayfirst=True)
    except:
        try:
            # Intentar formato específico DD/MM/YYYY HH:MM
            return datetime.strptime(str(date_str), '%d/%m/%Y %H:%M')
        except:
            try:
                # Intentar formato MM-DD-YYYY HH:MM AM/PM
                return datetime.strptime(str(date_str), '%m-%d-%Y %I:%M %p')
            except:
                return None


def normalize_gender(gender):

    if pd.isna(gender):
        return None
    
    gender_lower = str(gender).strip().lower()
    
    if gender_lower in ['m', 'masculino', 'male']:
        return 'M'
    elif gender_lower in ['f', 'femenino', 'female']:
        return 'F'
    elif gender_lower in ['x', 'otro', 'other', 'no binario']:
        return 'X'
    else:
        return None


def normalize_airport_code(code):

    if pd.isna(code):
        return None
    return str(code).strip().upper()


def clean_numeric_string(value):

    if pd.isna(value):
        return None
    
    # Convertir a string y limpiar
    value_str = str(value).replace(',', '.').replace(' ', '').strip()
    
    try:
        return float(value_str)
    except:
        return None


def transform_data(df):

    logger.info("\n" + "=" * 70)
    logger.info("FASE 2: TRANSFORMACIÓN DE DATOS")
    logger.info("=" * 70)
    
    df_clean = df.copy()
    initial_count = len(df_clean)
    
    # 1. Limpiar y normalizar códigos de aerolínea
    logger.info("\n1. Normalizando códigos de aerolínea...")
    df_clean['airline_code'] = df_clean['airline_code'].str.strip().str.upper()
    df_clean['airline_name'] = df_clean['airline_name'].str.strip().str.title()
    
    # 2. Normalizar códigos de aeropuerto
    logger.info("2. Normalizando códigos de aeropuerto...")
    df_clean['origin_airport'] = df_clean['origin_airport'].apply(normalize_airport_code)
    df_clean['destination_airport'] = df_clean['destination_airport'].apply(normalize_airport_code)
    
    # 3. Parsear fechas
    logger.info("3. Parseando fechas...")
    df_clean['departure_datetime'] = df_clean['departure_datetime'].apply(parse_datetime_flexible)
    df_clean['arrival_datetime'] = df_clean['arrival_datetime'].apply(parse_datetime_flexible)
    df_clean['booking_datetime'] = df_clean['booking_datetime'].apply(parse_datetime_flexible)
    
    # 4. Normalizar género
    logger.info("4. Normalizando género...")
    df_clean['passenger_gender'] = df_clean['passenger_gender'].apply(normalize_gender)
    
    # 5. Limpiar edad (convertir a entero)
    logger.info("5. Limpiando edad...")
    df_clean['passenger_age'] = pd.to_numeric(df_clean['passenger_age'], errors='coerce')
    
    # 6. Normalizar nacionalidad
    logger.info("6. Normalizando nacionalidad...")
    df_clean['passenger_nationality'] = df_clean['passenger_nationality'].str.strip().str.upper()
    
    # 7. Limpiar precio en USD
    logger.info("7. Limpiando precios...")
    df_clean['ticket_price_usd_est'] = df_clean['ticket_price_usd_est'].apply(clean_numeric_string)
    
    # 8. Normalizar status
    logger.info("8. Normalizando status de vuelo...")
    df_clean['status'] = df_clean['status'].str.strip().str.upper()
    
    # 9. Normalizar cabin_class
    logger.info("9. Normalizando clase de cabina...")
    df_clean['cabin_class'] = df_clean['cabin_class'].str.strip().str.upper()
    
    # 10. Normalizar aircraft_type
    logger.info("10. Normalizando tipo de aeronave...")
    df_clean['aircraft_type'] = df_clean['aircraft_type'].str.strip().str.upper()
    
    # 11. Normalizar sales_channel
    logger.info("11. Normalizando canal de ventas...")
    df_clean['sales_channel'] = df_clean['sales_channel'].str.strip().str.upper()
    
    # 12. Normalizar payment_method
    logger.info("12. Normalizando método de pago...")
    df_clean['payment_method'] = df_clean['payment_method'].str.strip().str.upper()
    
    # 13. Eliminar duplicados por record_id
    logger.info("\n13. Eliminando duplicados...")
    before_dedup = len(df_clean)
    df_clean = df_clean.drop_duplicates(subset=['record_id'], keep='first')
    duplicates_removed = before_dedup - len(df_clean)
    
    if duplicates_removed > 0:
        logger.info(f"   ✓ Duplicados eliminados: {duplicates_removed}")
    else:
        logger.info(f"   ✓ No se encontraron duplicados")
    
    # Resumen de transformación
    logger.info("\n" + "-" * 70)
    logger.info("RESUMEN DE TRANSFORMACIÓN:")
    logger.info(f"  Registros iniciales: {initial_count:,}")
    logger.info(f"  Registros finales: {len(df_clean):,}")
    logger.info(f"  Registros procesados: {len(df_clean):,}")
    logger.info("-" * 70)
    
    return df_clean



# FUNCIONES DE CARGA - DIMENSIONES

def get_db_connection():

    try:
        conn = pyodbc.connect(get_connection_string())
        return conn
    except Exception as e:
        logger.error(f"✗ Error al conectar a la base de datos: {e}")
        sys.exit(1)


def load_dim_aerolinea(df, conn):

    logger.info("\n1. Cargando dim_aerolinea...")
    
    cursor = conn.cursor()
    
    # Obtener aerolíneas únicas
    airlines = df[['airline_code', 'airline_name']].drop_duplicates()
    airlines = airlines.dropna(subset=['airline_code'])
    
    inserted = 0
    for _, row in airlines.iterrows():
        try:
            cursor.execute("""
                IF NOT EXISTS (SELECT 1 FROM dim_aerolinea WHERE airline_code = ?)
                INSERT INTO dim_aerolinea (airline_code, airline_name)
                VALUES (?, ?)
            """, row['airline_code'], row['airline_code'], row['airline_name'])
            inserted += 1
        except Exception as e:
            logger.warning(f"   Error al insertar {row['airline_code']}: {e}")
    
    conn.commit()
    
    # Contar total en la tabla
    cursor.execute("SELECT COUNT(*) FROM dim_aerolinea")
    total = cursor.fetchone()[0]
    
    logger.info(f"   ✓ Aerolíneas únicas en dataset: {len(airlines)}")
    logger.info(f"   ✓ Total en dim_aerolinea: {total}")
    
    cursor.close()


def load_dim_aeropuerto(df, conn):

    logger.info("\n2. Cargando dim_aeropuerto...")
    
    cursor = conn.cursor()
    
    # Obtener aeropuertos únicos de origen y destino
    origin_airports = df['origin_airport'].dropna().unique()
    dest_airports = df['destination_airport'].dropna().unique()
    all_airports = set(list(origin_airports) + list(dest_airports))
    
    inserted = 0
    for airport_code in all_airports:
        try:
            cursor.execute("""
                IF NOT EXISTS (SELECT 1 FROM dim_aeropuerto WHERE airport_code = ?)
                INSERT INTO dim_aeropuerto (airport_code, airport_name)
                VALUES (?, ?)
            """, airport_code, airport_code, airport_code)  # nombre = código por ahora
            inserted += 1
        except Exception as e:
            logger.warning(f"   Error al insertar {airport_code}: {e}")
    
    conn.commit()
    
    # Contar total en la tabla
    cursor.execute("SELECT COUNT(*) FROM dim_aeropuerto")
    total = cursor.fetchone()[0]
    
    logger.info(f"  Aeropuertos únicos en dataset: {len(all_airports)}")
    logger.info(f"  Total en dim_aeropuerto: {total}")
    
    cursor.close()


def load_dim_pasajero(df, conn):

    logger.info("\n3. Cargando dim_pasajero...")
    
    cursor = conn.cursor()
    
    # Obtener pasajeros únicos
    passengers = df[['passenger_id', 'passenger_gender', 'passenger_age', 'passenger_nationality']].drop_duplicates(subset=['passenger_id'])
    passengers = passengers.dropna(subset=['passenger_id'])
    
    inserted = 0
    for _, row in passengers.iterrows():
        try:
            # Convertir age a int si no es NaN
            age = int(row['passenger_age']) if pd.notna(row['passenger_age']) else None
            gender = row['passenger_gender'] if pd.notna(row['passenger_gender']) else None
            nationality = row['passenger_nationality'] if pd.notna(row['passenger_nationality']) else None
            
            cursor.execute("""
                IF NOT EXISTS (SELECT 1 FROM dim_pasajero WHERE passenger_id = ?)
                INSERT INTO dim_pasajero (passenger_id, gender, age, nationality)
                VALUES (?, ?, ?, ?)
            """, row['passenger_id'], row['passenger_id'], gender, age, nationality)
            inserted += 1
        except Exception as e:
            logger.warning(f"   Error al insertar pasajero: {e}")
    
    conn.commit()
    
    # Contar total en la tabla
    cursor.execute("SELECT COUNT(*) FROM dim_pasajero")
    total = cursor.fetchone()[0]
    
    logger.info(f"   Pasajeros únicos en dataset: {len(passengers)}")
    logger.info(f"   Total en dim_pasajero: {total}")
    
    cursor.close()


def load_dim_avion(df, conn):

    logger.info("\n4. Cargando dim_avion...")
    
    cursor = conn.cursor()
    
    # Obtener combinaciones únicas de aircraft_type y cabin_class
    aircraft = df[['aircraft_type', 'cabin_class']].drop_duplicates()
    aircraft = aircraft.dropna()
    
    inserted = 0
    for _, row in aircraft.iterrows():
        try:
            cursor.execute("""
                IF NOT EXISTS (SELECT 1 FROM dim_avion WHERE aircraft_type = ? AND cabin_class = ?)
                INSERT INTO dim_avion (aircraft_type, cabin_class)
                VALUES (?, ?)
            """, row['aircraft_type'], row['cabin_class'], row['aircraft_type'], row['cabin_class'])
            inserted += 1
        except Exception as e:
            logger.warning(f"   Error al insertar avión: {e}")
    
    conn.commit()
    
    # Contar total en la tabla
    cursor.execute("SELECT COUNT(*) FROM dim_avion")
    total = cursor.fetchone()[0]
    
    logger.info(f"  Combinaciones únicas en dataset: {len(aircraft)}")
    logger.info(f"  Total en dim_avion: {total}")
    
    cursor.close()



# FUNCIONES DE CARGA - TABLA DE HECHOS


def get_date_id(date_obj):

    if pd.isna(date_obj) or date_obj is None:
        return None
    return int(date_obj.strftime('%Y%m%d'))


def load_fact_vuelo(df, conn):

    logger.info("\n5. Cargando fact_vuelo...")
    logger.info("   Este proceso puede tomar varios minutos...")
    
    cursor = conn.cursor()
    
    # Limpiar tabla de hechos (para re-ejecuciones)
    cursor.execute("DELETE FROM fact_vuelo")
    conn.commit()
    logger.info("    Tabla fact_vuelo limpiada")
    
    inserted = 0
    errors = 0
    batch_size = 100
    
    for idx, row in df.iterrows():
        try:
            # Obtener IDs de dimensiones
            
            # airline_id
            cursor.execute("SELECT airline_id FROM dim_aerolinea WHERE airline_code = ?", 
                          row['airline_code'])
            airline_result = cursor.fetchone()
            airline_id = airline_result[0] if airline_result else None
            
            # origin_airport_id
            cursor.execute("SELECT airport_id FROM dim_aeropuerto WHERE airport_code = ?", 
                          row['origin_airport'])
            origin_result = cursor.fetchone()
            origin_airport_id = origin_result[0] if origin_result else None
            
            # destination_airport_id
            cursor.execute("SELECT airport_id FROM dim_aeropuerto WHERE airport_code = ?", 
                          row['destination_airport'])
            dest_result = cursor.fetchone()
            destination_airport_id = dest_result[0] if dest_result else None
            
            # passenger_key
            cursor.execute("SELECT passenger_key FROM dim_pasajero WHERE passenger_id = ?", 
                          row['passenger_id'])
            passenger_result = cursor.fetchone()
            passenger_key = passenger_result[0] if passenger_result else None
            
            # aircraft_id
            cursor.execute("SELECT aircraft_id FROM dim_avion WHERE aircraft_type = ? AND cabin_class = ?", 
                          row['aircraft_type'], row['cabin_class'])
            aircraft_result = cursor.fetchone()
            aircraft_id = aircraft_result[0] if aircraft_result else None
            
            # Validar que tengamos las claves foráneas mínimas requeridas
            if not all([airline_id, origin_airport_id, destination_airport_id, passenger_key, aircraft_id]):
                errors += 1
                continue
            
            # date_ids
            departure_date_id = get_date_id(row['departure_datetime'])
            arrival_date_id = get_date_id(row['arrival_datetime'])
            booking_date_id = get_date_id(row['booking_datetime'])
            
            # Insertar en fact_vuelo
            cursor.execute("""
                INSERT INTO fact_vuelo (
                    record_id, airline_id, origin_airport_id, destination_airport_id,
                    passenger_key, aircraft_id, departure_date_id, arrival_date_id, booking_date_id,
                    flight_number, departure_datetime, arrival_datetime, duration_min,
                    status, delay_min, seat, booking_datetime, sales_channel, payment_method,
                    ticket_price_usd, bags_total, bags_checked
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, 
                row['record_id'], airline_id, origin_airport_id, destination_airport_id,
                passenger_key, aircraft_id, departure_date_id, arrival_date_id, booking_date_id,
                row['flight_number'], 
                row['departure_datetime'] if pd.notna(row['departure_datetime']) else None,
                row['arrival_datetime'] if pd.notna(row['arrival_datetime']) else None,
                int(row['duration_min']) if pd.notna(row['duration_min']) else None,
                row['status'],
                int(row['delay_min']) if pd.notna(row['delay_min']) else None,
                row['seat'] if pd.notna(row['seat']) else None,
                row['booking_datetime'] if pd.notna(row['booking_datetime']) else None,
                row['sales_channel'] if pd.notna(row['sales_channel']) else None,
                row['payment_method'] if pd.notna(row['payment_method']) else None,
                row['ticket_price_usd_est'] if pd.notna(row['ticket_price_usd_est']) else None,
                int(row['bags_total']) if pd.notna(row['bags_total']) else None,
                int(row['bags_checked']) if pd.notna(row['bags_checked']) else None
            )
            
            inserted += 1
            
            # Commit cada batch_size registros
            if inserted % batch_size == 0:
                conn.commit()
                logger.info(f"   Progreso: {inserted:,} registros insertados...")
                
        except Exception as e:
            errors += 1
            if errors < 10:  # Solo mostrar primeros 10 errores
                logger.warning(f"   Error en registro {idx}: {e}")
    
    conn.commit()
    
    # Contar total en la tabla
    cursor.execute("SELECT COUNT(*) FROM fact_vuelo")
    total = cursor.fetchone()[0]
    
    logger.info(f"\n    Registros insertados: {inserted:,}")
    if errors > 0:
        logger.info(f"    Registros con errores: {errors:,}")
    logger.info(f"    Total en fact_vuelo: {total:,}")
    
    cursor.close()


# FUNCIÓN PRINCIPAL

def main():
    """
    Función principal que ejecuta todo el proceso ETL
    """
    start_time = datetime.now()
    
    logger.info("\n" + "=" * 70)
    logger.info("PROCESO ETL - ANÁLISIS DE VUELOS")
    logger.info("Práctica 1 - Seminario de Sistemas 2")
    logger.info(f"Inicio: {start_time.strftime('%Y-%m-%d %H:%M:%S')}")
    logger.info("=" * 70)
    
    try:
        # FASE 1: EXTRACCIÓN
        df = extract_data(DATASET_PATH)
        
        # FASE 2: TRANSFORMACIÓN
        df_clean = transform_data(df)
        
        # FASE 3: CARGA
        logger.info("\n" + "=" * 70)
        logger.info("FASE 3: CARGA DE DATOS")
        logger.info("=" * 70)
        
        # Conectar a la base de datos
        logger.info("\nConectando a SQL Server...")
        conn = get_db_connection()
        logger.info("✓ Conexión establecida")
        
        # Cargar dimensiones
        logger.info("\nCARGANDO DIMENSIONES:")
        logger.info("-" * 70)
        load_dim_aerolinea(df_clean, conn)
        load_dim_aeropuerto(df_clean, conn)
        load_dim_pasajero(df_clean, conn)
        load_dim_avion(df_clean, conn)
        
        # Cargar tabla de hechos
        logger.info("\nCARGANDO TABLA DE HECHOS:")
        logger.info("-" * 70)
        load_fact_vuelo(df_clean, conn)
        
        # Cerrar conexión
        conn.close()
        logger.info("\n✓ Conexión cerrada")
        
        # RESUMEN FINAL
        end_time = datetime.now()
        duration = end_time - start_time
        
        logger.info("\n" + "=" * 70)
        logger.info("PROCESO ETL COMPLETADO EXITOSAMENTE")
        logger.info("=" * 70)
        logger.info(f"Inicio:    {start_time.strftime('%Y-%m-%d %H:%M:%S')}")
        logger.info(f"Fin:       {end_time.strftime('%Y-%m-%d %H:%M:%S')}")
        logger.info(f"Duración:  {duration}")
        logger.info("=" * 70)
        
        return 0
        
    except Exception as e:
        logger.error(f"\n✗ ERROR CRÍTICO: {e}")
        logger.error("El proceso ETL ha fallado.")
        import traceback
        logger.error(traceback.format_exc())
        return 1


if __name__ == "__main__":
    sys.exit(main())
