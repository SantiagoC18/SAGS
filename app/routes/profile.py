from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from app import mysql

bp = Blueprint('profile', __name__)

#Funcion para crear o agregar usuario
        
@bp.route('/adduser', methods=['GET', 'POST'])
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
                
                return redirect(url_for('profile.perfil'))
                    
                
            else:
                # Contraseña incorrecta
                return render_template('login.html', message="Contraseña incorrecta")
        else:
            # Usuario no encontrado
            return render_template('login.html', message="Usuario no encontrado")
    
    return render_template('login.html', message="error")

#Finaliza para crear o agregar usuario

@bp.route('/perfil')
def perfil():
    if not session.get('logueado'):
        return redirect(url_for('auth.login'))
    
    cur = mysql.connection.cursor()
    id = session['id']
    
    # Get user data
    cur.execute("SELECT * FROM usuarios WHERE email = %s", (id,))
    data = cur.fetchall()
    
    # Get user projects
    cur.execute('''
        SELECT * FROM proyectos
        INNER JOIN usu_proy ON proyectos.idproy = usu_proy.idproy
        INNER JOIN usuarios ON usuarios.email = usu_proy.email
        WHERE usu_proy.email = %s
    ''', (id,))
    data2 = cur.fetchall()
        
    return render_template('perfil.html', usuario=data, datos=data2, log='Cerrar')

@bp.route("/actualizar_usuario", methods=["POST"])
def actualizar_usuario():
    if request.method == "POST":
        email = request.form.get("email")
        nombres = request.form["nombres"]
        apellidos = request.form["apellidos"]
        telefono = request.form["telefono"]
        documento = request.form["documento"]

        cur = mysql.connection.cursor()
        try:
            cur.execute("""
                UPDATE usuarios
                SET nombres=%s, apellidos=%s, telefono=%s, documento=%s
                WHERE email=%s
            """, (nombres, apellidos, telefono, documento, email))
            mysql.connection.commit()
            flash("Datos actualizados correctamente", "success")
        except Exception as e:
            mysql.connection.rollback()
            flash(f"Error al actualizar: {e}", "danger")
        finally:
            cur.close()

        return redirect(url_for("profile.perfil"))