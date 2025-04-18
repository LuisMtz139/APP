import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/splashScreen/splash_SplashPage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  final SplashScreenController controller = Get.find<SplashScreenController>();

  @override
  Widget build(BuildContext context) {

WidgetsBinding.instance.addPostFrameCallback((_) {
  precacheImage(AssetImage('assets/surgeon_background.png'), context);
  controller.checkAuthentication();
});


    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
Positioned.fill(
  child: Image.asset(
    'assets/surgeon_background.png',
    fit: BoxFit.cover,
    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) {
        return child;
      }
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: const Duration(seconds: 1),
        child: child,
      );
    },
  ),
),

            
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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