import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_cirugia_endoscopica/common/constants/constants.dart';
import 'package:app_cirugia_endoscopica/common/errors/api_errors.dart';
import 'package:app_cirugia_endoscopica/features/events/data/models/userdata/events_model.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:http/http.dart' as http;

class EventDataSourcesImp {
  String defaultApiServer = AppConstants.serverBase;

@override
Future<void> registerevent(String id,String token) async {

 try {
      final response = await http.post(
        Uri.parse('$defaultApiServer/events/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      
      );
      
      
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
      } else {
              print('Error detallado: $response');
              print(' Error detallad ${response.body}'); 
                            print(' Error detallad  id ${id}'); 

              print('Error detallado: ${response.statusCode}');

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
    }  }

  @override
  Future<List<EventsEntity>> eventByid(String token, String id) async {
    try {
      print('🔍 Solicitando evento con ID: $id');
      final response = await http.get(
        Uri.parse('$defaultApiServer/events/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        print('✅ Respuesta recibida para evento ID $id');
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        print('📦 Estructura de respuesta: ${jsonData.runtimeType}');
        
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          // Aquí está la clave: data es un objeto único, no una lista
          final eventData = jsonData['data'] as Map<String, dynamic>;
          print('🔄 Procesando evento único con título: ${eventData['titulo']}');
          
          try {
            // Convertimos el objeto único a modelo y lo devolvemos en una lista
            final event = EventsModel.fromJson(eventData);
            return [event];
          } catch (e) {
            print('❌ Error procesando evento único: $e');
            return [];
          }
        }
        
        return [];
      } else {
        final apiException = ApiExceptionCustom(response: response);
        apiException.validateMesage();
        throw Exception(apiException.message);
      }
    } catch (e) {
      print('❌ Error en eventByid: $e');
      if (e is SocketException || e is http.ClientException || e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<EventsEntity>> events(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$defaultApiServer/events'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          final eventsList = jsonData['data'] as List<dynamic>;
          
          return eventsList
            .map((item) {
              try {
                return EventsModel.fromJson(item);
              } catch (e) {
                print('❌ Error procesando evento: $e');
                return null;
              }
            })
            .whereType<EventsEntity>()
            .toList();
        }
        
        return [];
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
  
  String convertMessageException({required dynamic error}) {
    if (error is SocketException) {
      return 'No hay conexión a Internet. Por favor, verifica tu conexión e intenta nuevamente.';
    } else if (error is TimeoutException) {
      return 'La solicitud ha excedido el tiempo de espera. Por favor, inténtalo de nuevo más tarde.';
    } else {
      return 'Se ha producido un error inesperado. Por favor, inténtalo de nuevo más tarde.';
    }
  }
  Future<List<EventsEntity>> userCalendar(String token, ) async {
     try {
      final response = await http.get(
        Uri.parse('$defaultApiServer/user-calendar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          final eventsList = jsonData['data'] as List<dynamic>;
          
          return eventsList
            .map((item) {
              try {
                return EventsModel.fromJson(item);
              } catch (e) {
                print('❌ Error procesando userCalendar: $e');
                return null;
              }
            })
            .whereType<EventsEntity>()
            .toList();
        }
        
        return [];
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