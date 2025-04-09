import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/repositories/event_repository.dart';

class EventByIdUsecase {
  final EventRepository eventRepository;

  EventByIdUsecase({required this.eventRepository});

   Future<List<EventsEntity>> execute(String id) async {

    return await eventRepository.eventByid(id);
  }
}