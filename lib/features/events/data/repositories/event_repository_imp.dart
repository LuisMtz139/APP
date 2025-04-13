
import 'package:app_cirugia_endoscopica/common/services/auth_service.dart';
import 'package:app_cirugia_endoscopica/features/events/data/datasources/event_data_sources.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/repositories/event_repository.dart';
class EventRepositoryImp implements EventRepository {
  final EventDataSourcesImp userDataSources;

  EventRepositoryImp({required this.userDataSources});

    final AuthService authService = AuthService();

  

  @override
  Future<List<EventsEntity>> events() async {
    final token = await authService.getToken();
    
    if (token == null) {
      throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
    }

    return await userDataSources.events(token);
  }
  
  @override
  Future<List<EventsEntity>> eventByid( String id) async {
     final token = await authService.getToken();
    
    if (token == null) {
      throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
    }

    return await userDataSources.eventByid(token, id);
  }
  
  @override
  Future<List<EventsEntity>> userCalendar()  async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
    }
    return await userDataSources.userCalendar(token);
  }
  
  @override
  Future<void> registerevent(String id, ) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
    }
    return await userDataSources.registerevent(id, token);
  }
  
 
  
}
