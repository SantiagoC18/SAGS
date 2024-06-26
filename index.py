from flask import Flask
from flask import render_template, redirect, request, Response, session, url_for
from flask_mysqldb import MySQL, MySQLdb

app = Flask(__name__, template_folder='templates')

app.config['MYSQL_HOST']='localhost'
app.config['MYSQL_USER']='root'
app.config['MYSQL_PASSWORD']=''
app.config['MYSQL_DB']='sirs'
app.config['MYSQL_CURSORCLASS']='DictCursor'
mysql=MySQL(app)

@app.route('/')
def index():
    if session.get('logueado'):
        return render_template('index.html', hola=session['nombre'])
    else:
        return render_template('index.html')

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
        cur.execute('SELECT * FROM usuarios WHERE correo = %s AND  password = %s LIMIT 1', (correo, clave,))
        account = cur.fetchone()
        
        if account:
            
            session['logueado'] = True
            session['correo'] = account['correo']
            session['nombre'] = account['primer_nombre']
            session['id'] = account['id_usuario']
            
            return redirect(url_for('perfil'))
        else:
            return render_template('login.html', message="0")
    return render_template('login.html', message="0")
        
@app.route('/adduser', methods=['GET', 'POST'])
def adduser():
    if request.method == 'POST':
        id_user = request.form['documento']
        correo = request.form['correo']
        clave = request.form['clave']
        rol = 3
        
    if id_user and correo and clave:
        cur = mysql.connection.cursor()
        sql = "INSERT INTO `usuarios`(`id_usuario`, `password`, `correo`, `cod_rol1`) VALUES (%s, %s, %s, %s)"
        data = (id_user, clave, correo, rol)
        cur.execute(sql,data)
        mysql.connection.commit()
        
        
        cur.execute('SELECT * FROM usuarios WHERE correo = %s AND  password = %s LIMIT 1', (correo, clave,))
        account = cur.fetchone()
        
        if account:
            
            session['logueado'] = True
            session['correo'] = account['correo']
            session['nombre'] = account['primer_nombre']
            session['id'] = account['id_usuario']
            
            return redirect(url_for('perfil'))
        else:
            return render_template('login.html', message="0")
    return render_template('login.html', message="0")


@app.route('/modulos')
def modulos():
    if session.get('logueado'):
        return render_template('modulos.html')
    else:
        return redirect(url_for('login'))
    
#consultar informacion de usuario por medio de id

@app.route('/perfil')
def perfil():
    if session.get('logueado'):
        cur = mysql.connection.cursor()
        consulta = "SELECT * FROM usuarios WHERE id_usuario = %s"
        id = session['id']
        cur.execute(consulta, (id,))
        data = cur.fetchall()
        
        cur.execute(''' SELECT * FROM proyectos
				        INNER JOIN p_i
				        ON proyectos.id_proyecto = p_i.id_proyecto1
				        INNER JOIN usuarios
				        ON usuarios.id_usuario = p_i.id_usuario1
				        WHERE id_usuario = %s;''',(id,))
        data2 = cur.fetchall()
            
        return render_template('perfil.html', usuario = data, datos = data2)
    else:
        return redirect(url_for('login'))


@app.route('/opiniones')
def opiniones():
    return render_template('opiniones.html')

@app.route('/registrar_pro')
def registrar_pro():
    return render_template('registrar_pro.html')
    
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
