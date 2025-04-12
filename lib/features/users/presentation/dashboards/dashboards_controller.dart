import 'package:app_cirugia_endoscopica/features/users/domain/entities/user_data_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/user_data_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_cirugia_endoscopica/common/theme/App_Theme.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/userdebts/user_debts_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/user_debts_usecase.dart';

class DashboardsController extends GetxController {
    final UserDebtsUsecase _userDebtsUsecase;
  final UserDataUsecase _userDataUsecase; // Agregamos el caso de uso
  
  // Variables observables existentes
  final RxList<UserDebtsEntity> userDebts = <UserDebtsEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  
  // Agregamos variables para datos del usuario
  final Rx<UserDataEntity?> userData = Rx<UserDataEntity?>(null);
  final RxString userName = 'Cargando...'.obs;

  // Variables para datos de tarjetas de estatus (existentes)
  final RxString membresiaNombre = 'Cargando...'.obs;
  final RxString membresiaEstatus = 'Cargando...'.obs;
  final RxString totalAdeudos = '0'.obs;
  final RxDouble montoTotalPendiente = 0.0.obs;

  DashboardsController({
    required UserDebtsUsecase userDebtsUsecase,
    required UserDataUsecase userDataUsecase,
  }) : 
    _userDebtsUsecase = userDebtsUsecase,
    _userDataUsecase = userDataUsecase;

  @override
  void onInit() {
    super.onInit();
        fetchUserData(); 
    fetchUserDebts();
  }
Future<void> fetchUserData() async {
    try {
      // Obtenemos datos del usuario
      final userDataList = await _userDataUsecase.execute();
      
      if (userDataList.isNotEmpty) {
        userData.value = userDataList.first;
        // Formateamos el nombre completo (con título "Dr." si es necesario)
        userName.value = "Dr. ${userData.value!.nombre} ${userData.value!.apellidoPaterno}";
      } else {
        userName.value = "Usuario";
      }
    } catch (e) {
      print('Error en fetchUserData: ${e.toString()}');
      userName.value = "Usuario";
    }
  }
  Future<void> fetchUserDebts() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Obtener datos de adeudos
      final debts = await _userDebtsUsecase.execute();
      userDebts.value = debts;
      
      // Procesar datos para mostrar en tarjetas
      _processDebtsData();
      
    } catch (e) {
      error.value = 'Error al cargar datos: ${e.toString()}';
      print('Error en fetchUserDebts: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _processDebtsData() {
    // Si no hay adeudos, establecer valores predeterminados
    if (userDebts.isEmpty) {
      membresiaNombre.value = 'No disponible';
      membresiaEstatus.value = 'No disponible';
      totalAdeudos.value = '0';
      montoTotalPendiente.value = 0.0;
      return;
    }

    // Filtrar adeudos por tipo membresía
    final membresiaDebt = userDebts.firstWhereOrNull(
      (debt) => debt.tipoAdeudo.toLowerCase() == 'membresia'
    );

    // Establecer datos de membresía
    if (membresiaDebt != null) {
      membresiaNombre.value = membresiaDebt.nombreMembresia ?? 'No especificada';
      membresiaEstatus.value = _formatEstatus(membresiaDebt.estatus);
    }

    // Calcular total de adeudos pendientes
    final pendingDebts = userDebts.where(
      (debt) => debt.estatus.toLowerCase() == 'pendiente'
    ).toList();
    
    totalAdeudos.value = pendingDebts.length.toString();
    
    // Calcular monto total pendiente
    montoTotalPendiente.value = pendingDebts.fold(0.0, (prev, debt) {
      return prev + (double.tryParse(debt.monto) ?? 0.0) - (double.tryParse(debt.cantidadPagada) ?? 0.0);
    });
  }

  String _formatEstatus(String estatus) {
    switch (estatus.toLowerCase()) {
      case 'pendiente':
        return 'Pendiente';
      case 'pagado':
        return 'Activa';
      case 'vencido':
        return 'Vencida';
      default:
        return estatus;
    }
  }

  // Método para construir las tarjetas de estado
  List<Widget> buildStatusCards() {
    return [
      _buildEnhancedStatusCard(
        "Estatus Membresía", 
        membresiaEstatus.value, 
        Icons.card_membership_rounded,
        _getColorByEstatus(membresiaEstatus.value),
      ),
      const SizedBox(width: 16),
      _buildEnhancedStatusCard(
        "Tipo Membresía", 
        membresiaNombre.value, 
        Icons.verified_rounded,
        MedicalTheme.primaryColor,
      ),
      const SizedBox(width: 16),
      _buildEnhancedStatusCard(
        "Adeudos Pendientes", 
        //${totalAdeudos.value} (
        "${montoTotalPendiente.value.toStringAsFixed(2)}", 
        Icons.account_balance_wallet,
        _getColorByAdeudos(totalAdeudos.value),
      ),
    ];
  }

  Widget _buildEnhancedStatusCard(String title, String status, IconData icon, Color iconColor) {
    return Container(
      width: 170,
      height: 130,
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
        mainAxisSize: MainAxisSize.min,
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
              fontSize: 16,
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

  Color _getColorByEstatus(String estatus) {
    switch (estatus.toLowerCase()) {
      case 'activa':
        return MedicalTheme.successColor;
      case 'pendiente':
        return Colors.orange;
      case 'vencida':
        return Colors.red;
      default:
        return MedicalTheme.primaryColor;
    }
  }

  Color _getColorByAdeudos(String totalAdeudos) {
    final total = int.tryParse(totalAdeudos) ?? 0;
    
    if (total == 0) {
      return MedicalTheme.successColor;
    } else if (total < 3) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}