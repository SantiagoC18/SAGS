from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from app import mysql, gmail
from flask_mail import Message
import secrets
from datetime import datetime, timedelta

bp = Blueprint('password', __name__)

@bp.route('/recovery_email')
def recovery_email():
    return render_template('recovery_email.html')

@bp.route('/recuperar_contraseña', methods=['GET','POST'])
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

        enlace_recuperacion = url_for('password.password_reset', token=token, _external=True)

        mensaje = Message('Recuperación de contraseña', sender='softwareanalysissa@gmail.com', recipients=[correo])
        mensaje.html = f'''<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Recuperación de Contraseña SAGS</title>
</head>

<body
    style="margin: 0; padding: 0; font-family: Arial, Helvetica, sans-serif; background-color: #000000; color: #ffffff; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;">
    <!-- Contenedor principal -->
    <table border="0" cellpadding="0" cellspacing="0" width="90%" style="min-width: 100%;">
        <tr>
            <td align="center" valign="top" style="padding: 20px 10px;">
                <!-- Contenedor del email -->
                <table border="0" cellpadding="0" cellspacing="0" width="auto"
                    style="max-width: 600px; background-color: #000000;">
                    <!-- Header -->
                    <tr>
                        <td align="left" valign="middle" style="padding: 20px 0;">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td width="50" style="padding-right: 10px;">
                                        <img src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/sirs-wf3veHKLHEjJ0wDWVcEeNGDjGZDhVj.jpg"
                                            alt="SAGS Logo" width="40" height="40"
                                            style="display: block; border-radius: 50%;" />
                                    </td>
                                    <td>
                                        <span style="font-size: 20px; font-weight: bold; color: #ffffff;">SAGS</span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <!-- Contenido principal -->
                    <tr>
                        <td
                            style="background-color: #0a0e17; border: 1px solid #2a2a2a; border-radius: 8px; padding: 30px; position: relative;">

                            <!-- Logo de fondo -->
                            <div
                                style="display: none; right: 0; top: 25%; width: 200px; height: 200px; opacity: 0.2; text-align: right;">
                                <img src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/sirs-wf3veHKLHEjJ0wDWVcEeNGDjGZDhVj.jpg"
                                    alt="SAGS Logo Background" width="180" height="180"
                                    style="display: inline-block;" />
                            </div>

                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td align="center" style="padding-bottom: 25px;">
                                        <h1 style="font-size: 24px; font-weight: bold; color: #ffffff; margin: 0;">
                                            Recuperación de Contraseña</h1>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: #cccccc; padding-bottom: 15px; position: relative; z-index: 2;">
                                        <p style="margin: 0 0 15px 0;">Hola,</p>
                                        <p style="margin: 0 0 15px 0;">Hemos recibido una solicitud para restablecer tu
                                            contraseña. Si no realizaste esta solicitud, puedes ignorar este mensaje.
                                        </p>
                                        <p style="margin: 0 0 25px 0;">Para cambiar tu contraseña, haz clic en el botón
                                            de abajo:</p>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" style="padding: 20px 0 30px 0; position: relative; z-index: 2;">
                                        <!-- Botón -->
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td align="center" bgcolor="#0284C7" style="border-radius: 6px;">
                                                    <a href="{enlace_recuperacion}" target="_blank"
                                                        style="display: inline-block; padding: 12px 32px; font-family: Arial, sans-serif; font-size: 16px; font-weight: bold; color: #ffffff; text-decoration: none;">Restablecer
                                                        Contraseña</a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: #999999; font-size: 14px; position: relative; z-index: 2;">
                                        <p style="margin: 0 0 10px 0;">Si el botón no funciona, copia y pega el
                                            siguiente enlace en tu navegador:</p>
                                        <p style="margin: 0 0 20px 0; color: #0EA5E9; word-break: break-all;">
                                            {enlace_recuperacion}</p>
                                        <p style="margin: 0; font-style: italic; color: #777777;">Este enlace expirará
                                            en 10 minutos por motivos de seguridad.</p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <!-- Espacio -->
                    <tr>
                        <td height="30"></td>
                    </tr>

                    <!-- Footer -->
                    <tr>
                        <td
                            style="border-top: 1px solid #2a2a2a; padding-top: 20px; text-align: center; color: #777777; font-size: 14px;">
                            <p style="margin: 0 0 10px 0;">© 2024 Tu Empresa. Todos los derechos reservados.</p>
                            <p style="margin: 0 0 20px 0;">Si no solicitaste este correo, puedes ignorarlo de forma
                                segura.</p>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td align="center">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="padding: 0 10px;">
                                                    <a href="#" style="color: #0EA5E9; text-decoration: none;">Ayuda</a>
                                                </td>
                                                <td style="padding: 0 10px;">
                                                    <a href="#"
                                                        style="color: #0EA5E9; text-decoration: none;">Contacto</a>
                                                </td>
                                                <td style="padding: 0 10px;">
                                                    <a href="#"
                                                        style="color: #0EA5E9; text-decoration: none;">Privacidad</a>
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
        
        return redirect(url_for('auth.login'))
    else:
        flash("El correo no está registrado")
        return redirect(url_for('recovery_email'))

@bp.route('/password_reset/<token>', methods=['GET', 'POST'])
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

@bp.route("/actualizar_clave", methods=["POST"])
def actualizar_clave():
    if not session.get('logueado'):
        return redirect(url_for('auth.login'))
    
    email = session['id']
    actual = request.form["actual"]
    nueva = request.form["nueva"]
    confirmacion = request.form["confirmacion"]

    cur = mysql.connection.cursor()
    cur.execute("SELECT (aes_decrypt(password,'AES')) AS cifrado FROM usuarios WHERE email = %s Limit 1", (email,))
    usuario = cur.fetchone()

    if usuario['cifrado'].decode('utf-8') == actual:
        if nueva != confirmacion:
            flash("Las contraseñas no coinciden.", "error")
        else:
            cur.execute("UPDATE usuarios SET `password` = (aes_encrypt(%s,'AES')) WHERE email = %s", (nueva, email))
            mysql.connection.commit()
            flash("Contraseña actualizada con éxito.", "success")
    else:
        flash("La contraseña actual es incorrecta.", "error")
    
    cur.close()
    return redirect(url_for("profile.perfil"))