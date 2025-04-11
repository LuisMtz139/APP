import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/eventbyid/event_by_id_controller.dart';
import 'package:app_cirugia_endoscopica/features/events/presentation/eventbyid/widget/event_skeleton_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventByIdPage extends StatelessWidget {
  final String eventId;
  
  EventByIdPage({Key? key, required this.eventId}) : super(key: key);
  
  final EventByIdController controller = Get.find<EventByIdController>();
  
  @override
  Widget build(BuildContext context) {
    controller.loadEvent(eventId);
    
    return Scaffold(
      backgroundColor: MedicalTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: MedicalTheme.primaryColor,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          // Custom AppBar
          Container(
            color: MedicalTheme.backgroundColor,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: AppBar(
                primary: false,
                backgroundColor: MedicalTheme.backgroundColor,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: MedicalTheme.primaryColor,
                  onPressed: () => Get.back(),
                ),
                title: Column(
                  children: [
                    Text(
                      "DETALLES DEL EVENTO",
                      style: TextStyle(
                        color: MedicalTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() {
                      final tipoEvento = controller.event.value?.tipoEvento ?? 'Evento';
                      return Text(
                        "Información completa sobre este $tipoEvento",
                        style: TextStyle(
                          color: MedicalTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }),
                  ],
                ),
                centerTitle: true,
               
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return EventSkeletonLoading();
              }

              if (controller.hasError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 60, color: MedicalTheme.errorColor),
                      SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        style: MedicalTheme.subtitleMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: Text('Volver'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.event.value == null) {
                return Center(
                  child: Text('No se encontró información del evento'),
                );
              }

              return _buildEventDetails();
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.hasError.value || controller.event.value == null) {
          return SizedBox.shrink();
        }
        
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, -4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MedicalTheme.createPrimaryButton(
                  text: 'Inscribirme ahora',
                  onPressed: () {
                    // Funcionalidad para inscripción
                  },
                  height: 50,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEventDetails() {
    final event = controller.event.value!;
    final gradientColors = controller.getEventGradient(event.tipoEvento);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de evento
          _buildEventBanner(event, gradientColors),
          
          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y tipo de evento
                Text(
                  event.titulo,
                  style: MedicalTheme.headingMedium,
                ),
                SizedBox(height: 8),
                Chip(
                  label: Text(
                    event.tipoEvento.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: gradientColors[0],
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
                SizedBox(height: 24),
                
                // Información principal del evento
                _buildInfoSection(
                  title: 'Duración',
                  icon: Icons.calendar_today_rounded,
                  content: controller.getDurationText(),
                ),
                _buildInfoSection(
                  title: 'Horario',
                  icon: Icons.access_time_rounded,
                  content: '${controller.formatDateWithTime(event.fechaInicio)} - ${controller.formatDateWithTime(event.fechaFin)}',
                ),
                _buildInfoSection(
                  title: 'Ubicación',
                  icon: Icons.location_on_rounded,
                  content: event.ubicacion,
                ),
                if (event.puntosRecertificacion > 0)
                  _buildInfoSection(
                    title: 'Puntos de recertificación',
                    icon: Icons.verified_outlined,
                    content: event.puntosRecertificacion.toString(),
                  ),
                SizedBox(height: 24),
                
                // Descripción del evento
                if (event.descripcion.isNotEmpty) ...[
                  Text(
                    'Descripción',
                    style: MedicalTheme.headingSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.descripcion,
                    style: MedicalTheme.bodyMedium,
                  ),
                  SizedBox(height: 24),
                ],
                
                // Disponibilidad y plazo de inscripción
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MedicalTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información de registro',
                        style: MedicalTheme.subtitleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              title: 'Fecha límite',
                              value: controller.getRegistrationLimit(),
                              icon: Icons.timer_outlined,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              title: 'Disponibilidad',
                              value: controller.getAvailability(),
                              icon: Icons.people_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                
                // Precios por membresía
                _buildPricesSection(),
                
                // Enlace externo si existe
                if (event.enlaceExterno.isNotEmpty) ...[
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MedicalTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: MedicalTheme.primaryColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Más información',
                          style: MedicalTheme.subtitleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Visita el sitio web oficial del evento para obtener información adicional.',
                          style: MedicalTheme.bodyMedium,
                        ),
                        SizedBox(height: 16),
                        MedicalTheme.createPrimaryButton(
                          text: 'Visitar sitio web',
                          onPressed: () {
                            // Abrir enlace externo
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventBanner(dynamic event, List<Color> gradientColors) {
    // URL de la imagen para mostrar
    final String imageUrl = event.posterS3Llave.isNotEmpty 
        ? event.posterS3Llave 
        : event.bannerS3Llave;
    
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl),
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
            right: -50,
            top: -50,
            child: Container(
              width: 150,
              height: 150,
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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Botón para ver la imagen completa (solo visible si hay imagen)
          if (imageUrl.isNotEmpty)
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  _showFullImage(imageUrl);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          
          // Event icon and tag
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    controller.getEventIcon(event.tipoEvento),
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    event.tipoEvento.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  // Método para mostrar la imagen completa en un diálogo
  void _showFullImage(String imageUrl) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.all(8),
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botón de cerrar en la parte superior derecha
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            // Imagen a pantalla completa con posibilidad de zoom
            Flexible(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4,
                child: Hero(
                  tag: 'event_image',
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: Get.height * 0.6,
                            width: Get.width,
                            color: Colors.black,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / 
                                      loadingProgress.expectedTotalBytes!
                                    : null,
                                color: MedicalTheme.primaryColor,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: Get.width,
                            color: Colors.grey[900],
                            child: Center(
                              child: Text(
                                'Error al cargar la imagen',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierColor: Colors.black87,
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MedicalTheme.surfaceColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: MedicalTheme.primaryColor,
              size: 22,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: MedicalTheme.subtitleMedium,
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: MedicalTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: MedicalTheme.textSecondaryColor,
              ),
              SizedBox(width: 4),
              Text(
                title,
                style: MedicalTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: MedicalTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPricesSection() {
    final Map<String, String?> prices = controller.getPricesMap();
    
    if (prices.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Precios',
          style: MedicalTheme.headingSmall,
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: prices.length,
          itemBuilder: (context, index) {
            final entry = prices.entries.elementAt(index);
            final membershipType = entry.key;
            final price = entry.value!;
            final moneda = controller.event.value!.monedaPrecios;
            
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MedicalTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    membershipType,
                    style: MedicalTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$moneda $price',
                    style: MedicalTheme.subtitleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MedicalTheme.primaryColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}