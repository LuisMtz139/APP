import 'package:app_cirugia_endoscopica/features/users/presentation/perfil/perfil_controller.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilPage extends StatelessWidget {
  final PerfilController controller = Get.find<PerfilController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedicalTheme.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    // Container(
                    //   width: 120,
                    //   height: 120,
                    //   decoration: BoxDecoration(
                    //     color: MedicalTheme.surfaceColor,
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: Center(
                    //     child: Image.asset(
                    //       'assets/AMCE.png',
                    //       width: 80,
                    //       height: 80,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 35),

                    Text(
                      '${controller.nombreController.text} ${controller.apellidoPaternoController.text} ${controller.apellidoMaternoController.text}',
                      style: MedicalTheme.headingMedium,
                    ),
                    // if (controller.especialidad1Controller.text.isNotEmpty)
                    //   Text(
                    //     controller.especialidad1Controller.text,
                    //     style: TextStyle(
                    //       color: MedicalTheme.successColor,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              _buildLabeledTextField('RFC', controller.rfcController, isRequired: true),
              _buildLabeledTextField('CURP', controller.curpController),
              _buildLabeledTextField('Nombre', controller.nombreController),
              _buildLabeledTextField('Apellido Paterno', controller.apellidoPaternoController),
              _buildLabeledTextField('Apellido Materno', controller.apellidoMaternoController),
              _buildLabeledTextField('Residente', controller.residenteController),
              _buildLabeledTextField('Género', controller.generoController),
              _buildLabeledTextField('Fecha de Nacimiento', controller.fechaNacimientoController),
              _buildLabeledTextField('Correo Electrónico', controller.correoElectronicoController),
              _buildLabeledTextField('Correo Electrónico Alterno', controller.correoElectronicoAlternoController),
              _buildLabeledTextField('Especialidad 1', controller.especialidad1Controller),
              _buildLabeledTextField('Especialidad 2', controller.especialidad2Controller),
              _buildLabeledTextField('Especialidad 3', controller.especialidad3Controller),
              _buildLabeledTextField('Celular', controller.celularController),
              _buildLabeledTextField('Teléfono Casa', controller.telefonoCasaController),
              _buildLabeledTextField('Calle', controller.calleController),
              _buildLabeledTextField('Número Exterior', controller.numeroExteriorController),
              _buildLabeledTextField('Número Interior', controller.numeroInteriorController),
              _buildLabeledTextField('Colonia', controller.coloniaController),
              _buildLabeledTextField('Código Postal', controller.codigoPostalController),
              _buildLabeledTextField('Municipio o Alcaldía', controller.municipioAlcaldiaController),
              _buildLabeledTextField('Estado', controller.estadoController),
              _buildLabeledTextField('País', controller.paisController),
              _buildLabeledTextField('Consultorio Calle', controller.consultorioCalleController),
              _buildLabeledTextField('Consultorio Número Exterior', controller.consultorioNumeroExteriorController),
              _buildLabeledTextField('Consultorio Número Interior', controller.consultorioNumeroInteriorController),
              _buildLabeledTextField('Consultorio Colonia', controller.consultorioColoniaController),
              _buildLabeledTextField('Consultorio Código Postal', controller.consultorioCodigoPostalController),
              _buildLabeledTextField('Consultorio Municipio o Alcaldía', controller.consultorioMunicipioAlcaldiaController),
              _buildLabeledTextField('Consultorio Estado', controller.consultorioEstadoController),
              _buildLabeledTextField('Consultorio País', controller.consultorioPaisController),
              _buildLabeledTextField('Consultorio Teléfono', controller.consultorioTelefonoController),
              _buildLabeledTextField('Nombre Asistente', controller.nombreAsistenteController),
              _buildLabeledTextField('Teléfono Asistente', controller.telefonoAsistenteController),
              _buildLabeledTextField('Hospital', controller.hospitalController),
              _buildLabeledTextField('Razón Social', controller.razonSocialController),
              _buildLabeledTextField('Régimen Fiscal', controller.regimenFiscalController),
              _buildLabeledTextField('Código Postal Fiscal', controller.codigoPostalFiscalController),
              _buildLabeledTextField('Estatus Membresía', controller.estatusController),
              _buildLabeledTextField('Membresía', controller.membresiaNombreController),
              _buildLabeledTextField('Expiración Membresía', controller.membresiaExpiracionController),

              SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
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
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
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
      ),
    );
  }
}
