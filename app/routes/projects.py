from flask import Blueprint, render_template, request, redirect, url_for, session, flash, Flask, jsonify
from app.routes.auth import token_required 
from app import mysql
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)
bp = Blueprint('projects', __name__)

@bp.route('/gestion_proyectos', methods=["GET", "POST"])
@token_required
def gestion_proyectos():
    if not session.get('logueado'):
        flash("Debe iniciar sesión primero.") 
        return redirect(url_for('auth.login'))

    # Verificar rol de usuario
    cur = mysql.connection.cursor()
    cur.execute("SELECT idrol FROM usuarios WHERE email = %s", (session['id'],))
    usuario = cur.fetchone()
    
    if not usuario or usuario['idrol'] not in [1, 2]: # Admin and Scrum Master
        flash("No tiene permisos para acceder a esta sección.")
        return redirect(url_for('main.modulos'))


    if request.method == 'POST':
        correo = request.form['correo']
        clave = request.form['clave']

        if correo != session.get('id'):
            flash("Debe utilizar el mismo correo con el que inició sesión.")
            return redirect(url_for('main.modulos'))  # Updated endpoint

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM usuarios WHERE email = %s LIMIT 1", (correo,))
        usuario = cur.fetchone()

        if not usuario:
            flash("Usuario no encontrado.")
            return redirect(url_for('main.modulos'))

        cur.execute(
            "SELECT * FROM usuarios WHERE email = %s AND password = AES_ENCRYPT(%s, 'AES') LIMIT 1",
            (correo, clave,)
        )
        account = cur.fetchone()

        if account:
            # Obtener todos los proyectos para administradores
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM proyectos")
            consulta = cur.fetchall()

            # Obtener proyectos del usuario actual
            id = session['id']
            cur.execute('''
                SELECT * FROM proyectos
                INNER JOIN usu_proy ON proyectos.idproy = usu_proy.idproy
                INNER JOIN usuarios ON usuarios.email = usu_proy.email
                WHERE usu_proy.email = %s
            ''', (id,))
            consulta2 = cur.fetchall()
            
            # Calcular el progreso para cada proyecto basado en sus sprints
            for proyecto in consulta2:
                # Obtener todos los sprints del proyecto
                cur.execute("SELECT * FROM sprints WHERE idproy = %s", (proyecto['idproy'],))
                sprints = cur.fetchall()
                
                if sprints:
                    # Calcular el promedio del estado de todos los sprints
                    total_porcentaje = sum(sprint['estado'] for sprint in sprints)
                    progreso = int(total_porcentaje / len(sprints))
                else:
                    progreso = 0
                    
                # Agregar el progreso al diccionario del proyecto
                proyecto['progreso'] = progreso

            cur.execute('SELECT * FROM usuarios')
            infousuarios = cur.fetchall()

            return render_template('gestor_proyectos.html', data=consulta, data2=consulta2, infoUsu=infousuarios, log='Cerrar', idrol = session['idrol'])
        else:
            flash("Contraseña incorrecta.")
            return redirect(url_for('main.modulos'))

@bp.route('/registrar_pro', methods=['GET', 'POST'])
@token_required
def registrar_pro():
    if not session.get('logueado'):
        return redirect(url_for('auth.login'))  # Updated endpoint
    
    if request.method == 'POST':
        proyect_name = request.form['proyect_name']
        descripcion = request.form['descripcion']
        tipo = request.form['tipo']
        fecha = request.form['fecha']
        stake = 1
        
        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO proyectos (`nombre`, `descripcion`, `tipo`, `fechaI`) VALUES (%s, %s, %s, %s)', 
                    (proyect_name, descripcion, tipo, fecha,))
        idproy = cur.lastrowid
        
        cur.execute('INSERT INTO usu_proy (idproy, email, stake) VALUES (%s, %s, %s)', 
                    (idproy, session['id'], stake))
        mysql.connection.commit()
        
        return redirect(url_for('projects.plan', idproy=idproy))
        
    return render_template('registrar_pro.html', log='Cerrar')

@bp.route('/plan/<int:idproy>', methods=['GET', 'POST'])
def plan(idproy):
    if not session.get('logueado'):
        return redirect(url_for('auth.login'))  # Updated endpoint
    
    if request.method == 'POST':
        plan = request.form.get('plan')
        modelos = request.form.getlist('model')
        progreso = 0

        cur = mysql.connection.cursor()
        cur.execute("UPDATE proyectos SET nomplan = %s WHERE idproy = %s", (plan, idproy))
        mysql.connection.commit()

        if plan in ["BASIC", "STANDARD", "PREMIUM"]:
            modelos_default = {
                "BASIC": ["RQ", "CU", "CUX"],
                "STANDARD": ["RQ", "CU", "CUX", "MC", "MO"],
                "PREMIUM": ["RQ", "CU", "CUX", "MC", "MO", "MER", "MR"]
            }
            modelos = modelos_default[plan]
            
        elif plan == "PERSONALIZADO" and not modelos:
            flash("Por favor, selecciona al menos un modelo.", "warning")
            return redirect(url_for('projects.plan', idproy=idproy))  # Updated endpoint

        for modelo in modelos:
            cur.execute("INSERT INTO checklists (idproy, idmod, progreso) VALUES (%s, %s, %s)", 
                        (idproy, modelo, progreso))
        mysql.connection.commit()
        
        return redirect(url_for('profile.perfil'))  # Updated endpoint

    return render_template('formulario-plan.html', log='Cerrar')

@bp.route("/checkdown/<int:idproy>")
@token_required
def checkdown(idproy):
    if not session.get('logueado'):
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    
    # Obtener el rol del usuario actual
    cur.execute("SELECT idrol FROM usuarios WHERE email = %s", (session['id'],))
    usuario = cur.fetchone()
    rol_usuario = usuario['idrol'] if usuario else 0
    
    cur.execute("SELECT * FROM proyectos WHERE idproy = %s", (idproy,))
    data2 = cur.fetchall()
    
    cur.execute('''
        SELECT checklists.aprobacion, modelos.nombre, modelos.descripcion, 
                checklists.progreso, checklists.archivo, checklists.fecha, modelos.idmod
        FROM proyectos
        INNER JOIN checklists ON proyectos.idproy = checklists.idproy
        INNER JOIN modelos ON checklists.idmod = modelos.idmod
        WHERE checklists.idproy = %s
    ''', (idproy,))
    data = cur.fetchall()
    
    cur.execute('''
        SELECT DISTINCT u.email, u.nombres, u.apellidos,
                (SELECT COUNT(*) 
                 FROM usu_proy up2 
                 WHERE up2.idproy = %s) as integrantes
        FROM usuarios u
        INNER JOIN usu_proy up ON u.email = up.email 
        WHERE up.idproy = %s
        ''', (idproy, idproy))
    personal = cur.fetchall()

    return render_template('check-down.html', idproy=idproy, data=data, 
                          data2=data2, colaboradores=personal, log='Cerrar', rol_usuario=rol_usuario)

@bp.route("/tasks/<int:idproy>")
@token_required
def tasks(idproy):
    if session.get('logueado'):
        idproy = idproy
        cur = mysql.connection.cursor()
        cur.execute('''SELECT DISTINCT t.*
        FROM tareas t
        JOIN sprints s ON t.idsprint = s.idsprint
        JOIN proyectos p ON s.idproy = p.idproy
        WHERE p.idproy = %s''', (idproy,))
        data = cur.fetchall()

        cur.execute('SELECT * FROM sprints WHERE idproy = %s', (idproy,))
        data2 = cur.fetchall()

        return render_template('tasks.html', log='Cerrar', idproy=idproy, data = data, data2 = data2)
    else:
        return redirect(url_for('auth.login'))

@bp.route("/registrar_task/<int:idproy>", methods=['POST'])
@token_required
def registrar_task(idproy):
    if session.get('logueado'):
        nombre = request.form['nombre_tarea']
        descripcion = request.form['descripcion']
        fechaLimite = request.form['fechaLimite']
        estado = request.form['estado']
        prioridad = request.form['prioridad']
        idsprint = request.form['idsprint']

        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO tareas (nombre, descripcion, fechaLimite, estado, prioridad, idsprint) VALUES (%s, %s, %s, %s, %s, %s)",
                    (nombre, descripcion, fechaLimite, estado, prioridad, idsprint,))
        mysql.connection.commit()
        cur.close()

        flash('La tarea ha sido registrada exitosamente','success')

        return redirect(url_for('projects.tasks', idproy=idproy))

@bp.route("/update_task/<int:id_tar>", methods=['GET', 'POST'])
@token_required
def update_task(id_tar):
    if session.get('logueado'):
        if request.method == 'POST':
            nombre = request.form['nombre_tarea']
            descripcion = request.form['descripcion']
            fechaLimite = request.form['fechaLimite']
            estado = request.form['estado']
            prioridad = request.form['prioridad']
            idsprint = request.form['idsprint']

            cur = mysql.connection.cursor() 
            cur.execute("UPDATE tareas SET nombre = %s, descripcion = %s, fechaLimite = %s, estado = %s, prioridad = %s, idsprint = %s WHERE id_tar = %s",
                        (nombre, descripcion, fechaLimite, estado, prioridad, idsprint, id_tar,))
            mysql.connection.commit()
            cur.close()

            flash('La tarea ha sido actualizada exitosamente', 'success')

            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM tareas WHERE id_tar = %s", (id_tar,))
            data = cur.fetchone()
            # render_template('esit-task.html', log='Cerrar', idproy=idproy, data = data)
            return redirect(request.referrer)
            #return render_template('edit-task.html', log='Cerrar', idproy=idproy, data = data)
        else:
            cur = mysql.connection.cursor()

            cur.execute('''SELECT 
            t.*, s.nombre AS nombre_sprint, t.nombre AS nombre_tarea, s.idsprint, p.idproy, u.perfil,
            GROUP_CONCAT(CONCAT(u.nombres, ' ', u.apellidos) SEPARATOR ', ') AS asignados
            FROM tareas t
            JOIN sprints s ON t.idsprint = s.idsprint
            JOIN proyectos p ON s.idproy = p.idproy
            LEFT JOIN tarea_asignaciones ta ON t.id_tar = ta.id_tar
            LEFT JOIN usu_proy up ON ta.id_usu_proy = up.id
            LEFT JOIN usuarios u ON up.email = u.email
            WHERE t.id_tar = %s
            GROUP BY t.id_tar;''', (id_tar,))
            data = cur.fetchone()

            idproy = data['idproy']

            cur.execute("""SELECT * FROM usuarios 
            INNER JOIN usu_proy ON usuarios.email = usu_proy.email 
            where idproy = %s""", (idproy,))
            data1 = cur.fetchall()

            cur.execute("SELECT * FROM sprints where idproy = %s", (idproy,))
            data2 = cur.fetchall()

            return render_template('edit-task.html', log='Cerrar', data = data, data1 = data1, data2 = data2, id_tar = id_tar)

@bp.route("/delete_task/<int:id_tar>")
@token_required
def delete_task(id_tar):
    if session.get('logueado'):
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM tareas WHERE id_tar = %s", (id_tar,))
        mysql.connection.commit()
        cur.close()

        flash('La tarea ha sido eliminada exitosamente','success')

        return redirect(request.referrer)
    else:
        return redirect(url_for('auth.login'))

@bp.route("/sprints/<int:idproy>")
@token_required
def sprints(idproy):
    if session.get('logueado'):
        idproy = idproy
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM sprints WHERE idproy = %s", (idproy,))
        sprints_data = cur.fetchall()
        
        # Para cada sprint, calcular el porcentaje de tareas completadas
        for sprint in sprints_data:
            # Obtener todas las tareas del sprint
            cur.execute("""
                SELECT COUNT(*) as total_tareas, 
                       SUM(CASE WHEN estado = 'Completado' THEN 1 ELSE 0 END) as tareas_completadas
                FROM tareas 
                WHERE idsprint = %s
            """, (sprint['idsprint'],))
            
            tareas_info = cur.fetchone()
            total_tareas = tareas_info['total_tareas'] if tareas_info['total_tareas'] > 0 else 0
            tareas_completadas = tareas_info['tareas_completadas'] if tareas_info['tareas_completadas'] is not None else 0
            
            # Calcular el porcentaje
            if total_tareas > 0:
                porcentaje = int((tareas_completadas / total_tareas) * 100)
            else:
                porcentaje = 0
                
            # Actualizar el estado del sprint en la base de datos
            cur.execute("UPDATE sprints SET estado = %s WHERE idsprint = %s", 
                       (porcentaje, sprint['idsprint']))
            mysql.connection.commit()
            
            # Actualizar el valor en el diccionario para la plantilla
            sprint['estado'] = porcentaje
            sprint['total_tareas'] = total_tareas
            sprint['tareas_completadas'] = tareas_completadas

        return render_template('sprints.html', log='Cerrar', data=sprints_data, data2=idproy)
    else:
        return redirect(url_for('auth.login'))

@bp.route("/update_sprint/<int:idsprint>", methods=['GET', 'POST'])
@token_required
def update_sprint(idsprint):
    if session.get('logueado'):
        if request.method == 'POST':
            nombre = request.form['sprint-name']
            fechai = request.form['fi']
            fechaf = request.form['ff']
            desc = request.form['descripcion']

            cur = mysql.connection.cursor()
            cur.execute("UPDATE sprints SET nombre = %s, fechaI = %s, fechaF = %s, descripcion = %s WHERE idsprint = %s",
                        (nombre, fechai, fechaf, desc, idsprint,))
            mysql.connection.commit()
            cur.close()

            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM sprints WHERE idsprint = %s", (idsprint,))
            data = cur.fetchone()

            return redirect(url_for('projects.sprints', idproy = data['idproy']))

@bp.route('/registrar_sprint/<int:idproy>', methods=['POST'])
@token_required
def registrar_sprint(idproy):
    nombre = request.form['sprint-name']
    fechai = request.form['fi']
    fechaf = request.form['ff']
    desc = request.form['descripcion']
    estado = 0
    
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO `sprints`(`fechaI`, `fechaF`, `nombre`, `descripcion`, `estado`, `idproy`) VALUES ( %s, %s, %s, %s, %s, %s)', (fechai, fechaf, nombre, desc, estado, idproy))
    mysql.connection.commit()
    cur.close()
    
    return redirect(url_for('projects.sprints', idproy = idproy))


@bp.route('/get_usuarios')
def get_usuarios():
    if not session.get('logueado'):
        return jsonify({"error": "No autorizado"}), 401
    
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT email, CONCAT(nombres, ' ', apellidos) as nombre_completo, idrol 
        FROM usuarios 
        WHERE idrol IN (1, 2, 3)
        ORDER BY nombres
    """)
    usuarios = cur.fetchall()
    cur.close()
    
    return jsonify(usuarios)


@bp.route('/asignar_usuarios', methods=['POST'])
@token_required
def asignar_usuarios():
    # Autenticación
    if not session.get('logueado'):
        return jsonify({"error": "No autorizado"}), 401

    try:
        # Asegurarse de recibir datos JSON
        if not request.is_json:
            return jsonify({"error": "Se esperaba JSON"}), 400

        # Parsear los datos JSON
        data = request.get_json()
        
        # Validar datos requeridos
        proyecto_id = data.get('proyecto_id')
        usuarios = data.get('usuarios', [])  # Lista vacía por defecto

        if not proyecto_id:
            return jsonify({"error": "Falta el ID del proyecto"}), 400

        if not isinstance(usuarios, list):
            return jsonify({"error": "Formato inválido para usuarios"}), 400

        # Procesar asignación
        cur = mysql.connection.cursor()
        asignaciones_exitosas = 0

        for email in usuarios:
            try:
                # Verificar si la asignación ya existe
                cur.execute("""
                    SELECT 1 FROM usu_proy 
                    WHERE idproy = %s AND email = %s
                """, (proyecto_id, email))
                
                if not cur.fetchone():
                    # Insertar nueva asignación
                    cur.execute("""
                        INSERT INTO usu_proy (idproy, email, stake, Product_Owner)
                        VALUES (%s, %s, 1, 0)
                    """, (proyecto_id, email))
                    asignaciones_exitosas += 1

            except Exception as e:
                mysql.connection.rollback()
                return jsonify({
                    "error": f"Error al asignar usuario {email}",
                    "detalle": str(e)
                }), 500

        mysql.connection.commit()
        return jsonify({
            "success": True,
            "message": f"Asignación completada",
            "asignados": asignaciones_exitosas,
            "total": len(usuarios)
        })

    except Exception as e:
        mysql.connection.rollback()
        return jsonify({
            "error": "Error interno del servidor",
            "detalle": str(e)
        }), 500


# Obtener usuarios asignados a un proyecto
@bp.route('/get_usuarios_asignados', methods=['GET'])
@token_required
def get_usuarios_asignados():
    if not session.get('logueado'):
        return jsonify({"error": "No autorizado"}), 401

    proyecto_id = request.args.get('proyecto_id')
    if not proyecto_id:
        return jsonify({"error": "Falta proyecto_id"}), 400

    try:
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT u.email, 
                    CONCAT(u.nombres, ' ', u.apellidos) as nombre_completo, 
                    CASE u.idrol 
                        WHEN 1 THEN 'Administrador' 
                        WHEN 2 THEN 'Scrum Master' 
                        WHEN 3 THEN 'Desarrollador' 
                    END as rol
            FROM usu_proy up
            JOIN usuarios u ON up.email = u.email
            WHERE up.idproy = %s
            ORDER BY u.nombres
        """, (proyecto_id,))
        asignados = cur.fetchall()
        return jsonify(asignados)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Desasignar usuarios seleccionados
@bp.route('/desasignar_usuarios', methods=['POST'])
@token_required
def desasignar_usuarios():
    if not session.get('logueado'):
        return jsonify({"error": "No autorizado"}), 401

    try:
        data = request.get_json()
        proyecto_id = data.get('proyecto_id')
        usuarios = data.get('usuarios', [])

        if not proyecto_id or not usuarios:
            return jsonify({"error": "Datos incompletos"}), 400

        cur = mysql.connection.cursor()
        desasignados = 0

        for email in usuarios:
            # Verificar si existe la asignación
            cur.execute("""
                DELETE FROM usu_proy 
                WHERE idproy = %s AND email = %s
            """, (proyecto_id, email))
            desasignados += cur.rowcount

        mysql.connection.commit()
        
        return jsonify({
            "success": True,
            "message": "Usuarios desasignados correctamente",
            "desasignados": desasignados
        })

    except Exception as e:
        mysql.connection.rollback()
        return jsonify({
            "error": "Error al desasignar usuarios",
            "detalle": str(e)
        }), 500


@bp.route("/upload_document/<int:idproy>", methods=['POST'])
@token_required
def upload_document(idproy):
    if not session.get('logueado'):
        return redirect(url_for('auth.login'))
    
    if 'document' not in request.files:
        flash('No se seleccionó ningún archivo', 'error')
        return redirect(url_for('projects.checkdown', idproy=idproy))
    
    file = request.files['document']
    idmod = request.form['idmod']
    
    if file.filename == '':
        flash('No se seleccionó ningún archivo', 'error')
        return redirect(url_for('projects.checkdown', idproy=idproy))
    
    # Guardar el archivo en la carpeta documentos
    filename = secure_filename(file.filename)
    file_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'static', 'documentos', filename)
    file.save(file_path)
    
    # Actualizar la base de datos
    cur = mysql.connection.cursor()
    cur.execute("UPDATE checklists SET archivo = %s, fecha = CURDATE() WHERE idproy = %s AND idmod = %s", 
               (filename, idproy, idmod))
    mysql.connection.commit()
    cur.close()
    
    flash('Documento cargado exitosamente', 'success')
    return redirect(url_for('projects.checkdown', idproy=idproy))


