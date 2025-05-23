import pytest
from flask import Flask
from ..routes.profile import perfil 
from app import create_app
app = create_app()

def test_perfil(): 
    with app.test_request_context():
        login_true = perfil("santicardenash@gmail.com", "2006")
        assert login_true 


def test_perfil_fail():
    with app.test_request_context():
        login_false = perfil("usuario@gmail.com", "12345")
        assert login_false
