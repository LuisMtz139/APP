import 'package:app_cirugia_endoscopica/Page/dashboards/dashboards_page.dart';
import 'package:app_cirugia_endoscopica/Page/home/home_page.dart';
import 'package:app_cirugia_endoscopica/common/settings/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AppPages {
  static final routes = [
    GetPage(
      name: RoutesNames.welcomePage,
      page:  () => HomePage(),
    ),
   GetPage(
      name: RoutesNames.homePage,
      page: () => HomePage(),
    ),
    
  ];

  static final unknownRoute = GetPage(
    name: '/not-found',
    page: () => Scaffold(
      body: Center(
        child: Text('Ruta no encontrada'),
      ),
    ),
  );
}