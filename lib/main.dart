
import 'package:app_cirugia_endoscopica/app.dart';
import 'package:app_cirugia_endoscopica/common/settings/enviroment.dart';
import 'package:app_cirugia_endoscopica/framework/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
String enviromentSelect = Enviroment.production.value;

void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();
 
  print('=========ENVIROMENT SELECTED: $enviromentSelect');                                         
  await dotenv.load(fileName: enviromentSelect);
  await PreferencesUser().initiPrefs();

  runApp(const App());
}



