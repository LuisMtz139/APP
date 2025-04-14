import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/usecases/events_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsController extends GetxController {
  final EventsUsecase eventsUsecase;
  
  // Variables observables
  final RxList<EventsEntity> events = <EventsEntity>[].obs;
  final RxList<EventsEntity> filteredEvents = <EventsEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = 'Todos'.obs;
  final RxString searchQuery = ''.obs;
  
  // Constructor
  EventsController({required this.eventsUsecase});
  
  @override
  void onInit() async {
    super.onInit();
   await fetchEvents();
  }
  
  // Método para obtener los eventos del repositorio
  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final eventsList = await eventsUsecase.execute();
      
      // Imprime para depuración
      print('Eventos obtenidos: ${eventsList.length}');
      for (var event in eventsList) {
        print('Evento: ${event.id} - ${event.titulo} - ${event.tipoEvento}');
      }
      
      events.assignAll(eventsList);
      applyFilters(); // Aplicar filtros iniciales
      isLoading.value = false;
    } catch (e) {
      print('Error al cargar eventos: $e');
      isLoading.value = false;
     
    }
  }
  
  // Método para cambiar la categoría seleccionada
  void changeCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }
  
  // Método para aplicar búsqueda
  void onSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }
  
  // Método para aplicar todos los filtros
  void applyFilters() {
    try {
      List<EventsEntity> result = List.from(events);
      
      // Aplicar filtro de búsqueda
      if (searchQuery.value.isNotEmpty) {
        result = result.where((event) => 
          event.titulo.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          event.descripcion.toLowerCase().contains(searchQuery.value.toLowerCase())
        ).toList();
      }
      
      // Aplicar filtro de categoría
      if (selectedCategory.value != 'Todos') {
        if (selectedCategory.value == 'Próximos') {
          // Filtrar eventos futuros (a partir de hoy)
          final now = DateTime.now();
          result = result.where((event) {
            try {
              final eventDate = DateTime.parse(event.fechaInicio);
              return eventDate.isAfter(now);
            } catch (e) {
              print('Error al parsear fecha: ${event.fechaInicio}');
              return true; // Incluir por defecto si hay error
            }
          }).toList();
        } else if (selectedCategory.value == 'Congresos') {
          result = result.where((event) => 
            event.tipoEvento.toLowerCase() == 'congreso'
          ).toList();
        } else if (selectedCategory.value == 'Cursos') {
          result = result.where((event) => 
            event.tipoEvento.toLowerCase() == 'curso'
          ).toList();
        }
      }
      
      // Imprimir eventos filtrados para depuración
      print('Eventos filtrados: ${result.length}');
      
      // Asignar a la lista filtrada
      filteredEvents.assignAll(result);
      
      // Separar eventos destacados y regulares para depuración
      print('Eventos destacados: ${featuredEvents.length}');
      print('Eventos regulares: ${regularEvents.length}');
      
    } catch (e) {
      print('Error al aplicar filtros: $e');
      // En caso de error, mostrar todos los eventos
      filteredEvents.assignAll(events);
    }
  }
  
  // Método para formatear la fecha
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
  
  // Método para obtener los eventos destacados (los que tienen enInicio = true)
  List<EventsEntity> get featuredEvents {
    return filteredEvents.where((event) => event.enInicio).toList();
  }
  
  // Método para obtener el resto de eventos
  List<EventsEntity> get regularEvents {
    return filteredEvents.where((event) => !event.enInicio).toList();
  }
}