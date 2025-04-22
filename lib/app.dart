import 'package:app_cirugia_endoscopica/common/services/auth_service.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/dashboards/dashboards_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/perfil/perfil_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/login/login_controller.dart';
import 'package:app_cirugia_endoscopica/common/routes/router.dart';
import 'package:app_cirugia_endoscopica/common/settings/routes_names.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/eventbyid/event_by_id_controller.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/events/event_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/splashScreen/splash_SplashPage_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/home/home_controller.dart';
import 'package:app_cirugia_endoscopica/usecase_config.dart';
import 'package:flutter/material.dart';
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
        Get.put(AuthService(), permanent: true);
        
        Get.put(usecaseConfig.userDataUsecase!, permanent: true);
        Get.put(usecaseConfig.loginUsecase!, permanent: true);
        Get.put(usecaseConfig.eventsUsecase!, permanent: true);
        Get.put(usecaseConfig.eventByIdUsecase!, permanent: true);
        Get.put(usecaseConfig.userDebtsUsecase!, permanent: true);
        Get.put(usecaseConfig.userCalendarUsecase!, permanent: true);
        Get.put(usecaseConfig.registerEventUsecase!, permanent: true);
        Get.put(SplashScreenController(
          clientDataUsecase: Get.find(),
        ));
        Get.put(LoginController(loginUsecase: Get.find()));
        
        Get.lazyPut(() => EventsController(eventsUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => EventByIdController(eventByIdUsecase: Get.find(), userDataUsecase: Get.find(), registerEventUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => DashboardsController(
          userDebtsUsecase: Get.find(),
          userDataUsecase: Get.find(), userCalendarUsecase: Get.find(),
        ), fenix: true);
        Get.lazyPut(() => PerfilController(userDataUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => HomeController(), fenix: true);
      }),
      
      initialRoute: RoutesNames.welcomePage, 
      getPages: AppPages.routes, 
      unknownRoute: AppPages.unknownRoute, 
    );
  }
}