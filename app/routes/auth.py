from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from app import mysql, gmail
from flask_mail import Message
import secrets
from datetime import datetime, timedelta
import jwt
import os

# Clave secreta para JWT - lo ideal es almacenarla en variables de entorno
JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY', 'AES_Encrypt_SAGS')
JWT_EXPIRATION = 15  # minutos

bp = Blueprint('auth', __name__)

# Helper function to verify token
def token_required(f):
    from functools import wraps
    
    @wraps(f)
    def decorated(*args, **kwargs):
        token = session.get('token')
        
        if not token:
            flash('Sesión expirada. Por favor inicie sesión nuevamente.', 'error')
            return redirect(url_for('auth.login'))
            
        try:
            # Verify the token
            jwt.decode(token, JWT_SECRET_KEY, algorithms=['HS256'])
            
            # Check if token is expired based on our session timestamp
            if datetime.utcnow().timestamp() > session.get('token_exp', 0):
                session.pop("logueado", None)
                session.pop("token", None)
                session.pop("token_exp", None)
                flash('Su sesión ha expirado. Por favor inicie sesión nuevamente.', 'error')
                return redirect(url_for('auth.login'))
                
        except jwt.ExpiredSignatureError:
            session.pop("logueado", None)
            session.pop("token", None)
            session.pop("token_exp", None)
            flash('Su sesión ha expirado. Por favor inicie sesión nuevamente.', 'error')
            return redirect(url_for('auth.login'))
        except jwt.InvalidTokenError:
            session.pop("logueado", None)
            session.pop("token", None)
            session.pop("token_exp", None)
            flash('Error de autenticación. Por favor inicie sesión nuevamente.', 'error')
            return redirect(url_for('auth.login'))
            
        return f(*args, **kwargs)
    
    return decorated

@bp.route('/login')
def login():
    if session.get('logueado'):
        return redirect(request.referrer)
    return render_template('login.html')

@bp.route('/acceso_login', methods=["GET", "POST"])
def acceso_login():
    if not session.get('logueado'):
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
                    # Crear JWT token
                    expiration = datetime.utcnow() + timedelta(minutes=JWT_EXPIRATION)
                    payload = {
                        'user_id': account['email'],
                        'exp': expiration
                    }
                    token = jwt.encode(payload, JWT_SECRET_KEY, algorithm='HS256')
                    
                    # Store token in session
                    session['token'] = token
                    session['token_exp'] = expiration.timestamp()
                    session['logueado'] = True
                    session['nombre'] = account['nombres']
                    session['id'] = account['email']
                    
                    return redirect(url_for('profile.perfil'))
                else:
                    return render_template('login.html', message="Contraseña incorrecta")
            else:
                return redirect(request.referrer or url_for('profile.perfil'))

        

@bp.route('/logout')
@token_required
def logout():
    session.pop("logueado", None)
    session.pop("token", None)
    session.pop("token_exp", None)
    return redirect(url_for('auth.login'))



@bp.route('/protected-route')
@token_required
def protected_route():
    # This route is protected and requires a valid token
    return "Protected content"