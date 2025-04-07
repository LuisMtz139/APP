import 'dart:convert';

import 'package:app_cirugia_endoscopica/common/constants/constants.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/data/models/login_response.dart';
import 'package:http/http.dart' as http;

abstract class UserLocalDataSources {
  Future<LoginResponse> loginUser(String username, String password, [String? base_datos]);

  
}

class UserLocalDataSourcesImp implements UserLocalDataSources {
  String defaultApiServer = AppConstants.serverBase;

@override
Future<LoginResponse> loginUser(String username, String password, [String? base_datos]) async {
  try {
    final response = await http.post(
      Uri.parse('$defaultApiServer/users/login/'), 
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': username,  
        'password': password,
        'base_datos': base_datos, 
      }),
    );

    print('login: $defaultApiServer/users/login/');
  
    print('login Response status: ${response.statusCode}');
    print('login Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(responseData);
      
      
      
      print('Login exitoso: ${loginResponse.message}');
      return loginResponse;
    } else {
      if (response.statusCode == 401) {
        throw Exception('login Credenciales inválidas');
      } else if (response.statusCode == 400) {
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          final String errorMessage = errorData['detail'] ?? errorData['message'] ?? 'Datos de solicitud incorrectos';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('login Datos de solicitud incorrectos');
        }
      } else {
        throw Exception('login Error en el login: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Error detallado: $e');
    throw Exception('$e');
  }
}


 

  
   
}