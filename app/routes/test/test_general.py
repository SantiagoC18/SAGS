import pytest
import os
import sys
from unittest.mock import MagicMock, patch
from flask import Flask, session
from datetime import datetime, timedelta
import jwt

# Add the project root to Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', '..'))

# Import your app components with correct blueprint names
from app.routes.auth import bp as auth_bp
from app.routes.profile import bp as profile_bp
from app.routes.password import bp as password_bp

@pytest.fixture
def app():
    app = Flask(__name__, template_folder=os.path.join(os.path.dirname(__file__), '..', '..', 'templates'))
    app.config['TESTING'] = True
    app.config['SECRET_KEY'] = 'test_secret_key'
    app.config['JWT_SECRET_KEY'] = 'AES_Encrypt_SAGS'
    app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(minutes=35)
    
    # Complete MySQL configuration
    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'root'
    app.config['MYSQL_PASSWORD'] = ''
    app.config['MYSQL_DB'] = 'sags'
    app.config['MYSQL_PORT'] = 5000
    app.config['MYSQL_UNIX_SOCKET'] = None
    app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
    
    # Register blueprints
    app.register_blueprint(auth_bp)
    app.register_blueprint(profile_bp, url_prefix='/profile')
    app.register_blueprint(password_bp, url_prefix='/password')
    
    return app

@pytest.fixture
def client(app):
    return app.test_client()

@pytest.fixture
def mock_db():
    with patch('app.routes.auth.mysql') as mock_mysql:
        yield mock_mysql

@pytest.fixture
def valid_token():
    payload = {
        'user_id': 'test@example.com',
        'exp': datetime.utcnow() + timedelta(minutes=15)
    }
    return jwt.encode(payload, 'test_jwt_secret', algorithm='HS256')

# Prueba 1: Ruta de login carga correctamente
def test_login_route(client):
    response = client.get('/login')
    assert response.status_code == 200
    assert b'login' in response.data.lower()

# Prueba 2: Usuario autenticado es redirigido desde login
def test_login_redirect_when_authenticated(client, mock_db):
    # Mock the database for the profile route
    mock_cursor = MagicMock()
    mock_db.connection.cursor.return_value = mock_cursor
    mock_cursor.fetchone.return_value = {'nombres': 'Test User', 'email': 'test@example.com'}
    
    with client.session_transaction() as sess:
        sess['logueado'] = True
        sess['nombre'] = 'Test User'
    
    # Test redirect without following redirects
    response = client.get('/login')
    assert response.status_code == 302
    assert '/profile/perfil' in response.location

# Prueba 3: Login fallido con credenciales incorrectas
def test_acceso_login_failure(client, mock_db):
    mock_cursor = MagicMock()
    mock_db.connection.cursor.return_value = mock_cursor
    mock_cursor.fetchone.return_value = None  # Simula que no encontró el usuario
    
    response = client.post('/acceso_login', data={
        'correo': 'wrong@example.com',
        'clave': 'wrongpass'
    }, follow_redirects=True)
    
    assert response.status_code == 200
    # Check that we're redirected back to login or see error message
    assert b'login' in response.data.lower() or b'error' in response.data.lower()
    
    # Check session within proper context
    with client.session_transaction() as sess:
        assert 'logueado' not in sess

# Prueba 4: Login exitoso con credenciales correctas

# Prueba 5: Logout limpia la sesión
def test_logout(client, valid_token):
    with client.session_transaction() as sess:
        sess['logueado'] = True
        sess['token'] = valid_token
        sess['nombre'] = 'Test User'
    
    response = client.get('/logout', follow_redirects=True)
    
    # Check session within proper context
    with client.session_transaction() as sess:
        assert 'logueado' not in sess
        assert 'token' not in sess
        assert 'nombre' not in sess
    
    # Check for login content instead of template name
    assert b'login' in response.data.lower()

# Prueba 6: Ruta protegida sin token redirige a login
def test_protected_route_without_token(client):
    response = client.get('/protected-route', follow_redirects=True)
    # Check for login content instead of template name
    assert b'login' in response.data.lower()
    assert 'sesión expirada'.encode('utf-8').lower() in response.data.lower()


# Prueba 8: Ruta protegida con token inválido
def test_protected_route_with_invalid_token(client):
    with client.session_transaction() as sess:
        sess['token'] = 'invalid.token.here'
    
    response = client.get('/protected-route', follow_redirects=True)
    # Check for authentication error content
    assert b'login' in response.data.lower() or 'error de autenticación'.encode('utf-8').lower() in response.data.lower()
    
    # Check session within proper context
    with client.session_transaction() as sess:
        assert 'logueado' not in sess


# Prueba 10: Token required decorator funciona correctamente
def test_token_required_decorator(client, valid_token):
    # Prueba con token válido
    with client.session_transaction() as sess:
        sess['token'] = valid_token
        sess['token_exp'] = (datetime.utcnow() + timedelta(minutes=15)).timestamp()
        sess['logueado'] = True
    
    response = client.get('/logout')
    assert response.status_code == 302  # Redirección después de logout
    
    # Prueba sin token
    response = client.get('/logout', follow_redirects=True)
    assert 'sesión expirada'.encode('utf-8').lower() in response.data.lower()
    # Check for login content instead of template name
    assert 'login' in response.data.decode('utf-8').lower()