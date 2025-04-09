import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_cirugia_endoscopica/common/constants/constants.dart';
import 'package:app_cirugia_endoscopica/common/errors/api_errors.dart';
import 'package:app_cirugia_endoscopica/features/users/data/models/login_response.dart';
import 'package:app_cirugia_endoscopica/features/users/data/models/userdata/user_data_model.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/user_data_entity.dart';
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
          'username': username,
          'password': password,
        }),
      );
      
      print('login: $defaultApiServer/token');
      print('login Response status: ${response.statusCode}');
      print('login Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(responseData);
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
@override
Future<List<UserDataEntity>> userData(String token) async {
  try {
    final response = await http.get(
      Uri.parse('$defaultApiServer/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    print('⭐ Código de respuesta: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      print('⭐ Respuesta exitosa');
      
      final dynamic jsonData = json.decode(utf8.decode(response.bodyBytes));      

    if (jsonData is Map<String, dynamic>) {
      if (jsonData.containsKey('data')) {
        final data = jsonData['data'];
        return [UserDataModel.fromJson(data)];
      } else {
        throw Exception('La respuesta no contiene el campo "data"');
      }
    }
    else if (jsonData is List<dynamic>) {
        final List<UserDataEntity> results = [];
        for (var item in jsonData) {
          try {
            results.add(UserDataModel.fromJson(item));
          } catch (e) {
            print('❌ Error procesando item: $e');
          }
        }
        return results;
      } else {
        throw Exception('Formato de respuesta inesperado del servidor');
      }
    } else {
      final apiException = ApiExceptionCustom(response: response);
      apiException.validateMesage();
      throw Exception(apiException.message);
    }
  } catch (e) {
    if (e is SocketException || e is http.ClientException || e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }
    throw Exception(e.toString());
  }
}
}