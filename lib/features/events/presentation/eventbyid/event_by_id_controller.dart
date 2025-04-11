import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/usecases/event_by_id_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventByIdController extends GetxController {
  final EventByIdUsecase eventByIdUsecase;

  EventByIdController({required this.eventByIdUsecase});

  final Rx<EventsEntity?> event = Rx<EventsEntity?>(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null && Get.arguments is Map && Get.arguments.containsKey('eventId')) {
      final String eventId = Get.arguments['eventId'] as String;
      loadEvent(eventId);
    } else {
      hasError.value = true;
      errorMessage.value = 'No se pudo obtener el ID del evento';
      isLoading.value = false;
    }
  }

  Future<void> loadEvent(String id) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('Cargando evento con ID: $id'); // Agregar log para depuración

      final List<EventsEntity> events = await eventByIdUsecase.execute(id);
      
      if (events.isNotEmpty) {
        event.value = events.first;
        print('Evento cargado exitosamente: ${event.value!.titulo}');
      } else {
        hasError.value = true;
        errorMessage.value = 'No se encontró el evento';
      }
    } catch (e) {
      print('Error al cargar el evento: $e'); // Agregar log para depuración
      hasError.value = true;
      errorMessage.value = 'Error al cargar el evento: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Métodos para formatear la información del evento
  String formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy', 'es').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String formatDateWithTime(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy - HH:mm', 'es').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String getDurationText() {
    if (event.value == null) return '';
    
    final String startDate = formatDate(event.value!.fechaInicio);
    final String endDate = formatDate(event.value!.fechaFin);
    
    if (startDate == endDate) {
      return startDate;
    } else {
      return '$startDate al $endDate';
    }
  }

  List<Color> getEventGradient(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'congreso':
        return [Color(0xFF0099cc), Color(0xFF00ccff)];
      case 'seminario':
        return [Color(0xFF8A2BE2), Color(0xFFDA70D6)];
      case 'curso':
        return [Color(0xFF4CAF50), Color(0xFF8BC34A)];
      default:
        return [Color(0xFF05699f), Color(0xFF1a4179)];
    }
  }

  IconData getEventIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'congreso':
        return Icons.people_alt_rounded;
      case 'seminario':
        return Icons.school_rounded;
      case 'curso':
        return Icons.book_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Map<String, String?> getPricesMap() {
    if (event.value == null) return {};

    final Map<String, String?> prices = {
      'Enfermera': event.value!.enfermeraO,
      'Estudiante': event.value!.estudiante,
      'Expresidente': event.value!.expresidente,
      'No Socio': event.value!.noSocio,
      'No Socio Residente': event.value!.noSocioResidente,
      'Socio ALACE': event.value!.socioALACE,
      'Socio Activo': event.value!.socioActivo,
      'Socio Honorario': event.value!.socioHonorario,
      'Socio Residente': event.value!.socioResidente,
      'Socio Titular': event.value!.socioTitular,
      'Técnico': event.value!.tecnicoA,
      'Invitado': event.value!.precioInvitado,
    };

    // Filtrar precios nulos o vacíos
    return Map.fromEntries(
      prices.entries.where((entry) => entry.value != null && entry.value!.isNotEmpty)
    );
  }

  String getRegistrationLimit() {
    if (event.value == null || event.value!.fechaLimiteRegistro == null) {
      return 'No especificada';
    }
    
    return formatDate(event.value!.fechaLimiteRegistro!);
  }

  String getAvailability() {
    if (event.value == null || event.value!.limiteUsuarios == null) {
      return 'Cupos ilimitados';
    }
    
    final int total = event.value!.limiteUsuarios!;
    final int registered = event.value!.usuariosInscritos;
    final int available = total - registered;
    
    return '$available disponibles de $total cupos';
  }
}