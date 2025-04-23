import 'package:app_cirugia_endoscopica/common/services/auth_service.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final LoginUsecase loginUsecase;
  
  LoginController({required this.loginUsecase});
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  
  final RxBool isLoading = false.obs;
  final RxBool passwordVisible = false.obs;
  final RxBool acceptTerms = false.obs;
  
  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }
  
  void toggleAcceptTerms(bool? value) {
    acceptTerms.value = value ?? false;
  }
  
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo electrónico';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }
  
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
  
    return null;
  }
  
  Future<void> login() async {
    try {
      final response = await loginUsecase.execute(
        usernameController.text.trim(),
        passwordController.text,
      );
      
      final authService = AuthService();
      final bool saved = await authService.saveLoginResponse(response);
      Get.offAllNamed('/homePage');
      
    } catch (e) {
      // Propagamos la excepción para que se maneje en la UI con QuickAlert
      rethrow;
    }
  }
  
  @override
  void onClose() {
    // Liberar recursos
    usernameController.dispose();
    passwordController.dispose();
    // También liberamos los recursos de los FocusNode
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}