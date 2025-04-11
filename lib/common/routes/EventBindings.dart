import 'package:app_cirugia_endoscopica/features/events/domain/usecases/event_by_id_usecase.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/eventbyid/event_by_id_controller.dart';
import 'package:get/get.dart';

class EventBindings extends Bindings {
  @override
  void dependencies() {
    // Registrar el controlador EventByIdController de manera permanente
    Get.put<EventByIdController>(
      EventByIdController(eventByIdUsecase: Get.find<EventByIdUsecase>()),
      permanent: true, // Mantenerlo en memoria para evitar que se elimine
    );
  }
}