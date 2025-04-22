import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario Médico',
      debugShowCheckedModeBanner: false,
      theme: MedicalTheme.themeData,
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Médica'),
      ),
      body: Column(
        children: [
          // Calendario superior
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(MedicalTheme.paddingMedium),
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: AppointmentDataSource(_getMedicalAppointments()),
                todayHighlightColor: MedicalTheme.primaryColor,
                selectionDecoration: BoxDecoration(
                  color: MedicalTheme.primaryColor.withOpacity(0.2),
                  border: Border.all(
                    color: MedicalTheme.primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: MedicalTheme.headingSmall,
                ),
                viewHeaderStyle: ViewHeaderStyle(
                  backgroundColor: MedicalTheme.surfaceColor,
                  dayTextStyle: MedicalTheme.subtitleMedium,
                  dateTextStyle: MedicalTheme.bodyMedium,
                ),
                monthViewSettings: const MonthViewSettings(
                  showAgenda: true,
                  agendaViewHeight: 230, // Aumentado de 220 a 230
                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                  agendaItemHeight: 85, // Aumentado de 80 a 85
                ),
                appointmentBuilder: _appointmentBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Estilo personalizado para cada cita
  Widget _appointmentBuilder(BuildContext context, CalendarAppointmentDetails details) {
    final Appointment appointment = details.appointments.first;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Reducido el vertical de 4 a 3
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [appointment.color.withOpacity(0.9), appointment.color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(MedicalTheme.mediumRadius),
        boxShadow: [MedicalTheme.mediumShadow],
      ),
      padding: const EdgeInsets.all(MedicalTheme.paddingMedium),
      child: Row(
        children: [
          Icon(Icons.event_note, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appointment.subject,
                  style: MedicalTheme.subtitleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3), 
                Text(
                  appointment.location ?? '',
                  style: MedicalTheme.bodySmall.copyWith(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Ejemplos de eventos
  List<Appointment> _getMedicalAppointments() {
    return [
      Appointment(
        startTime: DateTime.now().add(const Duration(hours: 3)),
        endTime: DateTime.now().add(const Duration(hours: 4)),
        subject: 'Consulta con Dr. Pérez',
        color: MedicalTheme.primaryColor,
        location: 'Consultorio 203',
      ),
      Appointment(
        startTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
        endTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        subject: 'Cirugía laparoscópica',
        color: MedicalTheme.secondaryColor,
        location: 'Quirófano 2',
      ),
      Appointment(
        startTime: DateTime.now().add(const Duration(days: 3, hours: 10)),
        endTime: DateTime.now().add(const Duration(days: 3, hours: 12)),
        subject: 'Revisión post-operatoria',
        color: MedicalTheme.infoColor,
        location: 'Sala de recuperación',
      ),
      Appointment(
        startTime: DateTime.now().add(const Duration(days: 5, hours: 9)),
        endTime: DateTime.now().add(const Duration(days: 5, hours: 10)),
        subject: 'Evaluación de pacientes',
        color: MedicalTheme.successColor,
        location: 'Sala A',
      ),
    ];
  }
}

/// Fuente de datos personalizada
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}