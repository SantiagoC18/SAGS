class Config:
    MYSQL_HOST = 'sags-server.mysql.database.azure.com'
    MYSQL_USER = 'qyqxrjojid'
    MYSQL_PASSWORD = 'Sags2025'
    MYSQL_DB = 'sags'
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
    MYSQL_DB = 'sags_test'  # Base de datos separada para pruebas
    WTF_CSRF_ENABLED = False  # Desactivar CSRF para pruebas

    