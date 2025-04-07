import 'package:app_cirugia_endoscopica/features/users%20copy/domain/usecases/client_data_usecase.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SplashScreenController extends GetxController {
  final ClientDataUsecase clientDataUsecase;
  
  SplashScreenController({
    required this.clientDataUsecase,
  });
  
  final RxBool isLoading = true.obs;
  final RxString companyName = "".obs;
  
  // Variables para controlar el estado de los permisos
  final RxBool cameraPermissionGranted = false.obs;
  final RxBool storagePermissionGranted = false.obs;
  
  @override
  void onInit() {
    super.onInit();
  }
  

  
  Future<void> checkAuthentication() async {
    try {
      final clientData = await clientDataUsecase.execute();
              Get.offAllNamed('/homePage');

    } catch (e) {
      print('⚠️ Error al obtener datos de cliente: $e');
      Get.offAllNamed('/homePage');
    } finally {
      isLoading.value = false;
    }
  }
  
}