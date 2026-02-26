
# CONFIGURACIÓN DE CONEXIÓN A SQL SERVER


# Configuración del servidor SQL Server
DB_CONFIG = {
    'server': 'localhost',  
    'database': 'DW_Vuelos',
    'driver': 'ODBC Driver 17 for SQL Server',  # Cambiar según el driver instalado
    'trusted_connection': True  # True para autenticación de Windows
}



# Genera el string de conexión para pyodbc

def get_connection_string():

    if DB_CONFIG.get('trusted_connection'):
        conn_str = (
            f"DRIVER={{{DB_CONFIG['driver']}}};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            f"Trusted_Connection=yes;"
        )
    else:
        conn_str = (
            f"DRIVER={{{DB_CONFIG['driver']}}};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            f"UID={DB_CONFIG['username']};"
            f"PWD={DB_CONFIG['password']};"
        )
    return conn_str


def get_sqlalchemy_url():

    from urllib.parse import quote_plus
    conn_str = get_connection_string()
    return f"mssql+pyodbc:///?odbc_connect={quote_plus(conn_str)}"



# CONFIGURACIÓN DEL DATASET

DATASET_PATH = 'dataset_vuelos_crudo.csv'


# CONFIGURACIÓN DE LOGS

LOG_CONFIG = {
    'enabled': True,
    'log_file': 'etl_vuelos.log',
    'level': 'INFO'  # DEBUG, INFO, WARNING, ERROR
}
