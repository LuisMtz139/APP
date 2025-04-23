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
  
  // Propiedades para filtros de categoría y fecha
  final selectedCategory = 'Todos'.obs;
  final selectedDateFilter = 'Todos'.obs;
  final Rx<DateTime?> specificDate = Rx<DateTime?>(null);
  final specificDateFormatted = ''.obs;

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
    fetchEvents();
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
      // Aplica los filtros iniciales después de cargar los eventos
      applyAllFilters();
      isLoading.value = false;
    } catch (e) {
      print('Error al cargar eventos: $e');
      isLoading.value = false;
    }
  }

  // Método para cambiar filtro de categoría
  void changeCategory(String category) {
    selectedCategory.value = category;
    applyAllFilters();
  }
  
  // Método para cambiar filtro de fecha
  void changeDateFilter(String filter) {
    selectedDateFilter.value = filter;
    
    // Si se deselecciona "Fecha específica", limpiamos la fecha específica
    if (filter != 'Fecha específica') {
      specificDate.value = null;
      specificDateFormatted.value = '';
    }
    
    // Aplicar filtros
    applyAllFilters();
  }

  // Método para establecer fecha específica
  void setSpecificDate(DateTime date) {
    specificDate.value = date;
    
    // Formatear la fecha para mostrarla
    final months = [
      '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    specificDateFormatted.value = "${date.day} ${months[date.month]}, ${date.year}";
    
    // Aplicar filtros
    applyAllFilters();
  }
  
  // Método para aplicar todos los filtros (categoría y fecha)
  void applyAllFilters() {
    // Primero filtramos por categoría
    List<EventsEntity> tempEvents = [];
    
    if (selectedCategory.value == 'Todos') {
      // Mostrar todos los eventos
      tempEvents = events.toList();
    } else if (selectedCategory.value == 'Congresos') {
      // Filtrar solo congresos
      tempEvents = events.where((e) => 
        e.tipoEvento.toLowerCase() == 'congreso'
      ).toList();
    } else if (selectedCategory.value == 'Cursos') {
      // Filtrar solo cursos
      tempEvents = events.where((e) => 
        e.tipoEvento.toLowerCase() == 'curso'
      ).toList();
    }
    
    // Luego aplicamos el filtro de fecha sobre los resultados anteriores
    if (selectedDateFilter.value == 'Todos') {
      // No aplicamos filtro adicional
      filteredEvents.assignAll(tempEvents);
    } else if (selectedDateFilter.value == 'Hoy') {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      filteredEvents.assignAll(tempEvents.where((e) {
        final eventDate = DateTime.parse(e.fechaInicio);
        return eventDate.year == today.year && 
               eventDate.month == today.month && 
               eventDate.day == today.day;
      }).toList());
    } else if (selectedDateFilter.value == 'Mañana') {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      
      filteredEvents.assignAll(tempEvents.where((e) {
        final eventDate = DateTime.parse(e.fechaInicio);
        return eventDate.year == tomorrow.year && 
               eventDate.month == tomorrow.month && 
               eventDate.day == tomorrow.day;
      }).toList());
    } else if (selectedDateFilter.value == 'Esta semana') {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      final endDate = startDate.add(Duration(days: 7));
      
      filteredEvents.assignAll(tempEvents.where((e) {
        final eventDate = DateTime.parse(e.fechaInicio);
        return eventDate.isAfter(startDate.subtract(Duration(days: 1))) && 
               eventDate.isBefore(endDate);
      }).toList());
    } else if (selectedDateFilter.value == 'Este mes') {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, 1);
      final endDate = (now.month < 12) 
          ? DateTime(now.year, now.month + 1, 1)
          : DateTime(now.year + 1, 1, 1);
      
      filteredEvents.assignAll(tempEvents.where((e) {
        final eventDate = DateTime.parse(e.fechaInicio);
        return eventDate.isAfter(startDate.subtract(Duration(days: 1))) && 
               eventDate.isBefore(endDate);
      }).toList());
    } else if (selectedDateFilter.value == 'Fecha específica' && specificDate.value != null) {
      final selectedDate = specificDate.value!;
      final dayStart = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final dayEnd = dayStart.add(Duration(days: 1));
      
      filteredEvents.assignAll(tempEvents.where((e) {
        final eventDate = DateTime.parse(e.fechaInicio);
        return eventDate.isAfter(dayStart.subtract(Duration(seconds: 1))) && 
               eventDate.isBefore(dayEnd);
      }).toList());
    }
  }

  // Método para obtener el icono basado en el tipo de evento
  IconData getEventIcon(String tipoEvento) {
    final tipo = tipoEvento.toLowerCase().trim();
    if (tipo == 'congreso') {
      return Icons.people_rounded;
    } else if (tipo == 'curso') {
      return Icons.school_rounded;
    } else {
      return Icons.event_rounded;
    }
  }

  // Getter para eventos destacados (ahora utiliza los eventos filtrados)
  List<EventsEntity> get featuredEvents {
    return filteredEvents;
  }

  // Método para obtener los colores del gradiente basado en el tipo de evento
  List<Color> getEventGradient(String tipoEvento) {
    final tipo = tipoEvento.toLowerCase().trim();
    if (tipo == 'congreso') {
      return [Color(0xFF8A2BE2), Color(0xFFDA70D6)];
    } else if (tipo == 'curso') {
      return [Color(0xFF2E8B57), Color(0xFF3CB371)];
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
        membresiaNombre.value = userData.value!.nombreMembresia ?? 'No especificada';

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
        membresiaNombre.value = "No disponible";
        membresiaEstatus.value = "No disponible";
      }
    } catch (e) {
      print('Error en fetchUserData: ${e.toString()}');
      userName.value = "Usuario";
      membresiaNombre.value = "No disponible";
      membresiaEstatus.value = "No disponible";
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
      membresiaEstatus.value = 'No disponible';
      totalAdeudos.value = '0';
      montoTotalPendiente.value = 0.0;
      return;
    }

    final pendingDebts = userDebts.where(
      (debt) => debt.estatus.toLowerCase() == 'pendiente',
    ).toList();

    totalAdeudos.value = pendingDebts.length.toString();

    const tasaUSD = 21.0;

    montoTotalPendiente.value = pendingDebts.fold(0.0, (prev, debt) {
      final monto = double.tryParse(debt.monto) ?? 0.0;
      final pagado = double.tryParse(debt.cantidadPagada) ?? 0.0;
      final restante = monto - pagado;
      final convertido = (debt.moneda?.toUpperCase() == 'USD') ? restante * tasaUSD : restante;
      return prev + convertido;
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
          "",
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
    final screenHeight = MediaQuery.of(Get.context!).size.height;
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    
    // Obtener la altura del padding inferior para evitar superposición con botones de navegación
    final bottomPadding = MediaQuery.of(Get.context!).padding.bottom;

    Navigator.of(Get.context!).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return StatefulBuilder(
            builder: (context, setState) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Material(
                  color: Colors.black54,
                  child: Stack(
                    children: [
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        tween: Tween<double>(begin: screenHeight, end: 0),
                        builder: (_, value, child) {
                          return Transform.translate(
                            offset: Offset(0, value),
                            child: child,
                          );
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {}, 
                            child: Container(
                              width: screenWidth,
                              constraints: BoxConstraints(
                                maxHeight: screenHeight * 0.9,
                              ),
                              decoration: BoxDecoration(
                                color: MedicalTheme.cardColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: MedicalTheme.dividerColor.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Línea de arrastre
                                  Container(
                                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: MedicalTheme.dividerColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  
                                  // Título
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                                    child: Text(
                                      'Detalle de Adeudos',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: MedicalTheme.textPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  
                                  // Lista de adeudos
                                  Expanded(
                                    child: Obx(() {
                                      if (isLoading.value) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: MedicalTheme.primaryColor,
                                          ),
                                        );
                                      }
                                      
                                      if (userDebts.isEmpty) {
                                        return _buildEmptyDebtsView();
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24),
                                        child: ListView.separated(
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: userDebts.length,
                                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                                          itemBuilder: (_, index) => _buildDebtCard(userDebts[index]),
                                        ),
                                      );
                                    }),
                                  ),
                                  
                                  // Acciones y resumen
                                  Padding(
                                    // Añadimos padding inferior adicional para evitar superposición con botones de navegación
                                    padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding),
                                    child: Column(
                                      children: [
                                        // Resumen
                                        Obx(() => Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total Pendiente:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: MedicalTheme.textSecondaryColor,
                                              ),
                                            ),
                                            Text(
                                              '\$${montoTotalPendiente.value.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: montoTotalPendiente.value > 0 
                                                  ? Colors.orange
                                                  : MedicalTheme.successColor,
                                              ),
                                            ),
                                          ],
                                        )),
                                        
                                        const SizedBox(height: 20),
                                        
                                        // Botón para cerrar
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            icon: const Icon(Icons.close_rounded),
                                            label: const Text("Cerrar"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MedicalTheme.primaryColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                            ),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildEmptyDebtsView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          size: 64,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 16),
        Text(
          "Sin adeudos disponibles",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "¡Estás al día con tus pagos!",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildDebtCard(UserDebtsEntity debt) {
    final isPending = debt.estatus.toLowerCase() == 'pendiente';
    final statusColor = isPending ? Colors.orange : MedicalTheme.successColor;
    final formattedDate = formatDate(debt.creadoEl);

    final montoTotal = double.tryParse(debt.monto) ?? 0.0;
    final montoPagado = double.tryParse(debt.cantidadPagada) ?? 0.0;
    final montoPendiente = montoTotal - montoPagado;

    final esUSD = (debt.moneda.toUpperCase() == 'USD');
    final montoMostrar = esUSD 
        ? (montoPendiente * 21.0).toStringAsFixed(2) 
        : montoPendiente.toStringAsFixed(2);
    final simboloMoneda = 'MXN';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con Tipo y Estatus
          Container(
            decoration: BoxDecoration(
              color: MedicalTheme.primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      debt.tipoAdeudo.toLowerCase() == 'evento' 
                          ? Icons.event_available
                          : Icons.card_membership_rounded,
                      color: MedicalTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      debt.tipoAdeudo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MedicalTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        debt.estatus,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Descripción
                Text(
                  debt.descripcion,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Detalles en dos columnas
                Row(
                  children: [
                    // Primera columna
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          _buildDetailRow('Total:', '\$$montoMostrar $simboloMoneda'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
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