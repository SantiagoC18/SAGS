from flask import Flask
from flask import render_template, redirect, request, Response, session, url_for
from flask_mysqldb import MySQL, MySQLdb

app = Flask(__name__, template_folder='templates')

app.config['MYSQL_HOST']='localhost'
app.config['MYSQL_USER']='root'
app.config['MYSQL_PASSWORD']=''
app.config['MYSQL_DB']='sags'
app.config['MYSQL_CURSORCLASS']='DictCursor'
mysql=MySQL(app)

@app.route('/')
def index():
    if session.get('logueado'):
        return render_template('index.html', hola=session['nombre'], log='Cerrar')
    else:
        return render_template('index.html', log='Iniciar')

@app.route('/login')
def login():
    return render_template('login.html')


#funcion de login
@app.route('/acceso_login', methods=["GET", "POST"])
def acceso_login():
    
    if request.method == 'POST':
        correo = request.form['correo']
        clave = request.form['clave']
        
        cur = mysql.connection.cursor()
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
        sql = "INSERT INTO `usuarios`(`documento`, `password`, `email`, `cod_rol1`) VALUES (%s, %s, %s, %s)"
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


@app.route('/modulos')
def modulos():
    if session.get('logueado'):
        return render_template('modulos.html', log='Cerrar')
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


@app.route('/opiniones')
def opiniones():
    if session.get('logueado'):
        return render_template('opiniones.html', log='Cerrar')
    else:
        return render_template('opiniones.html', log='Iniciar')

@app.route('/registrar_pro')
def registrar_pro():
    if session.get('logueado'):
        return render_template('registrar_pro.html', log='Cerrar')
    else:
        return redirect(url_for('login'))
    
@app.route('/')
def proyectos():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM `proyectos`')
    data = cur.fetchall()
    return render_template('perfil.html', datos = data)

@app.route("/logout")
def logout():
    session.pop("logueado", None)
    return redirect(url_for('login'))



if __name__ == '__main__':
    app.secret_key="4546416vblñvkbmgvlñkbjfgñfglñv.ñ"
    app.run(debug=True, host='0.0.0.0', port=5000, threaded=True)
