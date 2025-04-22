import 'package:app_cirugia_endoscopica/features/events/domain/repositories/event_repository.dart';

class RegisterEventUsecase {
  final EventRepository eventRepository;

  RegisterEventUsecase({required this.eventRepository});

  Future<void> execute(String id) async {
    await eventRepository.registerevent(id);
  }
}