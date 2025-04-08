
import 'package:app_cirugia_endoscopica/features/events/domain/entities/events_entity.dart';

abstract class EventRepository {
  
  Future<List<EventsEntity>> events();
}
