#import pytest
#from flask import Flask, session, url_for
import jwt
from datetime import datetime, timedelta
from unittest.mock import patch, MagicMock
from app import create_app
from ..auth import token_required, login, acceso_login, logout, protected_route, JWT_SECRET_KEY, JWT_EXPIRATION

# Configuración de la aplicación para pruebas
@pytest.fixture
def app():
    app = create_app()
    app.config['TESTING'] = True
    app.config['WTF_CSRF_ENABLED'] = False
    app.config['SECRET_KEY'] = 'test-key'
    return app

@pytest.fixture
def client(app):
    return app.test_client()

# Pruebas para token_required
def test_token_required_no_token(app, client):
    """Prueba cuando no hay token en la sesión"""
    # Crear una función decorada para probar
    @token_required
    def test_func():
        return "Función protegida"
    
    with app.test_request_context():
        # Simular que no hay token en la sesión
        with client.session_transaction() as sess:
            sess.clear()
        
        # Ejecutar la función decorada
        response = test_func()
        
        # Verificar que redirecciona a login
        assert response.location == url_for('auth.login')

def test_token_required_valid_token(app, client):
    """Prueba con un token válido"""
    # Crear una función decorada para probar
    @token_required
    def test_func():
        return "Función protegida"
    
    with app.test_request_context():
        # Simular un token válido en la sesión
        expiration = datetime.utcnow() + timedelta(minutes=JWT_EXPIRATION)
        payload = {
            'user_id': 'test@example.com',
            'exp': expiration
        }
        token = jwt.encode(payload, JWT_SECRET_KEY, algorithm='HS256')
        
        with client.session_transaction() as sess:
            sess['token'] = token
            sess['token_exp'] = expiration.timestamp()
        
        # Ejecutar la función decorada
        response = test_func()
        
        # Verificar que devuelve el resultado esperado
        assert response == "Función protegida"

def test_token_required_expired_token(app, client):
    """Prueba con un token expirado"""
    # Crear una función decorada para probar
    @token_required
    def test_func():
        return "Función protegida"
    
    with app.test_request_context():
        # Simular un token expirado en la sesión
        expiration = datetime.utcnow() - timedelta(minutes=1)  # Token ya expirado
        payload = {
            'user_id': 'test@example.com',
            'exp': expiration
        }
        token = jwt.encode(payload, JWT_SECRET_KEY, algorithm='HS256')
        
        with client.session_transaction() as sess:
            sess['token'] = token
            sess['token_exp'] = expiration.timestamp()
            sess['logueado'] = True
        
        # Ejecutar la función decorada
        response = test_func()
        
        # Verificar que redirecciona a login
        assert response.location == url_for('auth.login')
        
        # Verificar que se eliminaron las variables de sesión
        with client.session_transaction() as sess:
            assert 'logueado' not in sess
            assert 'token' not in sess
            assert 'token_exp' not in sess

# Pruebas para login
def test_login_not_logged_in(app, client):
    """Prueba de la ruta login cuando el usuario no está logueado"""
    with app.test_request_context():
        with client.session_transaction() as sess:
            sess.clear()
        
        response = client.get('/login')
        
        assert response.status_code == 200
        assert b'login.html' in response.data

def test_login_already_logged_in(app, client):
    """Prueba de la ruta login cuando el usuario ya está logueado"""
    with app.test_request_context():
        with client.session_transaction() as sess:
            sess['logueado'] = True
        
        # Configurar el referrer
        response = client.get('/login', headers={'Referer': '/dashboard'})
        
        assert response.status_code == 302
        assert response.location == '/dashboard'

# Pruebas para acceso_login
@patch('app.mysql.connection.cursor')
def test_acceso_login_valid_credentials(mock_cursor, app, client):
    """Prueba de acceso_login con credenciales válidas"""
    # Configurar los mocks para simular la base de datos
    mock_cursor_instance = MagicMock()
    mock_cursor.return_value = mock_cursor_instance
    
    # Simular la respuesta de la primera consulta (obtener usuario)
    mock_cursor_instance.fetchone.side_effect = [
        {'email': 'test@example.com', 'nombres': 'Test User'},  # Primera llamada
        {'cifrado': b'password123'}  # Segunda llamada
    ]
    
    with app.test_request_context():
        response = client.post('/acceso_login', data={
            'correo': 'test@example.com',
            'clave': 'password123'
        })
        
        # Verificar que redirecciona al perfil
        assert response.status_code == 302
        assert response.location == url_for('profile.perfil')
        
        # Verificar que se establecieron las variables de sesión
        with client.session_transaction() as sess:
            assert sess['logueado'] == True
            assert sess['nombre'] == 'Test User'
            assert sess['id'] == 'test@example.com'
            assert 'token' in sess
            assert 'token_exp' in sess

@patch('app.mysql.connection.cursor')
def test_acceso_login_invalid_password(mock_cursor, app, client):
    """Prueba de acceso_login con contraseña inválida"""
    # Configurar los mocks para simular la base de datos
    mock_cursor_instance = MagicMock()
    mock_cursor.return_value = mock_cursor_instance
    
    # Simular la respuesta de la primera consulta (obtener usuario)
    mock_cursor_instance.fetchone.side_effect = [
        {'email': 'test@example.com', 'nombres': 'Test User'},  # Primera llamada
        {'cifrado': b'password123'}  # Segunda llamada (contraseña correcta en la BD)
    ]
    
    with app.test_request_context():
        response = client.post('/acceso_login', data={
            'correo': 'test@example.com',
            'clave': 'wrong_password'  # Contraseña incorrecta
        })
        
        # Verificar que muestra el mensaje de error
        assert response.status_code == 200
        assert b'Contrase\xc3\xb1a incorrecta' in response.data

@patch('app.mysql.connection.cursor')
def test_acceso_login_user_not_found(mock_cursor, app, client):
    """Prueba de acceso_login con usuario no encontrado"""
    # Configurar los mocks para simular la base de datos
    mock_cursor_instance = MagicMock()
    mock_cursor.return_value = mock_cursor_instance
    
    # Simular que no se encuentra el usuario
    mock_cursor_instance.fetchone.return_value = None
    
    with app.test_request_context():
        # Configurar el referrer
        response = client.post('/acceso_login', data={
            'correo': 'nonexistent@example.com',
            'clave': 'password123'
        }, headers={'Referer': '/login'})
        
        # Verificar que redirecciona al referrer
        assert response.status_code == 302
        assert response.location == '/login'

# Pruebas para logout
def test_logout(app, client):
    """Prueba de la ruta logout"""
    with app.test_request_context():
        # Simular que el usuario está logueado
        with client.session_transaction() as sess:
            sess['logueado'] = True
            sess['token'] = 'test-token'
            sess['token_exp'] = datetime.utcnow().timestamp() + 900  # 15 minutos
        
        # Aplicar el decorador token_required manualmente
        with patch('app.routes.auth.token_required', lambda f: f):
            response = client.get('/logout')
            
            # Verificar que redirecciona a login
            assert response.status_code == 302
            assert response.location == url_for('auth.login')
            
            # Verificar que se eliminaron las variables de sesión
            with client.session_transaction() as sess:
                assert 'logueado' not in sess
                assert 'token' not in sess
                assert 'token_exp' not in sess

# Pruebas para protected_route
def test_protected_route(app, client):
    """Prueba de una ruta protegida"""
    with app.test_request_context():
        # Simular que el usuario está logueado con un token válido
        expiration = datetime.utcnow() + timedelta(minutes=JWT_EXPIRATION)
        payload = {
            'user_id': 'test@example.com',
            'exp': expiration
        }
        token = jwt.encode(payload, JWT_SECRET_KEY, algorithm='HS256')
        
        with client.session_transaction() as sess:
            sess['token'] = token
            sess['token_exp'] = expiration.timestamp()
            sess['logueado'] = True
        
        # Aplicar el decorador token_required manualmente
        with patch('app.routes.auth.token_required', lambda f: f):
            response = client.get('/protected-route')
            
            # Verificar que devuelve el contenido protegido
            assert response.status_code == 200
            assert b'Protected content' in response.data