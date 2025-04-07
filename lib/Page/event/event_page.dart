import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventosPage extends StatelessWidget {
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
                      child: Row(
                        children: [
                          _buildCategoryChip('Todos', true),
                          _buildCategoryChip('Próximos', false),
                          _buildCategoryChip('Seminarios', false),
                          _buildCategoryChip('Congresos', false),
                          _buildCategoryChip('Cursos', false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
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
                          'Eventos destacados',
                          style: MedicalTheme.headingSmall,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: MedicalTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Filtrar',
                                style: TextStyle(
                                  color: MedicalTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.filter_list_rounded,
                                color: MedicalTheme.primaryColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lista de eventos con el mismo diseño que en DashboardsPage
                  _buildEnhancedEventCard(
                    bannerText: "PGI_X",
                    title: "PGI_X Uso de Verde Indocianina",
                    date: "28 de Abril, 2025",
                    location: "Hospital Central",
                    gradientColors: [MedicalTheme.primaryColor, MedicalTheme.secondaryColor],
                    icon: Icons.medical_services_rounded,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildEnhancedEventCard(
                    bannerText: "SEMINARIO",
                    title: "Seminario de Actualización en Técnicas Quirúrgicas",
                    date: "15 de Mayo, 2025",
                    location: "Centro de Convenciones",
                    gradientColors: [Color(0xFF0099cc), Color(0xFF00ccff)],
                    icon: Icons.school_rounded,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildEnhancedEventCard(
                    bannerText: "CONGRESO",
                    title: "Congreso Internacional de Medicina 2024",
                    date: "2 de Junio, 2025",
                    location: "Ciudad de México",
                    gradientColors: [Color(0xFF8A2BE2), Color(0xFFDA70D6)],
                    icon: Icons.people_rounded,
                  ),
                  
                  const SizedBox(height: 30),

                  // Eventos adicionales
                  Text(
                    'Próximos eventos',
                    style: MedicalTheme.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildEnhancedEventCard(
                    bannerText: "CURSO",
                    title: "Curso Avanzado de Laparoscopía",
                    date: "10 de Julio, 2025",
                    location: "Instituto de Cirugía Avanzada",
                    gradientColors: [Color(0xFF2E8B57), Color(0xFF3CB371)],
                    icon: Icons.medical_information_rounded,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildEnhancedEventCard(
                    bannerText: "TALLER",
                    title: "Taller Práctico de Robótica Quirúrgica",
                    date: "25 de Agosto, 2025",
                    location: "Hospital Tecnológico",
                    gradientColors: [Color(0xFFFF8C00), Color(0xFFFFD700)],
                    icon: Icons.science_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
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
                        style: TextStyle(
                          color: Colors.white,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: gradientColors[0].withOpacity(0.2),
                          child: Text(
                            "DU",
                            style: TextStyle(
                              color: gradientColors[0],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: gradientColors[0].withOpacity(0.2),
                          child: Text(
                            "CM",
                            style: TextStyle(
                              color: gradientColors[0],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: gradientColors[0].withOpacity(0.2),
                          child: Text(
                            "+3",
                            style: TextStyle(
                              color: gradientColors[0],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: gradientColors[0].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Registrarme",
                        style: TextStyle(
                          color: gradientColors[0],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
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
}