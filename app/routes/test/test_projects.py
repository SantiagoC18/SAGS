import pytest
from unittest.mock import patch, MagicMock
from flask import session, url_for
from app import create_app
from config.config import TestingConfig
import jwt
from datetime import datetime, timedelta

@pytest.fixture
def app():
    app = create_app(TestingConfig)
    return app

@pytest.fixture
def client(app):
    return app.test_client()

@pytest.fixture
def mock_mysql():
    with patch('app.routes.projects.mysql') as mock:
        mock_cursor = MagicMock()
        mock.connection.cursor.return_value = mock_cursor
        yield mock

@pytest.fixture
def mock_data():
    tasks = [
        (1, 'Task 1', 'Description 1', 1),
        (2, 'Task 2', 'Description 2', 1)
    ]
    sprints = [
        (1, 'Sprint 1', '2024-01-01', '2024-01-15', 1),
        (2, 'Sprint 2', '2024-01-16', '2024-01-31', 1)
    ]
    return {'tasks': tasks, 'sprints': sprints}

@pytest.fixture
def mock_token():
    # Crear un token JWT válido
    token = jwt.encode(
        {'user_id': 'santicardenash@gmail.com', 'exp': datetime.utcnow() + timedelta(minutes=30)},
        'AES_Encrypt_SAGS',
        algorithm='HS256'
    )
    return token

def test_tasks_authenticated(client, mock_mysql, mock_data, mock_token):
    # Configurar el mock del cursor
    mock_cursor = mock_mysql.connection.cursor()
    mock_cursor.fetchall.side_effect = [mock_data['tasks'], mock_data['sprints']]

    # Simular usuario autenticado con token JWT
    with client.session_transaction() as sess:
        sess['logueado'] = True
        sess['id'] = 'santicardenash@gmail.com'
        sess['token'] = mock_token
        sess['token_exp'] = (datetime.utcnow() + timedelta(minutes=30)).timestamp()

    # Realizar la petición
    response = client.get('/tasks/4')

    # Verificar respuesta
    assert response.status_code == 200
    mock_cursor.execute.assert_any_call(
        '''SELECT DISTINCT t.* 
        FROM tareas t 
        JOIN sprints s ON t.idsprint = s.idsprint 
        JOIN proyectos p ON s.idproy = p.idproy 
        WHERE p.idproy = %s''', (1,)
    )
    mock_cursor.execute.assert_any_call(
        'SELECT * FROM sprints WHERE idproy = %s', (1,)
    )

def test_tasks_unauthenticated(client):
    # Probar sin autenticación
    response = client.get('/tasks/4')
    assert response.status_code == 302  # Debe redireccionar
    assert '/login' in response.location  # Debe redireccionar al login