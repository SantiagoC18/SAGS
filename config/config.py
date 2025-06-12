import os

class Config:
    MYSQL_HOST = 'sags-server.mysql.database.azure.com'
    MYSQL_PORT = 3306
    MYSQL_USER = 'qyqxrjojid'
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD')
    MYSQL_DB = 'sags'
    MYSQL_CURSORCLASS = 'DictCursor'

    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 465
    MAIL_USERNAME = os.environ.get('MAIL_USERNAME')
    MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD')
    MAIL_USE_TLS = False
    MAIL_USE_SSL = True

    SECRET_KEY = os.environ.get('SECRET_KEY')