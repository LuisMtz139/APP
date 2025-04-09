import 'package:app_cirugia_endoscopica/Page/dashboards/dashboards_page.dart';
import 'package:app_cirugia_endoscopica/Page/home/home_page.dart';
import 'package:app_cirugia_endoscopica/Page/login/login_page.dart';
import 'package:app_cirugia_endoscopica/common/settings/routes_names.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/eventbyid/event_by_id_page.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/splashScreen/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AppPages {
  static final routes = [
    GetPage(
      name: RoutesNames.welcomePage,
      page:  () => SplashPage(),
    ),
   GetPage(
      name: RoutesNames.homePage,
      page: () => HomePage(),
    ),
    GetPage(
      name: RoutesNames.loginPage,
      page: () => LoginPage(),
    ),
    GetPage(
      name: RoutesNames.eventbyid,
      page: () {
        // Obtiene el ID desde los argumentos de forma segura
        final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
        final String eventId = args['eventId'] as String;
        // Crea la página pasando el ID directamente
        return EventByIdPage(eventId: eventId);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
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