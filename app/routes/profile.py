from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from app import mysql

bp = Blueprint('profile', __name__)

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