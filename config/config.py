import os

class Config:
    # Configuración para base de datos
    MYSQL_HOST = os.environ.get('MYSQL_HOST', 'localhost')
    MYSQL_USER = os.environ.get('MYSQL_USER', 'root')
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD', '')
    MYSQL_DB = os.environ.get('MYSQL_DB', 'sags')
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
    MYSQL_DB = 'sags_test'  # Base de datos separada para pruebas
    WTF_CSRF_ENABLED = False  # Desactivar CSRF para pruebas