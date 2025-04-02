from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from app import mysql

bp = Blueprint('projects', __name__)

@bp.route('/gestion_proyectos', methods=["GET", "POST"])
def gestion_proyectos():
    if not session.get('logueado'):
        flash("Debe iniciar sesión primero.")
        return redirect(url_for('auth.login'))

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

            return render_template('gestor_proyectos.html', data=consulta, data2=consulta2, log='Cerrar')
        else:
            flash("Contraseña incorrecta.")
            return redirect(url_for('main.modulos'))

@bp.route('/registrar_pro', methods=['GET', 'POST'])
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
def tasks(idproy):
    if session.get('logueado'):
        idproy = idproy
        return render_template('tasks.html', log='Cerrar', idp=idproy)
    else:
        return redirect(url_for('login'))


@bp.route("/sprints/<int:idproy>")
def sprints(idproy):
    if session.get('logueado'):
        idproy = idproy
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM sprints WHERE idproy = %s", (idproy,))
        data = cur.fetchall()

        return render_template('sprints.html', log='Cerrar', data=data, data2=idproy)
    else:
        return redirect(url_for('login'))

@bp.route('/registrar_sprint/<int:idproy>', methods=['POST'])
def registrar_sprint(idproy):
    nombre = request.form['sprint-name']
    fechai = request.form['fi']
    fechaf = request.form['ff']
    desc = request.form['descripcion']
    estado = request.form['estado']
    
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO `sprints`(`fechaI`, `fechaF`, `nombre`, `descripcion`, `estado`, `idproy`) VALUES ( %s, %s, %s, %s, %s, %s)', (fechai, fechaf, nombre, desc, estado, idproy))
    mysql.connection.commit()
    cur.close()
    
    return redirect(url_for('sprints', idproy = idproy))