import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _acceptTerms = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MedicalTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1,
            vertical: size.height * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo y título
              _logoTitulo(size),
              SizedBox(height: size.height * 0.07),
              
              // Formulario de login
              _formularioInicio(size),
              SizedBox(height: size.height * 0.05),
              
              // Botón de login
              _loginBoton(size),
              
              // Términos y condiciones
              _terminoCondiciones(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoTitulo(Size size) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: MedicalTheme.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [MedicalTheme.lightShadow],
          ),
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/AMCE.png',
            width: size.width * 0.25,
            height: size.width * 0.25,
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Text(
          'Iniciar sesión',
          style: MedicalTheme.headingLarge.copyWith(
            fontSize: size.width * 0.08,
            color: MedicalTheme.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
Widget _formularioInicio(Size size) {
  return Form(
    key: _formKey,
    child: Column(
      children: [
        // Campo de correo
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            prefixIcon: Icon(Icons.email_rounded, color: MedicalTheme.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MedicalTheme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MedicalTheme.primaryColor, width: 1.5),
            ),
            filled: true,
            fillColor: MedicalTheme.backgroundColor,
            contentPadding: EdgeInsets.symmetric(
              vertical: size.height * 0.02,
              horizontal: size.width * 0.04,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu correo';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Ingresa un correo válido';
            }
            return null;
          },
        ),
        SizedBox(height: size.height * 0.025),
        
        // Campo de contraseña
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: Icon(Icons.lock_rounded, color: MedicalTheme.primaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: MedicalTheme.textSecondaryColor,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MedicalTheme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MedicalTheme.primaryColor, width: 1.5),
            ),
            filled: true,
            fillColor: MedicalTheme.backgroundColor,
            contentPadding: EdgeInsets.symmetric(
              vertical: size.height * 0.02,
              horizontal: size.width * 0.04,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu contraseña';
            }
            if (value.length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            }
            return null;
          },
        ),
      ],
    ),
  );
}

  Widget _loginBoton(Size size) {
    return SizedBox(
      width: size.width * 0.8,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _acceptTerms) {
            // Lógica de login
          } else if (!_acceptTerms) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Debes aceptar los términos y condiciones'),
                backgroundColor: MedicalTheme.errorColor,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MedicalTheme.primaryColor,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: MedicalTheme.primaryColor.withOpacity(0.3),
        ),
        child: Text(
          'Iniciar sesión',
          style: TextStyle(
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.bold,
            color: MedicalTheme.textLightColor,
          ),
        ),
      ),
    );
  }

  Widget _terminoCondiciones(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.03),
      child: SizedBox(
        width: size.width * 0.8,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value!;
                    });
                  },
                  activeColor: MedicalTheme.primaryColor,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: MedicalTheme.bodyMedium,
                      children: [
                        TextSpan(text: 'Acepto los '),
                        TextSpan(
                          text: 'Términos y Condiciones',
                          style: TextStyle(
                            color: MedicalTheme.primaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Mostrar términos y condiciones
                            },
                        ),
                        TextSpan(text: ' y la '),
                        TextSpan(
                          text: 'Política de Privacidad',
                          style: TextStyle(
                            color: MedicalTheme.primaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Mostrar política de privacidad
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}