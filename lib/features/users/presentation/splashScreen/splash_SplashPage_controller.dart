import 'package:app_cirugia_endoscopica/features/users/domain/usecases/user_data_usecase.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SplashScreenController extends GetxController {
  final UserDataUsecase clientDataUsecase;
  
  SplashScreenController({
    required this.clientDataUsecase,
  });
  
  final RxBool isLoading = true.obs;
  final RxString companyName = "".obs;
  
  final RxBool cameraPermissionGranted = false.obs;
  final RxBool storagePermissionGranted = false.obs;
  
  @override
  void onInit() {
    super.onInit();
  }
  

  
Future<void> checkAuthentication() async {
  try {
    await Future.delayed(Duration(seconds: 2)); // <- Espera para mostrar el splash
    await clientDataUsecase.execute();
    
    Get.offAllNamed('/homePage');
  } catch (e) {
    print('⚠️ Error al obtener datos de cliente: $e');
    Get.offAllNamed('/login');
  } finally {
    isLoading.value = false;
  }
}

  
}