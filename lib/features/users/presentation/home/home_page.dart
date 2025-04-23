import 'package:app_cirugia_endoscopica/common/services/auth_service.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCommonAppBar(),
      body: Obx(
        () => controller.pages[controller.selectedIndex.value],
      ),
   
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Obx(
            () => CustomLineIndicatorBottomNavbar(
              selectedColor: MedicalTheme.primaryColor,
              unSelectedColor: MedicalTheme.disabledColor,
              backgroundColor: Colors.white,
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changePage,
              enableLineIndicator: true,
              lineIndicatorWidth: 3,
              indicatorType: IndicatorType.Top,
              customBottomBarItems: [
                CustomBottomBarItems(
                  icon: controller.icons[0],
                  label: controller.titles[0],
                ),
                CustomBottomBarItems(
                  icon: controller.icons[1],
                  label: controller.titles[1],
                ),
                CustomBottomBarItems(
                  icon: controller.icons[2],
                  label: controller.titles[2],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  AppBar _buildCommonAppBar() {
    return AppBar(
      backgroundColor: MedicalTheme.primaryColor,
      //textPrimaryColor
      elevation: 0,
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: MedicalTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [MedicalTheme.lightShadow],
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'assets/AMCE.png',
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(width: 12),
         
        ],
      ),
 actions: [
  GestureDetector(
    onTap: () {
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.confirm,
        title: '¿Estás seguro?',
        text: '¿Quieres cerrar sesión?',
        confirmBtnText: 'Sí',
        cancelBtnText: 'No',
        onConfirmBtnTap: () {
          final AuthService authService = AuthService();
          authService.logout();
          Get.offAllNamed('/login');
        },
        onCancelBtnTap: () {
          Get.back();
        },
      );
    },
    child: Container(
      width: 44, // Mismo tamaño que el logo
      height: 44,
      decoration: BoxDecoration(
        color: MedicalTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12), // Igual que el logo
        boxShadow: [MedicalTheme.lightShadow],
      ),
      padding: const EdgeInsets.all(6), // Igual que el logo
      child: Center(
        child: Icon(
          Icons.logout_rounded,
          color: MedicalTheme.primaryColor,
          size: 26, // Ajusta según el tamaño visual del logo
        ),
      ),
    ),
  ),
  const SizedBox(width: 12),
],
    );
  }
}