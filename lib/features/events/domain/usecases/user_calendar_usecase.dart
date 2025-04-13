import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/repositories/event_repository.dart';

class UserCalendarUsecase {
  final EventRepository eventRepository;

  UserCalendarUsecase({required this.eventRepository});

   Future<List<EventsEntity>> execute() async {

    return await eventRepository.userCalendar();
  }
}