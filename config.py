import os

class Config:
<<<<<<< HEAD
    # Configuración para JawsDB
    MYSQL_HOST = 'de1tmi3t63foh7fa.cbetxkdyhwsb.us-east-1.rds.amazonaws.com'
    MYSQL_USER = 'yfyw3czu6mbscgey'
    MYSQL_PASSWORD = 'jxwgj4plyxinqi99'
    MYSQL_DB = 'dh0l4qmc7zfsvlhk'
=======
    # Configuración para base de datos
    MYSQL_HOST = os.environ.get('MYSQL_HOST', 'localhost')
    MYSQL_USER = os.environ.get('MYSQL_USER', 'root')
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD', '')
    MYSQL_DB = os.environ.get('MYSQL_DB', 'sags')
>>>>>>> c4b740a62ca08cda00090f5b885ff1870e80407e
    MYSQL_CURSORCLASS = 'DictCursor'
    
    # Configuración para correo
    MAIL_SERVER = os.environ.get('MAIL_SERVER', 'smtp.gmail.com')
    MAIL_PORT = int(os.environ.get('MAIL_PORT', 465))
    MAIL_USERNAME = os.environ.get('MAIL_USERNAME', 'softwareanalysissa@gmail.com')
    MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD', 'uahw rsnt nqko kzyb')
    MAIL_USE_TLS = False
    MAIL_USE_SSL = True
    
    SECRET_KEY = os.environ.get('SECRET_KEY', "4546416vblñvkbmgvlñkbjfgñfglñv.ñ")

class TestingConfig(Config):
    TESTING = True
    MYSQL_DB = 'dh0l4qmc7zfsvlhk'  # Usar la misma base de datos de JawsDB para pruebas
    WTF_CSRF_ENABLED = False  # Desactivar CSRF para pruebas