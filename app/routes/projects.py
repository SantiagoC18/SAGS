from flask import Blueprint, render_template, request, redirect, url_for, session, flash, Flask, jsonify
from app.routes.auth import token_required 
from app import mysql

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
        return redirect(url_for('main.index'))


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
            cur.execute("SELECT * FROM proyectos")
            consulta = cur.fetchall()

            id = session['id']
            cur.execute('''
                SELECT * FROM proyectos
                INNER JOIN usu_proy ON proyectos.idproy = usu_proy.idproy
                INNER JOIN usuarios ON usuarios.email = usu_proy.email
                WHERE usu_proy.email = %s
            ''', (id,))
            consulta2 = cur.fetchall()

            cur = mysql.connection.cursor()
            cur.execute('SELECT * FROM usuarios')
            infousuarios = cur.fetchall()

            return render_template('gestor_proyectos.html', data=consulta, data2=consulta2, infoUsu=infousuarios)
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
        return redirect(url_for('auth.login'))  # Updated endpoint

    cur = mysql.connection.cursor()
    
    cur.execute("SELECT * FROM proyectos WHERE idproy = %s", (idproy,))
    data2 = cur.fetchall()
    
    cur.execute('''
        SELECT checklists.aprobacion, modelos.nombre, modelos.descripcion, 
                checklists.progreso, checklists.archivo, checklists.fecha
        FROM proyectos
        INNER JOIN checklists ON proyectos.idproy = checklists.idproy
        INNER JOIN modelos ON checklists.idmod = modelos.idmod
        WHERE checklists.idproy = %s
    ''', (idproy,))
    data = cur.fetchall()
    
    cur.execute('''
        SELECT proyectos.idproy, usuarios.nombres, usuarios.apellidos, 
                count(usuarios.email) integrantes
        FROM proyectos
        INNER JOIN usu_proy ON proyectos.idproy = usu_proy.idproy
        INNER JOIN usuarios ON usuarios.email = usu_proy.email
        WHERE usu_proy.idproy = %s 
        GROUP BY usuarios.nombres, usuarios.apellidos
    ''', (idproy,))
    personal = cur.fetchall()

    return render_template('check-down.html', idproy=idproy, data=data, 
                            data2=data2, colaboradores=personal, log='Cerrar')

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
        cur.execute("INSERT INTO tareas (nombre, descripcion, fechaLimite, estado, prioridad, idsprint, usu_proy) VALUES (%s, %s, %s, %s, %s, %s, 3)",
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
            cur.execute("SELECT * FROM tareas WHERE id_tar = %s", (id_tar,))
            data = cur.fetchall()
            cur.execute('''SELECT t.id_tar,
            t.nombre AS nombre_tarea,
            t.descripcion,
            t.fechaLimite,
            t.estado,
            t.prioridad,
            s.nombre AS nombre_sprint,
            p.nombre AS nombre_proyecto,
            p.idproy,
            usuarios.nombres AS nombre_usuario,
            usuarios.apellidos AS apellido_usuario
            FROM tareas t
            JOIN sprints s ON t.idsprint = s.idsprint
            JOIN proyectos p ON s.idproy = p.idproy
            JOIN usu_proy ON p.idproy = usu_proy.idproy
            JOIN usuarios ON usu_proy.email = usuarios.email
            WHERE t.id_tar = %s limit 1
            ''', (id_tar,))
            data = cur.fetchall()

            idproy = data[0]['idproy']
            cur.execute('SELECT * FROM sprints WHERE idproy = %s', (idproy,))
            data2 = cur.fetchall()

            cur.execute('''SELECT usu_proy.id AS idusu, usuarios.nombres, usuarios.apellidos
            FROM proyectos
            INNER JOIN usu_proy ON proyectos.idproy = usu_proy.idproy
            INNER JOIN usuarios ON usuarios.email = usu_proy.email
            WHERE usu_proy.idproy = %s
            GROUP BY usuarios.nombres, usuarios.apellidos''', (idproy,))
            data3 = cur.fetchall()

            return render_template('edit-task.html', log='Cerrar', data = data, data2 = data2, data3 = data3, id_tar = id_tar)

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
        data = cur.fetchall()

        return render_template('sprints.html', log='Cerrar', data=data, data2=idproy)
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
