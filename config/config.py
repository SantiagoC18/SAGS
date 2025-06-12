import os

class Config:
    MYSQL_HOST = 'sags-server.mysql.database.azure.com'
    MYSQL_PORT = 3306
    MYSQL_USER = 'qyqxrjojid'
    MYSQL_PASSWORD = 'Sags2025'  # Reemplaza con tu contraseña real
    MYSQL_DB = 'sags'
    MYSQL_CURSORCLASS = 'DictCursor'
    
    # Configuración SSL requerida para Azure MySQL
    MYSQL_SSL = {
        'ssl_disabled': False,
        'ssl_mode': 'REQUIRED'
    }
    
    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 465
    MAIL_USERNAME = 'softwareanalysissa@gmail.com'
    MAIL_PASSWORD = 'uahw rsnt nqko kzyb'
    MAIL_USE_TLS = False
    MAIL_USE_SSL = True
    
    SECRET_KEY = "4546416vblñvkbmgvlñkbjfgñfglñv.ñ"

class TestingConfig(Config):
    TESTING = True
    MYSQL_DB = 'sags_test'  # Base de datos separada para pruebas
    WTF_CSRF_ENABLED = False  # Desactivar CSRF para pruebas

    