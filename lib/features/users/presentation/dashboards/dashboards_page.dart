import 'package:app_cirugia_endoscopica/common/settings/routes_names.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/dashboards/dashboards_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/dashboards/widget/events_skeleton_loading.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/dashboards/widget/statuscards_skeleton_loading.dart';
import 'package:app_cirugia_endoscopica/main2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardsPage extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardsPage> {
  int _selectedIndex = 0;
  final DashboardsController controller = Get.find<DashboardsController>();
  void _showDatePicker(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: controller.specificDate.value ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: MedicalTheme.primaryColor,
            onPrimary: Colors.white,
            surface: MedicalTheme.surfaceColor,
            onSurface: MedicalTheme.textPrimaryColor,
          ),
          dialogBackgroundColor: MedicalTheme.cardColor,
        ),
        child: child!,
      );
    },
  );
  
  if (picked != null) {
    // Si se seleccionó una fecha, actualizamos el filtro
    controller.setSpecificDate(picked);
    controller.changeDateFilter('Fecha específica');
  }
}
Widget _buildDateFilterChip(String label, bool isSelected) {
  return GestureDetector(
    onTap: () {
      if (label == 'Fecha específica') {
        // Si se presiona "Fecha específica", abrimos el selector de fecha
        _showDatePicker(context);
      } else {
        // Para los demás filtros, cambiamos directamente
        controller.changeDateFilter(label);
      }
    },
    child: Container(
      margin: EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(
          label == 'Fecha específica' && controller.specificDateFormatted.value.isNotEmpty
              ? controller.specificDateFormatted.value
              : label,
          style: TextStyle(
            color: isSelected ? Colors.white : MedicalTheme.textPrimaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: isSelected ? MedicalTheme.primaryColor : MedicalTheme.surfaceColor,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedicalTheme.backgroundColor,
     
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: _buildHeaderSection(),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverStatusCardDelegate(
                child: Container(
                  color: MedicalTheme.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: _buildStatusCardsSection(),
                  ),
                ),
                minHeight: 195,
                maxHeight: 195,
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: MedicalTheme.surfaceColor.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              physics: BouncingScrollPhysics(),
              child: _buildUpcomingEventsSection(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          
        ),
      ),
      
    );
  }

  Widget _buildStatusCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mis Datos',
              style: MedicalTheme.headingSmall,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: StatusCardsSkeletonLoading());
            } else if (controller.error.value.isNotEmpty) {
              return Center(child: Text(controller.error.value));
            } else {
              return ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: controller.buildStatusCards(),
              );
            }
          }),
        ),
      ],
    );
  }

  Widget _buildUpcomingEventsSection() {
  return Obx(() {
    if (controller.isLoading.value) {
      return EventsSkeletonLoading();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mis próximos eventos',
              style: MedicalTheme.headingSmall,
            ),
            GestureDetector(
              onTap: () {
                _showEventsModal(context);
              },
              child: Icon(
                Icons.calendar_month_rounded,
                color: MedicalTheme.primaryColor,
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Filtros de fecha
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Obx(() => Row(
            children: [
              _buildDateFilterChip('Todos', controller.selectedDateFilter.value == 'Todos'),
              _buildDateFilterChip('Hoy', controller.selectedDateFilter.value == 'Hoy'),
              _buildDateFilterChip('Mañana', controller.selectedDateFilter.value == 'Mañana'),
              _buildDateFilterChip('Esta semana', controller.selectedDateFilter.value == 'Esta semana'),
              _buildDateFilterChip('Fecha específica', controller.selectedDateFilter.value == 'Fecha específica'),
            ],
          )),
        ),
        
        const SizedBox(height: 20),
        
        // Lista de eventos destacados
        if (controller.featuredEvents.isEmpty)
          Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Icon(
                  Icons.event_busy,
                  size: 60,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No hay eventos disponibles para ${_getFilterText()}',
                  style: MedicalTheme.subtitleMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        else
          ...controller.featuredEvents.map((event) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildEventCard(event),
          )).toList(),
      ],
    );
  });
}

// Método auxiliar para obtener texto descriptivo del filtro actual
String _getFilterText() {
  switch (controller.selectedDateFilter.value) {
    case 'Hoy':
      return 'hoy';
    case 'Mañana':
      return 'mañana';
    case 'Esta semana':
      return 'esta semana';
    case 'Este mes':
      return 'este mes';
    case 'Fecha específica':
      return controller.specificDateFormatted.value;
    default:
      return 'el filtro seleccionado';
  }
}
void _showEventsModal(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  final bottomPadding = MediaQuery.of(context).padding.bottom;
  final topPadding = MediaQuery.of(context).padding.top;
  
  // Convertir actividades de eventos a appointments para el calendario
  List<Appointment> _getActivitiesAsAppointments() {
    List<Appointment> appointments = [];
    
    // Solo procesar eventos que tienen actividades
    final eventsWithActivities = controller.events.where((event) => 
      event.activities != null && event.activities.isNotEmpty
    ).toList();
    
    for (var event in eventsWithActivities) {
      for (var activity in event.activities) {
        // Convertir strings de fechas y horas a DateTime
        final activityDate = DateTime.parse(activity.dia);
        
        // Parsear hora de inicio (formato HH:MM:SS)
        final startTimeParts = activity.horaInicio.split(':');
        final startHour = int.parse(startTimeParts[0]);
        final startMinute = int.parse(startTimeParts[1]);
        
        // Parsear hora de fin
        final endTimeParts = activity.horaFin.split(':');
        final endHour = int.parse(endTimeParts[0]);
        final endMinute = int.parse(endTimeParts[1]);
        
        // Crear fechas completas con hora de inicio y fin
        final startTime = DateTime(
          activityDate.year, 
          activityDate.month, 
          activityDate.day, 
          startHour, 
          startMinute
        );
        
        final endTime = DateTime(
          activityDate.year, 
          activityDate.month, 
          activityDate.day, 
          endHour, 
          endMinute
        );
        
        // Crear appointment con los datos de la actividad
        appointments.add(
          Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: activity.nombreActividad,
            location: activity.ubicacionActividad,
            notes: activity.ponente, // Usar notes para guardar el ponente
            color: MedicalTheme.secondaryColor,
            isAllDay: false,
          ),
        );
      }
    }
    
    return appointments;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final CalendarController calendarController = CalendarController();
          calendarController.view = CalendarView.month;
          
          return Container(
            height: screenHeight * 0.8,
            width: screenWidth,
            decoration: BoxDecoration(
              color: MedicalTheme.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Column(
                children: [
                  // Barra de arrastre
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: MedicalTheme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Título con botones de cambio de vista
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calendario de Actividades',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MedicalTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Calendario con las actividades
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: MedicalTheme.primaryColor,
                          ),
                        );
                      }
                      
                      final eventsWithActivities = controller.events.where((event) => 
                        event.activities != null && event.activities.isNotEmpty
                      ).toList();
                      
                      if (eventsWithActivities.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No hay actividades disponibles',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      final appointments = _getActivitiesAsAppointments();
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: 
// Actualiza la configuración del calendario para dar más espacio a las citas
SfCalendar(
  controller: calendarController,
  dataSource: AppointmentDataSource(appointments),
  todayHighlightColor: MedicalTheme.primaryColor,
  selectionDecoration: BoxDecoration(
    color: MedicalTheme.primaryColor.withOpacity(0.2),
    border: Border.all(
      color: MedicalTheme.primaryColor,
      width: 1.5,
    ),
    borderRadius: BorderRadius.circular(4),
  ),
  headerStyle: CalendarHeaderStyle(
    textAlign: TextAlign.center,
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: MedicalTheme.textPrimaryColor,
    ),
  ),
  viewHeaderStyle: ViewHeaderStyle(
    backgroundColor: MedicalTheme.surfaceColor.withOpacity(0.3),
    dayTextStyle: TextStyle(
      color: MedicalTheme.textSecondaryColor,
      fontSize: 12,
    ),
    dateTextStyle: TextStyle(
      color: MedicalTheme.textPrimaryColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  ),
  monthViewSettings: MonthViewSettings(
    showAgenda: true,
    agendaViewHeight: 220, // Aumentado de 200 a 220
    appointmentDisplayMode: MonthAppointmentDisplayMode.indicator, // Cambiado a indicator para evitar desbordamientos
    agendaItemHeight: 70,
    appointmentDisplayCount: 1, // Reducido de 2 a 1 para evitar desbordamientos
  ),
  appointmentBuilder: _buildAppointmentWidget,
  scheduleViewSettings: ScheduleViewSettings(
    appointmentItemHeight: 70,
    hideEmptyScheduleWeek: true,
  ),
  showNavigationArrow: true,
  viewNavigationMode: ViewNavigationMode.snap,
  showDatePickerButton: true,
  showCurrentTimeIndicator: true,
  appointmentTimeTextFormat: 'HH:mm',
  timeSlotViewSettings: TimeSlotViewSettings(
    timeFormat: 'HH:mm',
    timeTextStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.grey[600],
    ),
  ),
),
                      );
                    }),
                  ),
                  
                  // Botón para cerrar
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      16, 
                      8, 
                      16, 
                      8 + MediaQuery.of(context).viewPadding.bottom
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MedicalTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Cerrar'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


  // Actualiza el método _buildAppointmentWidget para manejar mejor el espacio
Widget _buildAppointmentWidget(BuildContext context, CalendarAppointmentDetails details) {
  final Appointment appointment = details.appointments.first;
  
  // Verificamos si estamos en un espacio muy pequeño
  final bool isSmallSpace = details.bounds.width < 50 || details.bounds.height < 30;
  
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [appointment.color.withOpacity(0.85), appointment.color],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(6),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    child: isSmallSpace 
      // Si el espacio es muy pequeño, solo mostramos un indicador
      ? Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        )
      // Si hay espacio suficiente, mostramos el contenido
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Importante: minimiza el tamaño vertical
          children: [
            Text(
              appointment.subject,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12, // Reducido de 13 a 12
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (appointment.notes != null && 
                appointment.notes!.isNotEmpty &&
                details.bounds.height > 40) // Solo mostrar ponente si hay suficiente espacio
              Text(
                appointment.notes!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
          ],
        ),
  );
}

  // Constructor personalizado para citas en la vista de agenda
 Widget _buildAgendaAppointmentWidget(BuildContext context, CalendarAppointmentDetails details) {
  final Appointment appointment = details.appointments.first;
  
  // Formatear hora de inicio y fin
  final startHour = appointment.startTime.hour.toString().padLeft(2, '0');
  final startMinute = appointment.startTime.minute.toString().padLeft(2, '0');
  final endHour = appointment.endTime.hour.toString().padLeft(2, '0');
  final endMinute = appointment.endTime.minute.toString().padLeft(2, '0');
  
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      children: [
        // Barra de color vertical que indica el tipo de evento
        Container(
          width: 6,
          decoration: BoxDecoration(
            color: MedicalTheme.primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        // Bloque de hora
        Container(
          width: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$startHour:$startMinute",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: MedicalTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "$endHour:$endMinute",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        // Contenido principal - Ahora más destacado
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre de la actividad con estilo más prominente
                Text(
                  appointment.subject,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: MedicalTheme.textPrimaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (appointment.notes != null && appointment.notes!.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 12,
                        color: MedicalTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          appointment.notes!,
                          style: TextStyle(
                            fontSize: 12,
                            color: MedicalTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                if (appointment.location != null && appointment.location!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: MedicalTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            appointment.location!,
                            style: TextStyle(
                              fontSize: 12,
                              color: MedicalTheme.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _buildEventCard(EventsEntity event) {
    return GestureDetector(
      onTap: () {
        print('Navegando al evento con ID: ${event.id}');
        Get.toNamed(
          RoutesNames.eventbyid, 
          arguments: {
            'eventId': event.id.toString(),
          }
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MedicalTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: controller.getEventGradient(event.tipoEvento)[0].withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner con imagen de fondo o gradiente
            Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: controller.getEventGradient(event.tipoEvento),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image: event.bannerS3Llave.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(event.bannerS3Llave),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Background patterns
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: -30,
                    bottom: -30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Banner content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            controller.getEventIcon(event.tipoEvento),
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 14),
                        Text(
                          event.tipoEvento.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Event details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.titulo,
                    style: MedicalTheme.headingSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: MedicalTheme.textSecondaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        controller.formatDate(event.fechaInicio),
                        style: MedicalTheme.subtitleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 18,
                        color: MedicalTheme.textSecondaryColor,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.ubicacion.isEmpty ? 'Ubicación no disponible' : event.ubicacion,
                          style: MedicalTheme.subtitleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (event.descripcion.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Text(
                      event.descripcion,
                      style: MedicalTheme.subtitleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStatusCard(String title, String status, IconData icon, Color iconColor) {
    return Container(
      width: 170,
      height: 130, // Fixed height to contain all content
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
        mainAxisSize: MainAxisSize.min, // Use min size instead of spaceBetween
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
          Text(
            status,
            style: MedicalTheme.statusText.copyWith(
              fontSize: 16, // Slightly reduced font size
              fontWeight: FontWeight.bold,
              color: MedicalTheme.textPrimaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

 
  Widget _buildEnhancedEventCard({
    required String bannerText,
    required String title,
    required String date,
    required String location,
    required List<Color> gradientColors,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MedicalTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner with gradient
          Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Background patterns
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  bottom: -30,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Banner content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 14),
                      Text(
                        bannerText,
                        style: MedicalTheme.bannerText.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Event details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: MedicalTheme.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: MedicalTheme.textSecondaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      date,
                      style: MedicalTheme.subtitleMedium,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: MedicalTheme.textSecondaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      location,
                      style: MedicalTheme.subtitleMedium,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // En DashboardsPage.dart
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido de nuevo,',
                      style: MedicalTheme.bodyMedium.copyWith(
                        color: MedicalTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                      controller.userName.value,
                      style: MedicalTheme.headingLarge.copyWith(
                        fontSize: 30,
                        color: MedicalTheme.primaryColor,
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Delegate para el comportamiento del encabezado persistente
class _SliverStatusCardDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _SliverStatusCardDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });
  final DashboardsController controller = Get.find<DashboardsController>();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  bool shouldRebuild(_SliverStatusCardDelegate oldDelegate) {
    return child != oldDelegate.child ||
        minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight;
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido de nuevo,',
                      style: MedicalTheme.bodyMedium.copyWith(
                        color: MedicalTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '',
                      style: MedicalTheme.headingLarge.copyWith(
                        fontSize: 30,
                        color: MedicalTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: MedicalTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: MedicalTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: MedicalTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search bar
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: MedicalTheme.surfaceColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar eventos, documentos...',
                hintStyle: MedicalTheme.subtitleMedium,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: MedicalTheme.textSecondaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEventCard(EventsEntity event) {
    return GestureDetector(
      onTap: () {
        print('Navegando al evento con ID: ${event.id}');
        Get.toNamed(RoutesNames.eventbyid, arguments: {'eventId': event.id.toString()});
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MedicalTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: controller.getEventGradient(event.tipoEvento)[0].withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner con imagen de fondo o gradiente
            Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: controller.getEventGradient(event.tipoEvento),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image: event.bannerS3Llave.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(event.bannerS3Llave),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Background patterns
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: -30,
                    bottom: -30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Banner content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            controller.getEventIcon(event.tipoEvento),
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 14),
                        Text(
                          event.tipoEvento.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Event details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.titulo,
                    style: MedicalTheme.headingSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: MedicalTheme.textSecondaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        controller.formatDate(event.fechaInicio),
                        style: MedicalTheme.subtitleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 18,
                        color: MedicalTheme.textSecondaryColor,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.ubicacion.isEmpty ? 'Ubicación no disponible' : event.ubicacion,
                          style: MedicalTheme.subtitleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (event.descripcion.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Text(
                      event.descripcion,
                      style: MedicalTheme.subtitleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}