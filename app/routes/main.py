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

@bp.route('/edit_sprint/<int:idsprint>')
def edit_sprint(idsprint):
    if not session.get('logueado'):
        return redirect(url_for('auth.login', log='Iniciar'))
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM sprints WHERE idsprint = %s", (idsprint,))
    data = cur.fetchall()

    return render_template('edit-sprint.html', data=data, log='Cerrar')

@bp.route('/delete_sprint/<int:idsprint>')
def delete_sprint(idsprint):
    if not session.get('logueado'):
        return redirect(url_for('auth.login', log='Iniciar'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM sprints WHERE idsprint = %s", (idsprint,))
    data = cur.fetchone()

    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM sprints WHERE idsprint = %s", (idsprint,))
    mysql.connection.commit()

    return redirect(url_for('projects.sprints', idproy=data['idproy'], log='Cerrar'))