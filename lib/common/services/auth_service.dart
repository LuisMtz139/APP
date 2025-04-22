import 'dart:convert';

import 'package:app_cirugia_endoscopica/common/constants/constants.dart';
import 'package:app_cirugia_endoscopica/features/users/data/models/login_response.dart';
import 'package:app_cirugia_endoscopica/framework/preferences_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final PreferencesUser _prefsUser = PreferencesUser();
  
  LoginResponse? _cachedSession;

  factory AuthService() => _instance;

  AuthService._internal();

  Future<LoginResponse?> getSession() async {
    if (_cachedSession != null) {
      return _cachedSession;
    }

    try {
      final sessionJson = await _prefsUser.loadPrefs(
        type: String, 
        key: AppConstants.sessionKey
      );
      
      if (sessionJson != null && sessionJson.isNotEmpty) {
        final Map<String, dynamic> sessionMap = jsonDecode(sessionJson);
        _cachedSession = LoginResponse.fromJson(sessionMap);
        return _cachedSession;
      }
      
      return null;
    } catch (e) {
      print('❌ Error al obtener datos de sesión: $e');
      return null;
    }
  }

  Future<bool> saveLoginResponse(LoginResponse response) async {
    try {
      _cachedSession = response;
      
      final sessionData = {
        'success': response.success,
        'token': response.token,
        'user': {
          'id': response.user.id,
          'rfc': response.user.rfc,
          'nombre': response.user.nombre,
          'correoElectronico': response.user.correoElectronico,
          'membresia': response.user.membresia,
          'membresiaNombre': response.user.membresiaNombre,
          'estatus': response.user.estatus
        }
      };
      
      _prefsUser.savePrefs(
        type: String,
        key: AppConstants.sessionKey,
        value: jsonEncode(sessionData)
      );
      
      print('✅ Datos de sesión guardados correctamente');
      return true;
    } catch (e) {
      print('❌ Error al guardar datos de sesión: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      _cachedSession = null;
      
      await _prefsUser.clearOnePreference(key: AppConstants.sessionKey);
      
      print('✅ Sesión cerrada correctamente');
      return true;
    } catch (e) {
      print('❌ Error al cerrar sesión: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final session = await getSession();
    return session != null && session.token.isNotEmpty;
  }
  
  Future<String?> getToken() async {
    final session = await getSession();
    return session?.token;
  }
  
  Future<UserData?> getUserData() async {
    final session = await getSession();
    return session?.user;
  }
}