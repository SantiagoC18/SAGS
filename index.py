from flask import Flask
from flask import render_template, redirect, request, Response, session, url_for, flash
from flask_mysqldb import MySQL, MySQLdb
from flask_mail import Mail, Message
from flask import Flask, render_template, request, jsonify
import sqlite3

import secrets
from datetime import datetime, timedelta

app = Flask(__name__, template_folder='templates')


app.config['MYSQL_HOST']='localhost'
app.config['MYSQL_USER']='root'
app.config['MYSQL_PASSWORD']=''
app.config['MYSQL_DB']='sags'
app.config['MYSQL_CURSORCLASS']='DictCursor'
mysql=MySQL(app)

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = 'softwareanalysissa@gmail.com'
app.config['MAIL_PASSWORD'] = 'kwsv tbct pxwi nczi'
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True

gmail = Mail(app)


#redireccion a la pagina de index

@app.route('/')
def index():
    if session.get('logueado'):
        return render_template('index.html', hola=session['nombre'], log='Cerrar')
    else:
        return render_template('index.html', log='Iniciar')
    

#redireccion del login

@app.route('/login')
def login():
    if session.get('logueado'):
        return redirect(request.referrer)
    else:
        return render_template('login.html')

@app.route('/recovery_email')
def recovery_email():
    return render_template('recovery_email.html')

@app.route('/sobre_nosotros')
def sobre_nosotros():
    if session.get('logueado'):
        return render_template('sobre_nosotros.html', log = 'Cerrar')
    else:
        return render_template('sobre_nosotros.html', log = 'Iniciar')


@app.route('/recuperar_contraseña', methods=['GET','POST'])
def recuperar_contraseña():
    correo = request.form['correo']

    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM usuarios WHERE email = %s', (correo,))
    usuario = cur.fetchone()

    if usuario:
        token = secrets.token_urlsafe(32)
        tiempo_expiracion = datetime.now() + timedelta(minutes=10)

        cur.execute('INSERT INTO reset_tokens (user_id, token, expires_at) VALUES (%s, %s, %s)',
                    (usuario['email'], token, tiempo_expiracion))
        mysql.connection.commit()

        enlace_recuperacion = url_for('password_reset', token=token, _external=True)

        mensaje = Message('Recuperación de contraseña', sender='softwareanalysissa@gmail.com', recipients=[correo])
        mensaje.html = f'''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Recuperación de Contraseña</title>
</head>
<body style="margin: 0; padding: 0; font-family: Arial, Helvetica, sans-serif; background-color: #f4f4f4; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;">
    <!-- Contenedor principal -->
    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;">
        <tr>
            <td align="center" bgcolor="#f4f4f4" style="padding: 20px 0;">
                <!-- Contenedor del email -->
                <table border="0" cellpadding="0" cellspacing="0" width="600" style="max-width: 600px; background-color: #ffffff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);">
                    <!-- Encabezado -->
                    <tr>
                        <td align="center" bgcolor="#ffffff" style="padding: 30px 30px 20px 30px; border-radius: 8px 8px 0 0;">
                            <h1>SAGS</h1>
                        </td>
                    </tr>
                    <!-- Contenido -->
                    <tr>
                        <td bgcolor="#ffffff" style="padding: 0 30px 20px 30px;">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="color: #333333; font-family: Arial, sans-serif; font-size: 24px; font-weight: bold; padding-bottom: 15px; text-align: center;">
                                        Recuperación de Contraseña
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: #666666; font-family: Arial, sans-serif; font-size: 16px; line-height: 24px; padding-bottom: 10px;">
                                        Hola,
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: #666666; font-family: Arial, sans-serif; font-size: 16px; line-height: 24px; padding-bottom: 10px;">
                                        Hemos recibido una solicitud para restablecer tu contraseña. Si no realizaste esta solicitud, puedes ignorar este mensaje.
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: #666666; font-family: Arial, sans-serif; font-size: 16px; line-height: 24px; padding-bottom: 20px;">
                                        Para cambiar tu contraseña, haz clic en el botón de abajo:
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" style="padding: 10px 0 30px 0;">
                                        <!-- Botón con fallback para clientes que no soportan botones -->
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td align="center" bgcolor="#007BFF" style="border-radius: 6px;">
                                                    <a href="{enlace_recuperacion}" target="_blank" style="display: inline-block; padding: 16px 36px; font-family: Arial, sans-serif; font-size: 16px; color: #ffffff; text-decoration: none; border-radius: 6px; font-weight: bold;">Restablecer Contraseña</a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: #666666; font-family: Arial, sans-serif; font-size: 16px; line-height: 24px; padding-bottom: 10px;">
                                        Si el botón no funciona, copia y pega el siguiente enlace en tu navegador:
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: #007BFF; font-family: Arial, sans-serif; font-size: 14px; line-height: 20px; padding-bottom: 20px; word-break: break-all;">
                                        {enlace_recuperacion}
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: #999999; font-family: Arial, sans-serif; font-size: 14px; line-height: 20px; font-style: italic; text-align: center;">
                                        Este enlace expirará en 10 minutos por motivos de seguridad.
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <!-- Pie de página -->
                    <tr>
                        <td bgcolor="#f8f8f8" style="padding: 20px 30px; border-radius: 0 0 8px 8px; border-top: 1px solid #eeeeee;">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="color: #999999; font-family: Arial, sans-serif; font-size: 12px; line-height: 18px; text-align: center;">
                                        &copy; 2024 Tu Empresa. Todos los derechos reservados.<br/>
                                        Si no solicitaste este correo, puedes ignorarlo de forma segura.
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td align="center" style="padding: 15px 0 0 0;">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="text-align: center; padding: 0 10px;">
                                                    <a href="https://www.facebook.com/tuempresa" target="_blank" style="color: #999999; text-decoration: none;">Facebook</a>
                                                </td>
                                                <td style="text-align: center; padding: 0 10px;">
                                                    <a href="https://www.twitter.com/tuempresa" target="_blank" style="color: #999999; text-decoration: none;">Twitter</a>
                                                </td>
                                                <td style="text-align: center; padding: 0 10px;">
                                                    <a href="https://www.instagram.com/tuempresa" target="_blank" style="color: #999999; text-decoration: none;">Instagram</a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>''' 
        
        gmail.send(mensaje)
        flash('Se ha enviado un enlace de recuperación a tu correo electrónico')
        
        return redirect(url_for('login'))
    else:
        flash("El correo no está registrado")
        return redirect(url_for('recovery_email'))


@app.route('/password_reset/<token>', methods=['GET', 'POST'])
def password_reset(token):
    # Buscar el token en la base de datos
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM reset_tokens WHERE token = %s', (token,))
    reset_info = cur.fetchone()
    
    if not reset_info:
        flash('Enlace de recuperación inválido.')
        return redirect(url_for('login'))

    # Comprobar si el token ha caducado
    if datetime.now() > reset_info['expires_at']:
        flash('El enlace de recuperación ha caducado.')
        return redirect(url_for('login'))

    # Si el token es válido y no ha caducado
    if request.method == 'POST':
        nueva_contrasena = request.form['nueva_contrasena']
        confirmar_contrasena = request.form['confirmar_contrasena']

        if nueva_contrasena == confirmar_contrasena:
            
            # Actualizar la contraseña en la base de datos
            cur.execute("UPDATE usuarios SET `password` = (aes_encrypt(%s,'AES')) WHERE email = %s", (nueva_contrasena, reset_info['user_id']))
            mysql.connection.commit()

            # Eliminar el token de restablecimiento
            cur.execute('DELETE FROM reset_tokens WHERE token = %s', (token,))
            mysql.connection.commit()

            flash('Contraseña restablecida exitosamente.')
            return redirect(url_for('login'))
        else:
            flash('Las contraseñas no coinciden.')
    
    return render_template('password_reset.html')


#funcion de login para validar usuario y contraceña
@app.route('/acceso_login', methods=["GET", "POST"])
def acceso_login():
    
    if request.method == 'POST':
        correo = request.form['correo']
        clave = request.form['clave']
            
        cur = mysql.connection.cursor()
        cur.execute('SELECT * FROM usuarios WHERE email = %s LIMIT 1', (correo,))
        account = cur.fetchone()
        cur.close()
            
        if account:
            cur = mysql.connection.cursor()
            cur.execute("SELECT (aes_decrypt(password,'AES')) AS cifrado FROM usuarios WHERE email = %s Limit 1", (correo,))
            clave_cifrada = cur.fetchone()
            
            # Verificar si la contraseña es correcta
            if clave_cifrada['cifrado'].decode('utf-8') == clave:

                session['logueado'] = True
                session['nombre'] = account['nombres']
                session['id'] = account['email']
                
                return redirect(url_for('perfil'))
                    
                
            else:
                # Contraseña incorrecta
                return render_template('login.html', message="Contraseña incorrecta")
        else:
            # Usuario no encontrado
            return render_template('login.html', message="Usuario no encontrado")
#Finaliza funcion login


#funcion de login para validar usuario, contraseña y rol para la gestion de proyectos
@app.route('/gestion_proyectos', methods=["GET", "POST"])
def gestion_proyectos():
    if session.get('logueado'):

        if request.method == 'POST':
            correo = request.form['correo']
            clave = request.form['clave']

            # Verificamos que el correo proporcionado sea igual al correo de la sesión actual
            if correo == session.get('id'):

                cur = mysql.connection.cursor()

                # Verificar si el usuario existe
                cur.execute("SELECT * FROM usuarios WHERE email = %s LIMIT 1", (correo,))
                usuario = cur.fetchone()

                if not usuario:
                    # Usuario no encontrado
                    flash("Usuario no encontrado.")
                    return redirect(url_for('modulos'))

                # Verificar la contraseña
                cur.execute(
                    "SELECT * FROM usuarios WHERE email = %s AND password = AES_ENCRYPT(%s, 'AES') LIMIT 1",
                    (correo, clave,)
                )
                account = cur.fetchone()

                if account:
                    # Usuario con rol de administrador (idrol = 1)
                    cur.execute("SELECT * FROM proyectos")
                    consulta = cur.fetchall()

                    id = session['id']
                    cur.execute(''' SELECT * FROM proyectos
                                INNER JOIN usu_proy
                                ON proyectos.idproy = usu_proy.idproy
                                INNER JOIN usuarios
                                ON usuarios.email = usu_proy.email
                                WHERE usu_proy.email = %s;''', (id,))
                    consulta2 = cur.fetchall()

                    return render_template('gestor_proyectos.html', data=consulta, data2=consulta2, log='Cerrar')
                else:
                    # Contraseña incorrecta
                    flash("Contraseña incorrecta.")
                    return redirect(url_for('modulos'))

            else:
                # Si el correo no es el mismo que el de la sesión actual
                flash("Debe utilizar el mismo correo con el que inició sesión.")
                return redirect(url_for('modulos'))

    else:
        # Si el usuario no está logueado, redirigir al login
        flash("Debe iniciar sesión primero.")
        return redirect(url_for('login'))


#Finaliza funcion login



#Funcion para crear o agregar usuario
        
@app.route('/adduser', methods=['GET', 'POST'])
def adduser():
    if request.method == 'POST':
        id_user = request.form['documento']
        tipo = request.form['tipo']
        correo = request.form['correo']
        clave = request.form['clave']
        rol = 3
        
    if id_user and tipo and correo and clave:
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO `usuarios`(`documento`, `tipodoc`, `email`, `idrol`, `password`) VALUES (%s, %s, %s, %s, aes_encrypt(%s,'AES'))",(id_user, tipo, correo, rol, clave,))
        mysql.connection.commit()
        cur.close()
        
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM usuarios WHERE email = %s AND password = AES_ENCRYPT(%s, 'AES') LIMIT 1", (correo,clave,))
        account = cur.fetchone()
        cur.close()
        
        if account:
            cur = mysql.connection.cursor()
            cur.execute("SELECT (aes_decrypt(password,'AES')) AS cifrado FROM usuarios WHERE email = %s Limit 1", (correo,))
            clave_cifrada = cur.fetchone()
            cur.close()
            # Verificar si la contraseña es correcta
            if clave_cifrada['cifrado'].decode('utf-8') == clave:

                session['logueado'] = True
                session['nombre'] = account['nombres']
                session['id'] = account['email']
                
                return redirect(url_for('perfil'))
                    
                
            else:
                # Contraseña incorrecta
                return render_template('login.html', message="Contraseña incorrecta")
        else:
            # Usuario no encontrado
            return render_template('login.html', message="Usuario no encontrado")
    
    return render_template('login.html', message="error")

#Finaliza para crear o agregar usuario



#Actualizar Usuarios

@app.route("/actualizar_usuario", methods=["POST"])
def actualizar_usuario():
    if request.method == "POST":
        email = request.form.get("email")  # Aseguramos que email se recibe correctamente
        nombres = request.form["nombres"]
        apellidos = request.form["apellidos"]
        telefono = request.form["telefono"]
        documento = request.form["documento"]


        print(f"Recibido email: {email}")  # Verifica en la terminal si el email llega correctamente

        cur = mysql.connection.cursor()
        try:
            cur.execute("""
                UPDATE usuarios
                SET nombres=%s, apellidos=%s, telefono=%s, documento=%s
                WHERE email=%s
            """, (nombres, apellidos, telefono,documento, email))

            mysql.connection.commit()
            print(f"Filas afectadas: {cur.rowcount}")

            flash("Datos actualizados correctamente", "success")
        except Exception as e:
            mysql.connection.rollback()
            flash(f"Error al actualizar: {e}", "danger")
            print(f"Error en la actualización: {e}")
        finally:
            cur.close()

        return redirect(url_for("perfil"))


#Fin actualizar usuarios


#redireccion a los modulos de gestion y creacion de proyectos

@app.route('/modulos')
def modulos():
    if session.get('logueado'):
        message = request.args.get('message')
        return render_template('modulos.html', log='Cerrar', message = message)
    else:
        return redirect(url_for('login', log='Iniciar'))
    

    
#consultar informacion de usuario por medio de id

@app.route('/perfil')
def perfil():
    if session.get('logueado'):
        cur = mysql.connection.cursor()
        consulta = "SELECT * FROM usuarios WHERE email = %s"
        id = session['id']
        cur.execute(consulta, (id,))
        data = cur.fetchall()
        
        cur.execute(''' SELECT * FROM proyectos
                    INNER JOIN usu_proy
                    ON proyectos.idproy = usu_proy.idproy
                    INNER JOIN usuarios
                    ON usuarios.email = usu_proy.email
                    WHERE usu_proy.email = %s;''',(id,))
        data2 = cur.fetchall()
            
        return render_template('perfil.html', usuario = data, datos = data2, log='Cerrar')
    else:
        return redirect(url_for('login', log='Iniciar'))
    

#redireccion para el apartado de opniones


@app.route('/opiniones')
def opiniones():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM opiniones")
    data = cur.fetchall()
        
    if session.get('logueado'):
        return render_template('opiniones.html', log='Cerrar', data = data)
    
    else:
        return render_template('opiniones.html', log='Iniciar', data = data)

    
#redireccion para el apartado de registrar proyecto

@app.route('/registrar_pro', methods=['GET', 'POST'])
def registrar_pro():
    if session.get('logueado'):
        
        if request.method == 'POST':
            
            proyect_name = request.form['proyect_name']
            descripcion = request.form['descripcion']
            tipo = request.form['tipo']
            fecha = request.form['fecha']
            stake = 1
            
            cur = mysql.connection.cursor()
            
            cur.execute('INSERT INTO proyectos (`nombre`, `descripcion`, `tipo`, `fechaI`) VALUES (%s, %s, %s, %s)', (proyect_name, descripcion, tipo, fecha,))
            idproy = cur.lastrowid
            
            cur.execute('INSERT INTO usu_proy (idproy, email, stake) VALUES (%s, %s, %s)', (idproy, session['id'], stake))
            mysql.connection.commit()
            
            return redirect(url_for('plan', idproy = idproy))
            
        return render_template('registrar_pro.html', log='Cerrar')
    else:
        return redirect(url_for('login'))
    


@app.route('/plan/<int:idproy>', methods=['GET','POST'])
def plan(idproy):
    
    if session.get('logueado'):
        
        idp = idproy
        plan = request.form.get('plan')
        modelos = request.form.getlist('model')
        progreso = 0

    
        
        if request.method == 'POST':
    
            # Actualizar el proyecto con el plan seleccionado
            cur = mysql.connection.cursor()
            cur.execute("UPDATE proyectos SET nomplan = %s WHERE idproy = %s", (plan, idp))
            mysql.connection.commit()

            # Insertar en `checklists` dependiendo el plan
            if plan in ["BASIC", "STANDARD", "PREMIUM"]:
                
                # Asignar modelos predefinidos según el plan
                modelos_default = {
                    "BASIC": ["RQ", "CU", "CUX",],
                    "STANDARD": ["RQ", "CU", "CUX", "MC", "MO"],
                    "PREMIUM": ["RQ", "CU", "CUX", "MC", "MO", "MER",  "MR"]
                    }
                modelos = modelos_default[plan]
                cur = mysql.connection.cursor()
                for modelo in modelos:
                    cur.execute("INSERT INTO checklists (idproy, idmod, progreso) VALUES (%s, %s, %s)", (idp, modelo, progreso))
                mysql.connection.commit()
                
            elif plan == "PERSONALIZADO":
                if not modelos:  # Verifica si la lista está vacía
                    flash("Por favor, selecciona al menos un modelo.", "warning")
                    return redirect(url_for('plan', idproy=idp))
                
                # Insertar solo los modelos seleccionados
                for modelo in modelos:
                    cur.execute("INSERT INTO checklists (idproy, idmod, progreso) VALUES (%s, %s, %s)", (idp, modelo, progreso))
                mysql.connection.commit()
                return redirect(url_for('perfil'))
                
                
            # Insertar los modelos en la tabla `checklists`
            
            
            return redirect(url_for('perfil'))

            
        return render_template('formulario-plan.html', log='Cerrar')
    else:
        return redirect(url_for('login'))


#consulta de proyectos 
    
@app.route('/')
def proyectos():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM `proyectos`')
    data = cur.fetchall()
    return render_template('perfil.html', datos = data)


#redireccion al apartado de checklist de usuario donde solo puedo consultar la informacion y descargar los documentos

@app.route("/checkdown/<int:idproy>")
def checkdown(idproy):
    if session.get('logueado'):

        cur = mysql.connection.cursor()
        consulta = "SELECT * FROM proyectos WHERE idproy = %s"
        id = idproy
        cur.execute(consulta, (id,))
        data2 = cur.fetchall()
        
        cur.execute(''' SELECT checklists.aprobacion, modelos.nombre,modelos.descripcion, checklists.progreso, checklists.archivo,checklists.fecha
                    FROM proyectos
                    INNER JOIN checklists
                    ON proyectos.idproy = checklists.idproy
                    INNER JOIN modelos
                    ON checklists.idmod = modelos.idmod
                    WHERE checklists.idproy = %s;''',(idproy,))
        data = cur.fetchall()
        
        cur.execute('''SELECT proyectos.idproy, usuarios.nombres,usuarios.apellidos, count(usuarios.email) integrantes
                    FROM proyectos
                    INNER JOIN usu_proy ON proyectos.idproy = usu_proy.idproy
                    INNER JOIN usuarios ON usuarios.email = usu_proy.email
                    WHERE usu_proy.idproy = %s 
                    GROUP BY usuarios.nombres, usuarios.apellidos''', (idproy,))
        personal = cur.fetchall()
    
        return render_template('check-down.html', idproy = id, data=data, data2=data2, colaboradores = personal, log='Cerrar')
    
    else:
        return redirect(url_for('login'))
    

@app.route("/tasks/<int:idproy>")
def tasks(idproy):
    if session.get('logueado'):
        idproy = idproy
        return render_template('tasks.html', log='Cerrar', idp=idproy)
    else:
        return redirect(url_for('login'))


@app.route("/sprints/<int:idproy>")
def sprints(idproy):
    if session.get('logueado'):
        idproy = idproy
        return render_template('sprints.html', log='Cerrar')
    else:
        return redirect(url_for('login'))

#mostrar usuarios en vista administrador
@app.route("/get_usuarios")
def get_usuarios():
    cur = mysql.connection.cursor()
    cur.execute("SELECT email, nombres, idrol FROM usuarios")
    usuarios = [{"id": row["email"], "nombre": row["nombres"], "cargo": row["idrol"]} for row in cur.fetchall()]
    cur.close()
    return jsonify(usuarios)


@app.route("/asignar_usuarios", methods=["POST"])
def asignar_usuarios():
    data = request.json
    cur = mysql.connection.cursor()

    for usuario_id in data["usuarios"]:
        cur.execute("SELECT COUNT(*) FROM usuarios_proyectos WHERE usuario_id = %s AND proyecto_id = %s",
                    (usuario_id, data["proyecto_id"]))
        if cur.fetchone()[0] == 0: 
            cur.execute("INSERT INTO usuarios_proyectos (usuario_id, proyecto_id) VALUES (%s, %s)",
                        (usuario_id, data["proyecto_id"]))

    mysql.connection.commit()
    cur.close()
    return jsonify({"message": "Usuarios asignados correctamente"})



#redireccion y destruccion de sesion del usuario

@app.route("/logout")
def logout():
    session.pop("logueado", None)
    return redirect(url_for('login'))



if __name__ == '__main__':
    app.secret_key="4546416vblñvkbmgvlñkbjfgñfglñv.ñ"
    app.run(debug=True, host='0.0.0.0', port=5000, threaded=True)
