import 'package:app_cirugia_endoscopica/common/settings/routes_names.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/events/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventosPage extends StatelessWidget {
  final EventsController controller = Get.find<EventsController>();

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
                child: Column(
                  children: [
                    // Buscador de eventos
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(bottom: 20),
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
                        onChanged: controller.onSearch,
                        decoration: InputDecoration(
                          hintText: 'Buscar eventos...',
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
                    
                    // Filtros de categorías
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Obx(() => Row(
                        children: [
                          _buildCategoryChip('Todos', controller.selectedCategory.value == 'Todos'),
                          _buildCategoryChip('Próximos', controller.selectedCategory.value == 'Próximos'),
                          _buildCategoryChip('Congresos', controller.selectedCategory.value == 'Congresos'),
                          _buildCategoryChip('Cursos', controller.selectedCategory.value == 'Cursos'),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          
          return Container(
            padding: const EdgeInsets.only(top: 20),
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Próximos eventos',
                            style: MedicalTheme.headingSmall,
                          ),
                          
                        ],
                      ),
                    ),
                    
                    // Lista de eventos destacados
                    if (controller.featuredEvents.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('No hay eventos destacados disponibles'),
                        ),
                      )
                    else
                      ...controller.featuredEvents.map((event) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildEventCard(event),
                      )),
                    
                    const SizedBox(height: 30),

                   
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.changeCategory(label),
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Chip(
          label: Text(
            label,
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