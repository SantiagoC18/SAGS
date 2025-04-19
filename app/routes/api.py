from flask import Blueprint, render_template, request, redirect, url_for, jsonify, flash, session
from app import mysql, gmail
import MySQLdb

bp = Blueprint('api', __name__, url_prefix='/api')

@bp.route('/pqrs', methods=['GET'])
def list_pqrs():
    if not session.get('logueado'):
        flash('Debe iniciar sesión para ver las PQRS', 'error')
        return redirect(url_for('auth.login'))

    """Listar todas las entradas PQRS"""
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM opiniones ORDER BY id_opi DESC")
    pqrs_list = cur.fetchall()
    
    # Obtener información del usuario actual
    current_user = session.get('id')
    user_role = None
    
    if current_user:
        cur.execute("SELECT idrol FROM usuarios WHERE email = %s", (current_user,))
        user_role_result = cur.fetchone()
        user_role = user_role_result['idrol'] if user_role_result else None
    
    cur.close()
    
    # Pasar las variables adicionales al template
    return render_template('pqrs.html', 
                            pqrs_list=pqrs_list, 
                            log='Cerrar',
                            user_role=user_role,
                            current_user=current_user,
                            usu=current_user)

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
    
    return render_template('pqrs_detail.html', pqrs=pqrs, log='Cerrar')

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
    
    cur.execute("INSERT INTO opiniones (opinion, calificacion, tipo_opi, email) VALUES (%s, %s, %s, %s)",(descripcion, prioridad, tipo_pqrs, email))
    mysql.connection.commit()
    cur.close()
    
    flash('PQRS creado correctamente', 'success')
    return redirect(url_for('api.list_pqrs'))

@bp.route('/pqrs/<int:idp>', methods=['PUT', 'POST'])
def update_pqrs(idp):
    """Update a PQRS entry"""
    if not session.get('logueado'):
        if request.method == 'PUT':
            return jsonify({'error': 'Unauthorized'}), 401
        else:
            flash('Debe iniciar sesión para actualizar una PQRS', 'error')
            return redirect(url_for('auth.login'))
    
    # Check if this is a POST request with _method=PUT
    is_put_via_post = request.form.get('_method')
    
    # Get data from either JSON or form based on request type
    if request.method == 'PUT' or is_put_via_post:
        if request.method == 'PUT':
            data = request.get_json()
        else:
            data = {
                'opinion': request.form.get('descripcion'),
                'calificacion': request.form.get('prioridad'),
                'tipo_opi': request.form.get('tipo_opi')
            }
        
        cur = mysql.connection.cursor()
        
        # Check if the PQRS belongs to the current user or if user is admin
        cur.execute("SELECT * FROM opiniones WHERE id_opi = %s", (idp,))
        result = cur.fetchone()
        
        if not result:
            if request.method == 'PUT':
                return jsonify({'error': 'PQRS not found'}), 404
            else:
                flash('PQRS no encontrado', 'error')
                return redirect(url_for('api.list_pqrs'))
        
        # Store the entire result for debugging
        session['debug_pqrs_owner'] = str(result)
        
        # Get the email from the result - use the column name instead of index
        # Let's try to access it directly by the 'email' key
        pqrs_owner = result['email'] if isinstance(result, dict) else result.email
        current_user = session.get('id')
        
        # Almacenar temporalmente los valores para depuración
        session['debug_pqrs_owner'] = str(pqrs_owner)
        session['debug_current_user'] = str(current_user)
        
        # Check if user is admin (assuming role 1 is admin)
        cur.execute("SELECT idrol FROM usuarios WHERE email = %s", (current_user,))
        user_role_result = cur.fetchone()
        user_role = user_role_result['idrol']
        
        if pqrs_owner == current_user and user_role == 1:
            cur.execute(
                "UPDATE opiniones SET opinion = %s, calificacion = %s, tipo_opi = %s WHERE id_opi = %s",
                (data.get('opinion'), data.get('calificacion'), data.get('tipo_opi'), idp)
            )
            mysql.connection.commit()
            cur.close()

            if request.method == 'PUT':
                return jsonify({'success': True})
            else:
                flash('PQRS actualizada correctamente', 'success')
                return redirect(url_for('api.list_pqrs', id=idp))
        else:
        
            if request.method == 'PUT':
                return jsonify({'success': True})
            else:
                flash('No tienes permiso para actualizar esta PQRS', 'error')
                return redirect(url_for('api.list_pqrs',id = idp, user_role = user_role, pqrs_owner = pqrs_owner, current_user = current_user))
        
        

@bp.route('/pqrsdelete_pqrs/<int:id>', methods=['POST'])
def delete_pqrs(id):
    """Delete a PQRS entry via form submission"""
    if not session.get('logueado'):
        flash('Debe iniciar sesión para eliminar una PQRS', 'error')
        return redirect(url_for('auth.login'))
    
    cur = mysql.connection.cursor()

    # Check if the PQRS belongs to the current user or if user is admin
    cur.execute("SELECT email FROM opiniones WHERE id_opi = %s", (id,))
    result = cur.fetchone()

    if not result:
        flash('PQRS no encontrado', 'error')
        return redirect(url_for('api.list_pqrs'))

    pqrs_owner = result['email']
    current_user = session.get('id')

    # Check if user is admin (assuming role 1 is admin)
    cur.execute("SELECT idrol FROM usuarios WHERE email = %s", (current_user,))
    user_role = cur.fetchone()

    if pqrs_owner != current_user and user_role['idrol'] != 1:
        flash('No tienes permiso para eliminar esta PQRS', 'error')

    cur.execute("DELETE FROM opiniones WHERE id_opi = %s", (id,))
    mysql.connection.commit()
    cur.close()

    flash('PQRS eliminada correctamente', 'success')
    return redirect(url_for('api.list_pqrs'))