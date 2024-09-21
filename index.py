from flask import Flask
from flask import render_template, redirect, request, Response, session, url_for
from flask_mysqldb import MySQL, MySQLdb
from codejana_flask import app, db, login_manager, mail
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer
from flask_mail import Mail
from flask_mail import Message
from codejana_flask.forms import ResetForm, ResetPasswordForm

app = Flask(__name__, template_folder='templates')


##app.config['SECRET_KEY']='thisisfirstflaskapp'


app.config['MYSQL_HOST']='localhost'
app.config['MYSQL_USER']='root'
app.config['MYSQL_PASSWORD']=''
app.config['MYSQL_DB']='sags'
app.config['MYSQL_CURSORCLASS']='DictCursor'
mysql=MySQL(app)

##app.config email
app.config['MAIL_SERVER']='smtp.gmail.com'
app.config['MAIL_PORT']=587
app.config['MAIL_USE_TLS']=True
app.config['MAIL_USERNAME']= 'itncart@gmail.com'
app.config['MAIL_PASSWORD']= 'temppasswordpython'


mail=Mail(app)
fron codejana_flask importes routes

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
                    
                    return render_template('gestor_proyectos.html', data = consulta, log = 'Cerrar')
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








##RESET PASSWORD
def send_mail(user):
    token=user.get_token()
    msg=Message('Password Reset Request',recipients=[user.correo],sender='softwareanalysissa@gmail.com' )
    msg.body=f''' Haz solicitado el restablecimiento de tu constraseña, da click en el siguiente link

{url_for(......)}

Si no puedes realizar el restablecimiento de tu contraseña correctamente, comunicate con nosotros, estamos pendientes de nuestros clientes

O si por el contarrio no solicitaste el restablecimiento de contraseña, por favor ignora este mensaje.
'''



@app.route('/reset_password', methods=['GET','POST'])
def reset():
    form=resetForm()
    if form.validate_on_submit():
        correo=correo.query.filter_by(email=form.email.data).first()
        if correo:
            token = get_token(correo)
            msg = Message('Restablecer contraseña', sender='softwareanalysissa@gmail.com', recipients=[correo.email])
            msg.body = f'Haz clic en el siguiente enlace para restablecer tu contraseña: {url_for("reset_token", token=token, _external=True)}'
            mail.send(msg)
            flash('Restablecer contraseña, revisa tu email', 'success')
            return redirect(url_for('login'))
    return render_template('reset.html', title='Reset Password', form=form)




##Generar Token
def get_token(self,expires_sec=400):
    serial=Serializer(app.config['SECRET_KEY'], expires_in=expires_sec)
    return serial.dumps({'id_user:id_user'}).decode('utf-8')


##Verificación del Token
@staticmethod
def verify_token(token):
    serial=Serializer(app.config['SECRET_KEY'])
    try:
        id_user=serial.loads(token)['id_user']
    except:
        return None
    return User.query.get(id_user)


##Proceso del Token - Restablecer Contraseña
@app.route('/reset_password/<token>', methods=['GET','POST'])
def reset_token(token):
    user = User.verify_token(token)
    if user is None:
        flash('Este codigo es invalido o ha expirado, por favor intentelo de nuevo', 'warning')
        return redirect(url_for('reset'))
    
    
    ##Nueva info password 
    form=ResetPasswordForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        user.password = hashed_password 
        db.session.commit()
        flash('Su contraseña se ha restablecido correctamente, por favor ingrese de nuevo', 'success')
        return redirect(url_for('login'))
    return render_template('form_reset.html', title="Restablecer Contraseña", form=form)