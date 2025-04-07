import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_cirugia_endoscopica/common/constants/constants.dart';
import 'package:app_cirugia_endoscopica/common/errors/api_errors.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/data/models/login_response.dart';
import 'package:http/http.dart' as http;


class UserDataSourcesImp  {
  String defaultApiServer = AppConstants.serverBase;

@override
Future<LoginResponse> signin(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$defaultApiServer/token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
      );
      
      print('login: $defaultApiServer/token');
      print('login Response status: ${response.statusCode}');
      print('login Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(responseData);
        print('Login exitoso: ${loginResponse.message}');
        return loginResponse;
      } else {
        final apiException = ApiExceptionCustom(response: response);
        apiException.validateMesage();
        throw Exception(apiException.message);
      }
    } catch (e) {
      if (e is SocketException || e is http.ClientException || e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      print('Error detallado: $e');
      throw Exception('$e');
    }
  }

 

  
   
}