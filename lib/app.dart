import 'package:app_cirugia_endoscopica/common/services/auth_service.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/dashboards/dashboards_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/perfil/perfil_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/login/login_controller.dart';
import 'package:app_cirugia_endoscopica/common/routes/router.dart';
import 'package:app_cirugia_endoscopica/common/settings/routes_names.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/eventbyid/event_controller.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/events/event_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/splashScreen/splash_SplashPage_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/home/home_controller.dart';
import 'package:app_cirugia_endoscopica/usecase_config.dart';
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
        Get.put(AuthService(), permanent: true);
        
        Get.put(SplashScreenController(
          clientDataUsecase: usecaseConfig.userDataUsecase!,
        ));
        Get.put(LoginController(loginUsecase: usecaseConfig.loginUsecase!));
        Get.lazyPut(() => EventByIdController(eventByIdUsecase: usecaseConfig.eventByIdUsecase!));
        Get.lazyPut(() => EventsController(eventsUsecase: usecaseConfig.eventsUsecase!));
        Get.lazyPut(() => DashboardsController(userDebtsUsecase: usecaseConfig.userDebtsUsecase!));
        Get.lazyPut(() => PerfilController(userDataUsecase: usecaseConfig.userDataUsecase!));
        
        Get.lazyPut(() => HomeController());
      }),
      
      initialRoute: RoutesNames.welcomePage, 
      getPages: AppPages.routes, 
      unknownRoute: AppPages.unknownRoute, 
    );
  }
}