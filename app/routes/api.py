from flask import Blueprint, render_template, request, redirect, url_for, jsonify, flash, session
from app import mysql, gmail
import MySQLdb

bp = Blueprint('api', __name__, url_prefix='/api')

@bp.route('/pqrs', methods=['GET'])
def list_pqrs():
    """List all PQRS entries"""
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM opiniones ORDER BY id_opi DESC")
    pqrs_list = cur.fetchall()
    cur.close()
    
    return render_template('pqrs.html', pqrs_list=pqrs_list, log='Cerrar')

@bp.route('/pqrs/<int:id>', methods=['GET'])
def view_pqrs(id):
    """View a single PQRS entry"""
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM opiniones WHERE id_opi = %s", (id,))
    pqrs = cur.fetchone()
    cur.close()
    
    if pqrs is None:
        flash('PQRS no encontrado', 'error')
        return redirect(url_for('api.list_pqrs'))
    
    return render_template('pqrs_detail.html', pqrs=pqrs, log=session.get('id'))

@bp.route('/pqrs', methods=['POST'])
def create_pqrs():
    """Create a new PQRS entry"""
    if not session.get('id'):
        flash('Debe iniciar sesión para crear una PQRS', 'error')
        return redirect(url_for('auth.login'))
    
    tipo_pqrs = request.form.get('tipo_pqrs')
    descripcion = request.form.get('descripcion')
    prioridad = request.form.get('prioridad')
    email = session.get('id')
    
    cur = mysql.connection.cursor()
    
    cur.execute(
        "INSERT INTO opiniones (opinion, calificacion, tipo_opi, email) VALUES (%s, %s, %s, %s)",
        (descripcion, prioridad, tipo_pqrs, email)
    )
    mysql.connection.commit()
    cur.close()
    
    flash('PQRS creado correctamente', 'success')
    return redirect(url_for('api.list_pqrs'))

@bp.route('/pqrs/<int:id>', methods=['PUT'])
def update_pqrs(id):
    """Update a PQRS entry"""
    if not session.get('id'):
        return jsonify({'error': 'Unauthorized'}), 401
    
    data = request.get_json()
    
    cur = mysql.connection.cursor()
    
    # Check if the PQRS belongs to the current user or if user is admin
    cur.execute("SELECT email FROM opiniones WHERE id_opi = %s", (id,))
    result = cur.fetchone()
    
    if not result:
        return jsonify({'error': 'PQRS not found'}), 404
    
    pqrs_owner = result[0]
    current_user = session.get('id')
    
    # Check if user is admin (assuming role 1 is admin)
    cur.execute("SELECT idrol FROM usuarios WHERE email = %s", (current_user,))
    user_role = cur.fetchone()[0]
    
    if pqrs_owner != current_user and user_role != 1:
        return jsonify({'error': 'Unauthorized'}), 403
    
    cur.execute(
        "UPDATE opiniones SET opinion = %s, calificacion = %s, tipo_opi = %s WHERE id_opi = %s",
        (data.get('opinion'), data.get('calificacion'), data.get('tipo_opi'), id)
    )
    mysql.connection.commit()
    cur.close()
    
    return jsonify({'success': True})

@bp.route('/pqrs/<int:id>', methods=['DELETE'])
def delete_pqrs(id):
    """Delete a PQRS entry"""
    if not session.get('id'):
        return jsonify({'error': 'Unauthorized'}), 401
    
    cur = mysql.connection.cursor()
    
    # Check if the PQRS belongs to the current user or if user is admin
    cur.execute("SELECT email FROM opiniones WHERE id_opi = %s", (id,))
    result = cur.fetchone()
    
    if not result:
        return jsonify({'error': 'PQRS not found'}), 404
    
    pqrs_owner = result[0]
    current_user = session.get('id')
    
    # Check if user is admin (assuming role 1 is admin)
    cur.execute("SELECT idrol FROM usuarios WHERE email = %s", (current_user,))
    user_role = cur.fetchone()[0]
    
    if pqrs_owner != current_user and user_role != 1:
        return jsonify({'error': 'Unauthorized'}), 403
    
    cur.execute("DELETE FROM opiniones WHERE id_opi = %s", (id,))
    mysql.connection.commit()
    cur.close()
    
    return jsonify({'success': True})