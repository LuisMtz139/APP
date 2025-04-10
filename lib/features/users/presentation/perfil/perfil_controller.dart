import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/user_data_usecase.dart';

class PerfilController extends GetxController {
  final UserDataUsecase userDataUsecase;

  PerfilController({required this.userDataUsecase});

  final rfcController = TextEditingController();
  final curpController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoPaternoController = TextEditingController();
  final apellidoMaternoController = TextEditingController();
  final residenteController = TextEditingController();
  final generoController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final correoElectronicoController = TextEditingController();
  final correoElectronicoAlternoController = TextEditingController();
  final especialidad1Controller = TextEditingController();
  final especialidad2Controller = TextEditingController();
  final especialidad3Controller = TextEditingController();
  final celularController = TextEditingController();
  final telefonoCasaController = TextEditingController();
  final calleController = TextEditingController();
  final numeroExteriorController = TextEditingController();
  final numeroInteriorController = TextEditingController();
  final coloniaController = TextEditingController();
  final codigoPostalController = TextEditingController();
  final municipioAlcaldiaController = TextEditingController();
  final estadoController = TextEditingController();
  final paisController = TextEditingController();
  final consultorioCalleController = TextEditingController();
  final consultorioNumeroExteriorController = TextEditingController();
  final consultorioNumeroInteriorController = TextEditingController();
  final consultorioColoniaController = TextEditingController();
  final consultorioCodigoPostalController = TextEditingController();
  final consultorioMunicipioAlcaldiaController = TextEditingController();
  final consultorioEstadoController = TextEditingController();
  final consultorioPaisController = TextEditingController();
  final consultorioTelefonoController = TextEditingController();
  final nombreAsistenteController = TextEditingController();
  final telefonoAsistenteController = TextEditingController();
  final hospitalController = TextEditingController();
  final razonSocialController = TextEditingController();
  final regimenFiscalController = TextEditingController();
  final codigoPostalFiscalController = TextEditingController();
  final estatusController = TextEditingController();
  final membresiaNombreController = TextEditingController();
  final membresiaExpiracionController = TextEditingController();

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      final users = await userDataUsecase.execute();
      if (users.isNotEmpty) {
        final user = users.first;

        rfcController.text = user.rfc;
        curpController.text = user.curp ?? '';
        nombreController.text = user.nombre;
        apellidoPaternoController.text = user.apellidoPaterno;
        apellidoMaternoController.text = user.apellidoMaterno;
        residenteController.text = user.residente;
        generoController.text = user.genero;
        fechaNacimientoController.text = user.fechaNacimiento ?? '';
        correoElectronicoController.text = user.correoElectronico;
        correoElectronicoAlternoController.text = user.correoElectronicoAlterno;
        especialidad1Controller.text = user.especialidad1;
        especialidad2Controller.text = user.especialidad2;
        especialidad3Controller.text = user.especialidad3;
        celularController.text = user.celular;
        telefonoCasaController.text = user.telefonoCasa;
        calleController.text = user.calle;
        numeroExteriorController.text = user.numeroExterior;
        numeroInteriorController.text = user.numeroInterior;
        coloniaController.text = user.colonia;
        codigoPostalController.text = user.codigoPostal;
        municipioAlcaldiaController.text = user.municipioAlcaldia;
        estadoController.text = user.estado;
        paisController.text = user.pais;
        consultorioCalleController.text = user.consultorioCalle;
        consultorioNumeroExteriorController.text = user.consultorioNumeroExterior;
        consultorioNumeroInteriorController.text = user.consultorioNumeroInterior;
        consultorioColoniaController.text = user.consultorioColonia;
        consultorioCodigoPostalController.text = user.consultorioCodigoPostal;
        consultorioMunicipioAlcaldiaController.text = user.consultorioMunicipioAlcaldia;
        consultorioEstadoController.text = user.consultorioEstado;
        consultorioPaisController.text = user.consultorioPais;
        consultorioTelefonoController.text = user.consultorioTelefono;
        nombreAsistenteController.text = user.nombreAsistente;
        telefonoAsistenteController.text = user.telefonoAsistente;
        hospitalController.text = user.hospital;
        razonSocialController.text = user.razonSocial;
        regimenFiscalController.text = user.regimenFiscal;
        codigoPostalFiscalController.text = user.codigoPostalFiscal;
        estatusController.text = user.estatus;
        membresiaNombreController.text = user.nombreMembresia;
        membresiaExpiracionController.text = user.membresiaExpiracion ?? '';
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('❌ Error cargando datos de usuario: $e');
      Get.snackbar(
        'Error',
        'No se pudieron cargar los datos del usuario',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    rfcController.dispose();
    curpController.dispose();
    nombreController.dispose();
    apellidoPaternoController.dispose();
    apellidoMaternoController.dispose();
    residenteController.dispose();
    generoController.dispose();
    fechaNacimientoController.dispose();
    correoElectronicoController.dispose();
    correoElectronicoAlternoController.dispose();
    especialidad1Controller.dispose();
    especialidad2Controller.dispose();
    especialidad3Controller.dispose();
    celularController.dispose();
    telefonoCasaController.dispose();
    calleController.dispose();
    numeroExteriorController.dispose();
    numeroInteriorController.dispose();
    coloniaController.dispose();
    codigoPostalController.dispose();
    municipioAlcaldiaController.dispose();
    estadoController.dispose();
    paisController.dispose();
    consultorioCalleController.dispose();
    consultorioNumeroExteriorController.dispose();
    consultorioNumeroInteriorController.dispose();
    consultorioColoniaController.dispose();
    consultorioCodigoPostalController.dispose();
    consultorioMunicipioAlcaldiaController.dispose();
    consultorioEstadoController.dispose();
    consultorioPaisController.dispose();
    consultorioTelefonoController.dispose();
    nombreAsistenteController.dispose();
    telefonoAsistenteController.dispose();
    hospitalController.dispose();
    razonSocialController.dispose();
    regimenFiscalController.dispose();
    codigoPostalFiscalController.dispose();
    estatusController.dispose();
    membresiaNombreController.dispose();
    membresiaExpiracionController.dispose();
    super.onClose();
  }
}
