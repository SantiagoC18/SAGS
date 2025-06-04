from flask import Blueprint, render_template, request, redirect, url_for, jsonify, flash, session
from app import mysql, gmail
import MySQLdb

bp = Blueprint('api', __name__)

@bp.route('/list_pqrs')
def list_pqrs():
    if not session.get('id'):
        return redirect(url_for('auth.login'))

    return render_template('pqrs.html', log='Cerrar')

@bp.route('/view_pqrs/<int:id>', methods=['GET'])
def view_pqrs(id):
    if not session.get('id'):
        return redirect(url_for('auth.login'))
    
    return render_template('pqrs_detail.html', log='Cerrar')



@bp.route('/api/pqrs', methods=['GET'])
def get_all_pqrs():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM opiniones ORDER BY id_opi DESC")
    pqrs = cur.fetchall()
    cur.close()
    return jsonify(pqrs), 200

@bp.route('/api/pqrs/<int:id>', methods=['GET'])
def get_pqrs(id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM opiniones WHERE id_opi = %s", (id,))
    pqrs = cur.fetchone()
    cur.close()
    if not pqrs:
        return jsonify({'error': 'PQRS no encontrado'}), 404
    return jsonify(pqrs), 200

@bp.route('/api/pqrs', methods=['POST'])
def create_pqrs():
    if not session.get('id'):
        return jsonify({'error': 'Debe iniciar sesión'}), 401
    data = request.get_json()
    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO opiniones (opinion, calificacion, tipo_opi, email) VALUES (%s, %s, %s, %s)", (
        data['opinion'], data['calificacion'], data['tipo_opi'], session['id']))
    mysql.connection.commit()
    cur.close()
    return jsonify({'message': 'PQRS creado exitosamente'}), 201

@bp.route('/api/pqrs/<int:id>', methods=['PUT'])
def update_pqrs(id):
    if not session.get('id'):
        return jsonify({'error': 'Debe iniciar sesión'}), 401
    data = request.get_json()
    cur = mysql.connection.cursor()

    # Verificación de propietario o administrador
    cur.execute("SELECT email FROM opiniones WHERE id_opi = %s", (id,))
    result = cur.fetchone()
    if not result:
        return jsonify({'error': 'PQRS no encontrado'}), 404
    pqrs_owner = result['email']
    current_user = session['id']
    cur.execute("SELECT idrol FROM usuarios WHERE email = %s", (current_user,))
    user_role = cur.fetchone()['idrol']
    if pqrs_owner != current_user and user_role != 1:
        return jsonify({'error': 'No autorizado'}), 403

    cur.execute("""
        UPDATE opiniones SET opinion=%s, calificacion=%s, tipo_opi=%s 
        WHERE id_opi=%s
    """, (data['opinion'], data['calificacion'], data['tipo_opi'], id))
    mysql.connection.commit()
    cur.close()
    return jsonify({'message': 'PQRS actualizada'}), 200

@bp.route('/api/pqrs/<int:id>', methods=['DELETE'])
def delete_pqrs(id):
    if not session.get('id'):
        return jsonify({'error': 'Debe iniciar sesión'}), 401
    cur = mysql.connection.cursor()
    cur.execute("SELECT email FROM opiniones WHERE id_opi = %s", (id,))
    result = cur.fetchone()
    if not result:
        return jsonify({'error': 'PQRS no encontrado'}), 404
    pqrs_owner = result['email']
    current_user = session['id']
    cur.execute("SELECT idrol FROM usuarios WHERE email = %s", (current_user,))
    user_role = cur.fetchone()['idrol']
    if pqrs_owner != current_user and user_role != 1:
        return jsonify({'error': 'No autorizado'}), 403

    cur.execute("DELETE FROM opiniones WHERE id_opi = %s", (id,))
    mysql.connection.commit()
    cur.close()
    return jsonify({'message': 'PQRS eliminada'}), 200
