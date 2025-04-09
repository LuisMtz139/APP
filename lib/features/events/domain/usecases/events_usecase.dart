

import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/repositories/event_repository.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/user_data_entity.dart';

class EventsUsecase {
  final EventRepository eventRepository;

  EventsUsecase({required this.eventRepository});

 Future<List<EventsEntity>> execute() async {
  
    return await eventRepository.events();
  }
}