import 'dart:math';

import 'package:app_cirugia_endoscopica/Page/login/login_controller.dart';
import 'package:app_cirugia_endoscopica/common/routes/router.dart';
import 'package:app_cirugia_endoscopica/common/settings/routes_names.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/eventbyid/event_controller.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/events/event_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/splashScreen/splash_SplashPage_controller.dart';
import 'package:app_cirugia_endoscopica/usecase_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

UsecaseConfig usecaseConfig = UsecaseConfig();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MedicalTheme.themeData, 
      initialBinding: BindingsBuilder(() {
       Get.put(SplashScreenController( clientDataUsecase: usecaseConfig.userDataUsecase!,));
       Get.put(LoginController(loginUsecase: usecaseConfig.loginUsecase!));
       Get.put(EventsController(eventsUsecase: usecaseConfig.eventsUsecase!));
       Get.put(EventByIdController(eventByIdUsecase: usecaseConfig.eventByIdUsecase!));
      }),
      
      initialRoute: RoutesNames.welcomePage, 
      getPages: AppPages.routes, 
      unknownRoute: AppPages.unknownRoute, 
    );
  }
}