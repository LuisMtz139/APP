import 'package:app_cirugia_endoscopica/features/users/presentation/perfil/perfil_page.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/events/event_page.dart';
import 'package:get/get.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/dashboards/dashboards_page.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  
  final List<Widget> pages = [
    DashboardsPage(),
    EventosPage(), 
    PerfilPage()
  ];
  
  void changePage(int index) {
    if (selectedIndex.value != index) {
      Future.delayed(Duration(milliseconds: 50), () {
        selectedIndex.value = index;
      });
    }
  }
  
  final List<String> titles = [
    'Inicio',
    'Eventos',
    'Perfil',
  ];
  
  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.calendar_today_rounded,
    Icons.person_rounded,
  ];
  
  String get currentTitle => titles[selectedIndex.value];
  
  @override
  void onInit() {
    super.onInit();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
}