import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/presentation/splashScreen/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  final SplashScreenController controller = Get.find<SplashScreenController>();

  @override
  Widget build(BuildContext context) {
    // Iniciar el proceso de autenticación cuando la página se renderiza
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkAuthentication();
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned.fill(
              child: Image.asset(
                'assets/surgeon_background.jpeg', 
                fit: BoxFit.cover,
              ),
            ),
            
            // Overlay oscuro para mejor contraste
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            
            // Contenido
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Tarjeta blanca en la parte inferior
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/AMCE.png',
                          width: 80,
                          height: 80,
                        ),
                        SizedBox(height: 16),
                        
                        // Texto de la organización
                        Text(
                          'Asociación Mexicana de Cirugía Endoscópica, A.C.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: MedicalTheme.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        SizedBox(height: 30),
                        
                        // Animación de carga
                        Obx(() => controller.isLoading.value 
                          ? _buildLoadingIndicator()
                          : SizedBox()
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MedicalTheme.primaryColor),
          strokeWidth: 3,
        ),
        SizedBox(height: 20),
        Text(
          'Cargando...',
          style: TextStyle(
            color: MedicalTheme.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}