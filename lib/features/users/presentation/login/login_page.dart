import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MedicalTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
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
              SizedBox(height: size.height * 0.07),
              _logoTitulo(size),
              SizedBox(height: size.height * 0.07),
              _formularioInicio(size),
              SizedBox(height: size.height * 0.05),
              _loginBoton(size, context),
              _terminoCondiciones(size),
              SizedBox(height: size.height * 0.02),
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
      key: controller.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.usernameController,
            keyboardType: TextInputType.emailAddress,
            focusNode: controller.emailFocusNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(Get.context!)
                  .requestFocus(controller.passwordFocusNode);
            },
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon:
                  Icon(Icons.email_rounded, color: MedicalTheme.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: MedicalTheme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: MedicalTheme.primaryColor, width: 1.5),
              ),
              filled: true,
              fillColor: MedicalTheme.backgroundColor,
              contentPadding: EdgeInsets.symmetric(
                vertical: size.height * 0.02,
                horizontal: size.width * 0.04,
              ),
            ),
            validator: controller.validateEmail,
          ),
          SizedBox(height: size.height * 0.025),
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if ((controller.formKey as GlobalKey<FormState>)
                    .currentState!
                    .validate()) {
                  if (controller.acceptTerms.value) {
                    controller.login();
                  } else {
                    QuickAlert.show(
                      context: Get.context!,
                      type: QuickAlertType.error,
                      title: 'Acceso Incorrecto',
                      text:
                          'Debes aceptar los términos y condiciones para continuar',
                      confirmBtnColor: MedicalTheme.primaryColor,
                    );
                  }
                }
              },
              obscureText: !controller.passwordVisible.value,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon:
                    Icon(Icons.lock_rounded, color: MedicalTheme.primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.passwordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: MedicalTheme.textSecondaryColor,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: MedicalTheme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: MedicalTheme.primaryColor, width: 1.5),
                ),
                filled: true,
                fillColor: MedicalTheme.backgroundColor,
                contentPadding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02,
                  horizontal: size.width * 0.04,
                ),
              ),
              validator: controller.validatePassword,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginBoton(Size size, BuildContext context) {
    return SizedBox(
      width: size.width * 0.8,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () async {
                  if ((controller.formKey as GlobalKey<FormState>)
                      .currentState!
                      .validate()) {
                    if (!controller.acceptTerms.value) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Uops ...',
                        text:
                            'Debes aceptar los términos y condiciones para continuar',
                        confirmBtnColor: MedicalTheme.primaryColor,
                      );
                      return;
                    }
                    try {
                      controller.isLoading.value = true;
                      await controller.login();
                    } catch (e) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Acceso Incorrecto',
                        text: e.toString().replaceAll('Exception: ', ''),
                        confirmBtnColor: MedicalTheme.primaryColor,
                      );
                    } finally {
                      controller.isLoading.value = false;
                    }
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
          child: controller.isLoading.value
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: MedicalTheme.textLightColor,
                  ),
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
        child: Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: controller.acceptTerms.value,
                onChanged: controller.toggleAcceptTerms,
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
                          ..onTap = () async {
                            final uri =
                                Uri.parse('https://www.amce.org.mx/');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              QuickAlert.show(
                                context: Get.context!,
                                type: QuickAlertType.error,
                                title: 'Error',
                                text: 'No se pudo abrir la página',
                                confirmBtnColor:
                                    MedicalTheme.primaryColor,
                              );
                            }
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
                          ..onTap = () async {
                            final uri = Uri.parse(
                                'https://www.amce.org.mx/');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              QuickAlert.show(
                                context: Get.context!,
                                type: QuickAlertType.error,
                                title: 'Error',
                                text: 'No se pudo abrir la página',
                                confirmBtnColor:
                                    MedicalTheme.primaryColor,
                              );
                            }
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
