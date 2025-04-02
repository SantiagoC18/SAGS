from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from app import mysql, gmail
from flask_mail import Message
import secrets
from datetime import datetime, timedelta

bp = Blueprint('auth', __name__)

@bp.route('/login')
def login():
    if session.get('logueado'):
        return redirect(request.referrer)
    return render_template('login.html')

@bp.route('/acceso_login', methods=["GET", "POST"])
def acceso_login():
    if request.method == 'POST':
        correo = request.form['correo']
        clave = request.form['clave']
            
        cur = mysql.connection.cursor()
        cur.execute('SELECT * FROM usuarios WHERE email = %s LIMIT 1', (correo,))
        account = cur.fetchone()
        cur.close()
            
        if account:
            cur = mysql.connection.cursor()
            cur.execute("SELECT (aes_decrypt(password,'AES')) AS cifrado FROM usuarios WHERE email = %s Limit 1", (correo,))
            clave_cifrada = cur.fetchone()
            
            if clave_cifrada['cifrado'].decode('utf-8') == clave:
                session['logueado'] = True
                session['nombre'] = account['nombres']
                session['id'] = account['email']
                return redirect(url_for('profile.perfil'))
            else:
                return render_template('login.html', message="Contraseña incorrecta")
        else:
            return render_template('login.html', message="Usuario no encontrado")

@bp.route('/logout')
def logout():
    session.pop("logueado", None)
    return redirect(url_for('auth.login'))