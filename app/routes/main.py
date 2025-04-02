from flask import Blueprint, render_template, session, redirect, url_for
from app import mysql

bp = Blueprint('main', __name__)

@bp.route('/')
def index():
    if session.get('logueado'):
        return render_template('index.html', hola=session['nombre'], log='Cerrar')
    return render_template('index.html', log='Iniciar')

@bp.route('/sobre_nosotros')
def sobre_nosotros():
    if session.get('logueado'):
        return render_template('sobre_nosotros.html', log='Cerrar')
    return render_template('sobre_nosotros.html', log='Iniciar')

@bp.route('/modulos')
def modulos():
    if session.get('logueado'):
        return render_template('modulos.html', log='Cerrar')
    return redirect(url_for('auth.login', log='Iniciar'))

@bp.route('/opiniones')
def opiniones():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM opiniones")
    data = cur.fetchall()
        
    if session.get('logueado'):
        return render_template('opiniones.html', log='Cerrar', data=data)
    return render_template('opiniones.html', log='Iniciar', data=data)