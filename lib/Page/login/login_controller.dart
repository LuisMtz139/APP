import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Controladores de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Variables observables
  var rememberMe = false.obs;
  var acceptTerms = false.obs;
  var obscurePassword = true.obs;
  
  // Clave global para el formulario
  final formKey = GlobalKey<FormState>();

  // Método para alternar visibilidad de contraseña
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Método para alternar recordar usuario
  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }

  // Método para alternar aceptación de términos
  void toggleAcceptTerms(bool? value) {
    if (value != null) {
      acceptTerms.value = value;
    }
  }

  // Validación de email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  // Validación de contraseña
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Método para iniciar sesión
  void login() {
    if (formKey.currentState!.validate() && acceptTerms.value) {
      // Lógica de login aquí
      Get.snackbar(
        'Éxito',
        'Inicio de sesión exitoso',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else if (!acceptTerms.value) {
      Get.snackbar(
        'Atención',
        'Debes aceptar los términos y condiciones',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}