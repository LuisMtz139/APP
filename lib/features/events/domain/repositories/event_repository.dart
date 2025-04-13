
import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';

abstract class EventRepository {
  
  Future<List<EventsEntity>> events();
   Future<List<EventsEntity>> eventByid(String id) ;
   Future<List<EventsEntity>> userCalendar();
   Future<void> registerevent(String id);
}
