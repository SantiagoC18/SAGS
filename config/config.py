class Config:
    # Configuración para JawsDB
    MYSQL_HOST = 'de1tmi3t63foh7fa.cbetxkdyhwsb.us-east-1.rds.amazonaws.com'
    MYSQL_USER = 'yfyw3czu6mbscgey'
    MYSQL_PASSWORD = 'jxwgj4plyxinqi99'
    MYSQL_DB = 'dh0l4qmc7zfsvlhk'
    MYSQL_CURSORCLASS = 'DictCursor'
    
    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 465
    MAIL_USERNAME = 'softwareanalysissa@gmail.com'
    MAIL_PASSWORD = 'uahw rsnt nqko kzyb'
    MAIL_USE_TLS = False
    MAIL_USE_SSL = True
    
    SECRET_KEY = "4546416vblñvkbmgvlñkbjfgñfglñv.ñ"

class TestingConfig(Config):
    TESTING = True
    MYSQL_DB = 'dh0l4qmc7zfsvlhk'  # Usar la misma base de datos de JawsDB para pruebas
    WTF_CSRF_ENABLED = False  # Desactivar CSRF para pruebas