import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedicalTheme.backgroundColor,
      
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de avatar
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: MedicalTheme.surfaceColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/AMCE.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Dr. Ulibarri',
                    style: MedicalTheme.headingMedium,
                  ),
                  Text(
                    'Miembro Activo',
                    style: TextStyle(
                      color: MedicalTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            
            // Formulario de datos personales
            _buildLabeledTextField('RFC', isRequired: true),
            SizedBox(height: 16),
            _buildLabeledTextField('CURP', isRequired: true),
            SizedBox(height: 16),
            _buildLabeledTextField('Nombre', isRequired: true),
            SizedBox(height: 16),
            _buildLabeledTextField('Apellido', isRequired: true),
            SizedBox(height: 16),
            _buildLabeledTextField('Correo electrónico'),
            SizedBox(height: 16),
            _buildLabeledTextField('Teléfono'),
            SizedBox(height: 16),
            _buildLabeledTextField('Especialidad'),
            
           
            
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLabeledTextField(String label, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: MedicalTheme.textPrimaryColor,
                fontSize: 14,
              ),
            ),
            if (isRequired)
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MedicalTheme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Input',
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
 
}