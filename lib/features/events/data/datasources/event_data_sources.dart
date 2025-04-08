import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_cirugia_endoscopica/common/constants/constants.dart';
import 'package:app_cirugia_endoscopica/common/errors/api_errors.dart';
import 'package:app_cirugia_endoscopica/features/events/data/models/userdata/events_model.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/entities/events_entity.dart';
import 'package:http/http.dart' as http;

class EventDataSourcesImp {
  String defaultApiServer = AppConstants.serverBase;

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
}