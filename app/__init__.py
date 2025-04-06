from flask import Flask
from flask_mysqldb import MySQL
from flask_mail import Mail
from config.config import Config

mysql = MySQL()
gmail = Mail()

def create_app():
    app = Flask(__name__, template_folder='templates')
    app.config.from_object(Config)
    
    mysql.init_app(app)
    gmail.init_app(app)
    
    from app.routes import auth, profile, password, projects, main
    app.register_blueprint(main.bp)
    app.register_blueprint(auth.bp)
    app.register_blueprint(profile.bp)
    app.register_blueprint(password.bp)
    app.register_blueprint(projects.bp)
    
    
    return app