import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/usecases/user_calendar_usecase.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/user_data_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/user_data_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/userdebts/user_debts_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/user_debts_usecase.dart';

class DashboardsController extends GetxController {
  final UserDebtsUsecase _userDebtsUsecase;
  final UserDataUsecase _userDataUsecase;
  final UserCalendarUsecase _userCalendarUsecase;
  final RxList<EventsEntity> filteredEvents = <EventsEntity>[].obs;

  final RxList<UserDebtsEntity> userDebts = <UserDebtsEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  final Rx<UserDataEntity?> userData = Rx<UserDataEntity?>(null);
  final RxString userName = 'Cargando...'.obs;

  final RxString membresiaNombre = 'Cargando...'.obs;
  final RxString creadoEl = 'Cargando...'.obs;
  final RxString membresiaEstatus = 'Cargando...'.obs;
  final RxString totalAdeudos = '0'.obs;
  final RxDouble montoTotalPendiente = 0.0.obs;
  final RxList<EventsEntity> events = <EventsEntity>[].obs;

  DashboardsController({
    required UserDebtsUsecase userDebtsUsecase,
    required UserDataUsecase userDataUsecase,
    required UserCalendarUsecase userCalendarUsecase,
  })  : _userCalendarUsecase = userCalendarUsecase,
        _userDebtsUsecase = userDebtsUsecase,
        _userDataUsecase = userDataUsecase;
  

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchUserDebts();
    fetchEvents() ;
  }
Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final eventsList = await _userCalendarUsecase.execute();
      
      // Imprime para depuración
      print('Eventos obtenidos: ${eventsList.length}');
      for (var event in eventsList) {
        print('Evento: ${event.id} - ${event.titulo} - ${event.tipoEvento}');
      }
      
      events.assignAll(eventsList);
      isLoading.value = false;
    } catch (e) {
      print('Error al cargar eventos: $e');
      isLoading.value = false;
    
    }
  }// Método para obtener el icono basado en el tipo de evento
  IconData getEventIcon(String tipoEvento) {
    final tipo = tipoEvento.toLowerCase().trim();
    if (tipo == 'congreso') {
      return Icons.people_rounded;
    } else if (tipo == 'curso') {
      return Icons.school_rounded;
    } else if (tipo == 'seminario') {
      return Icons.medical_information_rounded;
    } else {
      return Icons.event_rounded;
    }
  }
   List<EventsEntity> get featuredEvents {
  return events; // Sin filtro, muestra todos los eventos
}
  // Método para obtener los colores del gradiente basado en el tipo de evento
  List<Color> getEventGradient(String tipoEvento) {
    final tipo = tipoEvento.toLowerCase().trim();
    if (tipo == 'congreso') {
      return [Color(0xFF8A2BE2), Color(0xFFDA70D6)];
    } else if (tipo == 'curso') {
      return [Color(0xFF2E8B57), Color(0xFF3CB371)];
    } else if (tipo == 'seminario') {
      return [Color(0xFF0099cc), Color(0xFF00ccff)];
    } else {
      return [Color(0xFFFF8C00), Color(0xFFFFD700)];
    }
  }
  Future<void> fetchUserData() async {
    try {
      final userDataList = await _userDataUsecase.execute();

      if (userDataList.isNotEmpty) {
        userData.value = userDataList.first;
        userName.value = "${userData.value!.nombre} ${userData.value!.apellidoPaterno}";
        membresiaEstatus.value = userData.value!.estatus ?? 'No disponible';

        final createdDate = DateTime.tryParse(userData.value!.creadoEl ?? '');
        if (createdDate != null) {
          final startYear = createdDate.year;
          final endYear = startYear + 1;
          creadoEl.value = "$startYear - $endYear";
        } else {
          creadoEl.value = "No disponible";
        }
      } else {
        userName.value = "Usuario";
      }
    } catch (e) {
      print('Error en fetchUserData: ${e.toString()}');
      userName.value = "Usuario";
    }
  }

  Future<void> fetchUserDebts() async {
    try {
      isLoading.value = true;
      error.value = '';
      final debts = await _userDebtsUsecase.execute();
      userDebts.value = debts;
      _processDebtsData();
    } catch (e) {
      error.value = 'Error al cargar datos: ${e.toString()}';
      print('Error en fetchUserDebts: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _processDebtsData() {
    if (userDebts.isEmpty) {
      membresiaNombre.value = 'No disponible';
      creadoEl.value = 'No disponible';
      membresiaEstatus.value = 'No disponible';
      totalAdeudos.value = '0';
      montoTotalPendiente.value = 0.0;
      return;
    }

    final membresiaDebt = userDebts.firstWhereOrNull(
      (debt) => debt.tipoAdeudo.toLowerCase() == 'membresia',
    );

    if (membresiaDebt != null) {
      membresiaNombre.value = membresiaDebt.nombreMembresia ?? 'No especificada';
    }

    final pendingDebts = userDebts.where(
      (debt) => debt.estatus.toLowerCase() == 'pendiente',
    ).toList();

    totalAdeudos.value = pendingDebts.length.toString();

    montoTotalPendiente.value = pendingDebts.fold(0.0, (prev, debt) {
      return prev +
          (double.tryParse(debt.monto) ?? 0.0) -
          (double.tryParse(debt.cantidadPagada) ?? 0.0);
    });
  }

  List<Widget> buildStatusCards() {
    return [
      _buildEnhancedStatusCard(
        "Estatus Documentos",
        membresiaEstatus.value,
        Icons.card_membership_rounded,
        _getColorByEstatus(membresiaEstatus.value),
      ),
      const SizedBox(width: 16),
      _buildEnhancedStatusCard(
        "Membresía",
        membresiaNombre.value,
        Icons.verified_rounded,
        MedicalTheme.primaryColor,
      ),
      const SizedBox(width: 16),
      GestureDetector(
        onTap: () => showDebtsModal(),
        child: _buildEnhancedStatusCard(
          "Adeudos",
          "${montoTotalPendiente.value.toStringAsFixed(2)}",
          Icons.account_balance_wallet,
          _getColorByAdeudos(totalAdeudos.value),
          showDetailsHint: true,
        ),
      ),
      const SizedBox(width: 16),
      _buildEnhancedStatusCard(
        "Miembro desde",
        creadoEl.value,
        Icons.person,
        _getColorByAdeudos(creadoEl.value),
      ),
    ];
  }

  Widget _buildEnhancedStatusCard(String title, String status, IconData icon, Color iconColor,
      {bool showDetailsHint = false}) {
    return Container(
      width: 170,
      height: 130,
      decoration: BoxDecoration(
        color: MedicalTheme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: Text(
              title,
              style: MedicalTheme.subtitleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: MedicalTheme.textSecondaryColor,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: MedicalTheme.statusText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MedicalTheme.textPrimaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (showDetailsHint) const SizedBox(height: 2),
              if (showDetailsHint)
                Text(
                  "Ver detalles",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
 String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ];
      return "${date.day} ${months[date.month]}, ${date.year}";
    } catch (e) {
      print('Error al formatear fecha: $dateString');
      return dateString;
    }
  }
  void showDebtsModal() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 300),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Detalle de Adeudos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (userDebts.isEmpty) {
                    return const Center(child: Text("Sin adeudos disponibles"));
                  }

                  return ListView.separated(
                    itemCount: userDebts.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      final debt = userDebts[index];
                      return ListTile(
                        title: Text(debt.tipoAdeudo),
                        subtitle: Text("Monto: \$${debt.monto}"),
                        trailing: Text(
                          debt.estatus,
                          style: TextStyle(
                            color: debt.estatus.toLowerCase() == 'pendiente'
                                ? Colors.orange
                                : MedicalTheme.successColor,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("Cerrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorByEstatus(String estatus) {
    switch (estatus.toLowerCase()) {
      case 'activa':
        return MedicalTheme.successColor;
      case 'pendiente':
        return Colors.orange;
      case 'vencida':
        return Colors.red;
      default:
        return MedicalTheme.successColor;
    }
  }

  Color _getColorByAdeudos(String totalAdeudos) {
    final total = int.tryParse(totalAdeudos) ?? 0;

    if (total == 0) {
      return MedicalTheme.successColor;
    } else if (total < 4) {
      return Colors.orange;
    } else if (total >= 4) {
      return Colors.red;
    } else {
      return const Color.fromARGB(255, 6, 20, 27);
    }
  }
}
