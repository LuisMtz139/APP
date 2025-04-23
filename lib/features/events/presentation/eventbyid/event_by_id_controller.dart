import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/usecases/event_by_id_usecase.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/usecases/register_event_usecase.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/user_data_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/user_data_usecase.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/dashboards/dashboards_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';

class EventByIdController extends GetxController {
  final EventByIdUsecase eventByIdUsecase;
  final UserDataUsecase userDataUsecase;
  final RxBool showAllPrices = false.obs;
  final RegisterEventUsecase registerEventUsecase;
  final RxBool isRegistering = false.obs;

  EventByIdController({
    required this.eventByIdUsecase,
    required this.userDataUsecase,
    required this.registerEventUsecase,
  });

  final DashboardsController dashboardsController =
      Get.find<DashboardsController>();

  final Rx<EventsEntity?> event = Rx<EventsEntity?>(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<UserDataEntity> userData = <UserDataEntity>[].obs;
  final RxString membresiaNombre = 'Cargando...'.obs;
  final RxBool isLoadingMembership = true.obs;

  @override
  void onInit() {
    super.onInit();

    fetchUserData();

    if (Get.arguments != null &&
        Get.arguments is Map &&
        Get.arguments.containsKey('eventId')) {
      final String eventId = Get.arguments['eventId'] as String;
      loadEvent(eventId);
    } else {
      hasError.value = true;
      errorMessage.value = 'No se pudo obtener el ID del evento';
      isLoading.value = false;
    }
  }

  Future<void> fetchUserData() async {
    try {
      isLoadingMembership.value = true;

      final userDataList = await userDataUsecase.execute();
      userData.value = userDataList;

      _processUserData();
    } catch (e) {
      print('Error al cargar datos de usuario: ${e.toString()}');
      membresiaNombre.value = 'No disponible';
    } finally {
      isLoadingMembership.value = false;
    }
  }

  void printEventActivities() {
    if (event.value == null) {
      print('No hay evento cargado.');
      return;
    }
    final activities = event.value!.activities;
    if (activities.isEmpty) {
      print('El evento no tiene actividades registradas.');
      return;
    }
    print('Actividades del evento "${event.value!.titulo}":');
    for (final actividad in activities) {
      print(
          '- Día: ${actividad.dia}, ${actividad.horaInicio.substring(0, 5)}-${actividad.horaFin.substring(0, 5)}');
      print('  Nombre: ${actividad.nombreActividad}');
      print('  Ponente: ${actividad.ponente}');
      print(
          '  Ubicación: ${actividad.ubicacionActividad.isEmpty ? "N/A" : actividad.ubicacionActividad}');
      print('');
    }
  }

  void printEventPrices() {
    if (event.value == null) {
      print('No hay evento cargado.');
      return;
    }
    final prices = getPricesMap();
    if (prices.isEmpty) {
      print('No hay precios disponibles para este evento.');
      return;
    }
    final moneda = event.value!.monedaPrecios;
    print('Costos del evento "${event.value!.titulo}":');
    prices.forEach((membresia, precio) {
      print('- $membresia: $moneda $precio');
    });
  }

  void _processUserData() {
    if (userData.isEmpty) {
      membresiaNombre.value = 'No disponible';
      return;
    }

    final user = userData.first;

    if (user.nombreMembresia.isNotEmpty) {
      membresiaNombre.value = user.nombreMembresia;
    } else {
      membresiaNombre.value = 'No disponible';
    }
  }

  Future<void> loadEvent(String id) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('Cargando evento con ID: $id');

      final List<EventsEntity> events = await eventByIdUsecase.execute(id);

      if (events.isNotEmpty) {
        event.value = events.first;
        print('Evento cargado exitosamente: ${event.value!.titulo}');
        printEventActivities(); // <-- Aquí imprime actividades al cargar el evento
        printEventPrices(); // <-- Aquí imprime precios al cargar el evento
      } else {
        hasError.value = true;
        errorMessage.value = 'No se encontró el evento';
      }
    } catch (e) {
      print('Error al cargar el evento: $e');
      hasError.value = true;
      errorMessage.value = 'Error al cargar el evento: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

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
    return Map.fromEntries(prices.entries
        .where((entry) => entry.value != null && entry.value!.isNotEmpty));
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

    return '$available / $total ';
  }

  Future<void> registerToEvent(BuildContext context) async {
    if (event.value == null) return;

    try {
      isRegistering.value = true;

      await registerEventUsecase.execute(event.value!.id.toString());

      // Actualizar el estado de inscripción
      if (event.value != null) {
        // Cargar el evento de nuevo para obtener el estado actualizado
        await loadEvent(event.value!.id.toString());
      }

      dashboardsController.fetchEvents();
      dashboardsController.fetchUserDebts();
      dashboardsController.fetchUserData();

      // Mostrar el nuevo diálogo personalizado en lugar del QuickAlert
      showSuccessRegistrationDialog(context);
    } catch (e) {
      print('Error al registrarse al evento: $e');

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'No se pudo completar la inscripción: ${e.toString()}',
        confirmBtnText: 'Entendido',
        confirmBtnColor: Colors.red,
      );
    } finally {
      isRegistering.value = false;
    }
  }

  // Método para mostrar el diálogo de inscripción exitosa con opciones
  void showSuccessRegistrationDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Inscripción Exitosa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Te has inscrito correctamente al evento "${event.value!.titulo}". ¿Deseas realizar el pago ahora?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(); // Cierra el modal
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: MedicalTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: MedicalTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Cierra el modal
                        _launchPaymentURL(); // Abre la URL de pago
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MedicalTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Ir a pagar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _launchPaymentURL() async {
    final Uri url = Uri.parse('https://www.amce.org.mx/asociados');
    try {
      // Changed from LaunchMode.externalApplication to platformDefault
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar(
          'Error',
          'No se pudo abrir el enlace de pago',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un problema al intentar abrir el enlace: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  bool isUserAlreadyRegistered() {
    // Verifica si el usuario ya está inscrito usando la propiedad isInEvent del evento
    if (event.value != null && event.value!.isInEvent != null) {
      return event.value!.isInEvent == "true";
    }
    return false;
  }
}
