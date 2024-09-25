from flask import Flask
from flask import render_template, redirect, request, Response, session, url_for
from flask_mysqldb import MySQL, MySQLdb

import secrets
from datetime import datetime, timedelta
from flask import render_template, request, url_for, redirect, session, flash
from flask_mail import Mail, Message  
import hashlib


app = Flask(__name__, template_folder='templates')


app.config['MYSQL_HOST']='localhost'
app.config['MYSQL_USER']='root'
app.config['MYSQL_PASSWORD']=''
app.config['MYSQL_DB']='sags'
app.config['MYSQL_CURSORCLASS']='DictCursor'
mysql=MySQL(app)

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = 'softwareanalysissa@gmail.com'  # Tu correo de Gmail
app.config['MAIL_PASSWORD'] = 'zxau txhd wmip pbqg'  # Contraseña o app password
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
    return render_template('login.html')

@app.route('/recovery_email')
def recovery_email():
    return render_template('recovery_email.html')

@app.route('/recuperar_contraseña', methods=['POST'])
def recuperar_contraseña():
    correo = request.form['correo']
    
    # Comprobar si el correo existe en la base de datos
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM usuarios WHERE email = %s', (correo,))
    usuario = cur.fetchone()

    if usuario:
        # Generar un token seguro
        token = secrets.token_urlsafe(32)
        
        # Calcular el tiempo de expiración (10 minutos)
        tiempo_expiracion = datetime.now() + timedelta(minutes=10)

        # Guardar el token y la hora de expiración en la base de datos (puede ser en una tabla temporal)
        cur.execute('INSERT INTO reset_tokens (user_id, token, expires_at) VALUES (%s, %s, %s)', 
                    (usuario['email'], token, tiempo_expiracion))
        mysql.connection.commit()

        # Crear un enlace con el token
        enlace_recuperacion = url_for('password_reset', token=token, _external=True)

        # Configurar el mensaje de correo
        mensaje = Message('Recuperación de contraseña', sender='softwareanalysissa@gmail.com', recipients=[correo])
        
        mensaje.body = f'Haz clic en el siguiente enlace para restablecer tu contraseña: {enlace_recuperacion}'
        
        # Enviar el correo
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
            # Hashear la nueva contraseña
            nueva_contrasena_hash = hashlib.sha256(nueva_contrasena.encode()).hexdigest()
            
            # Actualizar la contraseña en la base de datos
            cur.execute('UPDATE usuarios SET password = %s WHERE email = %s', (nueva_contrasena, reset_info['user_id']))
            mysql.connection.commit()

            # Eliminar el token de restablecimiento
            cur.execute('DELETE FROM reset_tokens WHERE token = %s', (token,))
            mysql.connection.commit()

            flash('Contraseña restablecida exitosamente.')
            return redirect(url_for('login'))
        else:
            flash('Las contraseñas no coinciden.')
    
    return render_template('password_reset.html')


#funcion de login para validar usuario y contraceñá
@app.route('/acceso_login', methods=["GET", "POST"])
def acceso_login():
    
    if request.method == 'POST':
        correo = request.form['correo']
        clave = request.form['clave']
            
        cur = mysql.connection.cursor()
        cur.execute('SELECT * FROM usuarios WHERE email = %s LIMIT 1', (correo,))
        account = cur.fetchone()
            
        if account:
            # Verificar si la contraseña es correcta
            if account['password'] == clave:  

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


#funcion de login para validar usuario, contraceñá y rol para la gestion de proyectos
@app.route('/gestion_proyectos', methods=["GET", "POST"])
def gestion_proyectos():
    
    if session.get('logueado'):
        
        if request.method == 'POST':
            correo = request.form['correo']
            clave = request.form['clave']
            
            # Verificamos que el correo proporcionado sea igual al correo de la sesión actual
            if correo == session.get('id'):
                
                cur = mysql.connection.cursor()
                
                # Verificar si el usuario tiene rol de administrador (idrol = 1)
                cur.execute('SELECT * FROM usuarios WHERE email = %s AND password = %s AND idrol = 1 LIMIT 1', (correo, clave,))
                account = cur.fetchone()

                if account:
                    cur.execute("SELECT * FROM proyectos")
                    consulta = cur.fetchall()
                    
                    id = session['id']
                    cur.execute(''' SELECT * FROM proyectos
                                INNER JOIN usu_proy
                                ON proyectos.idproy = usu_proy.idproy
                                INNER JOIN usuarios
                                ON usuarios.email = usu_proy.email
                                WHERE usu_proy.email = %s;''',(id,))
                    consulta2 = cur.fetchall()
                    
                    return render_template('gestor_proyectos.html', data = consulta, data2 = consulta2, log = 'Cerrar')
                else:
                    # Verificar si el usuario tiene un rol de usuario regular (idrol = 2)
                    cur.execute('SELECT * FROM usuarios WHERE email = %s AND password = %s AND idrol = 2 LIMIT 1', (correo, clave,))
                    account2 = cur.fetchone()
                    
                    if account2:
                        return redirect(url_for('perfil', message="0"))
                    
                    # Si no se encuentra el usuario con ningún rol válido
                    return redirect(url_for('modulos', message="El usuario no tiene los permisos necesarios."))
            else:
                # Si el correo no es el mismo que el de la sesión actual
                return redirect(url_for('modulos', message="Debe uilizar el mismo correo con el que inició sesión."))
            
    else:
        # Si el usuario no está logueado, redirigir al login
        return redirect(url_for('login'))

#Finaliza funcion login



#Funcion para crear o agregar usuario
        
@app.route('/adduser', methods=['GET', 'POST'])
def adduser():
    if request.method == 'POST':
        id_user = request.form['documento']
        correo = request.form['correo']
        clave = request.form['clave']
        rol = 3
        
    if id_user and correo and clave:
        cur = mysql.connection.cursor()
        sql = "INSERT INTO `usuarios`(`documento`, `password`, `email`, `cod_rol1`) VALUES (%s, aes_encrypt(%s,'AES'), %s, %s)"
        data = (id_user, clave, correo, rol)
        cur.execute(sql,data)
        mysql.connection.commit()
        
        
        cur.execute('SELECT * FROM usuarios WHERE email = %s AND  password = %s LIMIT 1', (correo, clave,))
        account = cur.fetchone()
        
        if account:
            
            session['logueado'] = True
            session['nombre'] = account['nombres']
            session['id'] = account['email']
            
            return redirect(url_for('perfil'))
        else:
            return render_template('login.html', message="0")
    return render_template('login.html', message="0")

#Finaliza para crear o agregar usuario



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
    if session.get('logueado'):
        return render_template('opiniones.html', log='Cerrar')
    else:
        return render_template('opiniones.html', log='Iniciar')
    
#redireccion para el apartado de registrar proyecto

@app.route('/registrar_pro')
def registrar_pro():
    if session.get('logueado'):
        return render_template('registrar_pro.html', log='Cerrar')
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
        
        cur.execute(''' SELECT checklists.aprobacion,modelos.nombre,modelos.descripcion,checklists.archivo,checklists.fecha
		                FROM proyectos
				        INNER JOIN checklists
				        ON proyectos.idproy = checklists.idproy
				        INNER JOIN modelos
			        	ON checklists.idmod = modelos.idmod
			        	WHERE checklists.idproy = %s;''',(idproy,))
        data = cur.fetchall()
    
        return render_template('check-down.html', data=data, data2=data2, log='Cerrar')
    
    else:
        return redirect(url_for('login'))


#redireccion y destruccion de sesion del usuario

@app.route("/logout")
def logout():
    session.pop("logueado", None)
    return redirect(url_for('login'))



if __name__ == '__main__':
    app.secret_key="4546416vblñvkbmgvlñkbjfgñfglñv.ñ"
    app.run(debug=True, host='0.0.0.0', port=5000, threaded=True)
