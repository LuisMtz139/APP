import 'package:app_cirugia_endoscopica/Page/event/dashboards_page.dart';
import 'package:app_cirugia_endoscopica/common/settings/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AppPages {
  static final routes = [
    GetPage(
      name: RoutesNames.welcomePage,
      page:  () => DashboardsPage(),
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