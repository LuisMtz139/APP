import 'package:app_cirugia_endoscopica/common/settings/routes_names.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/dashboards/dashboards_controller.dart';
import 'package:app_cirugia_endoscopica/features/users/presentation/dashboards/widget/statuscards_skeleton_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardsPage extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardsPage> {
  int _selectedIndex = 0;
  final DashboardsController controller = Get.find<DashboardsController>();

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
// Añade este método a la clase _DashboardScreenState
Widget _buildUpcomingEventsSection() {
  return Obx(() {
    if (controller.isLoading.value) {
      return Center(child: CircularProgressIndicator());
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded, 
                  color: MedicalTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mis próximos eventos',
                  style: MedicalTheme.headingSmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        
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
          )).toList(),
      ],
    );
  });
}

// También necesitas este método en _DashboardScreenState
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
  Widget _buildUpcomingEventsSection() {
    return   Obx(() {
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
                            'próximos eventos',
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
                      )).toList(),
                    
                    const SizedBox(height: 30),

                   
                  ],
                ),
              ),
            ),
          );
        });
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