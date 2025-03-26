from flask import Flask
from flask import render_template, redirect, request, Response, session, url_for, flash
from flask_mysqldb import MySQL, MySQLdb
from flask_mail import Mail, Message
from flask import Flask, render_template, request, jsonify
import sqlite3

import secrets
from datetime import datetime, timedelta

def create_app(config_class=Config):
    app = Flask(__name__, template_folder='templates')
    
    # Load configuration
    app.config.from_object(config_class)
    
    # Initialize extensions
    init_extensions(app)
    
    # Register blueprints
    from .routes import auth, main, projects, profile
    app.register_blueprint(auth.bp)
    app.register_blueprint(main.bp)
    app.register_blueprint(projects.bp)
    app.register_blueprint(profile.bp)
    
    return app