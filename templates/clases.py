##Clase Usario (no se si agregarlo :( )
##class User(db.model, UserMixin):
##id_user=db.Column(db.Integer, primary_key=True)
##correo= db.column(db.string(100), unique=True, nullable=False)
##clave= db.Column(db.String(40), nullable=False)




class ResetPasswordForm(FlaskForm):
    email= StringField(label='Email',validators=[DataRequired()])
    submit= submitField(label='Restablecer Contraseña', validators=[DataRequired])


    class ResetPasswordForm(FlaskForm):
    password= passwordField(label='Contraseña',validators=[DataRequired()])
    confirmar_password= passwordField(label='Confirmar Contraseña', validators=[DataRequired])

submit=submitField (label='Cambiar Contraseña', validators=[DataRequired()])
