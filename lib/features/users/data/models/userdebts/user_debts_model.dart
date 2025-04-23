import 'package:app_cirugia_endoscopica/features/users/domain/entities/userdebts/user_debts_entity.dart';

class UserDebtsModel extends UserDebtsEntity {
  UserDebtsModel({
    required super.id,
    required super.idUsuario,
    required super.tipoAdeudo,
    super.fechaMembresia,
    super.nombreMembresia,  // Ahora es nullable
    super.membresiaId,
    super.eventoId,
    required super.monto,
    required super.moneda,
    required super.cantidadPagada,
    required super.descripcion,
    required super.estatus,
    required super.creadoEl,
    required super.actualizadoEl,
    required super.rfcUsuario,
    super.tituloEvento,
  });

  factory UserDebtsModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserDebtsModel(
        id: json['id'] ?? '',
        idUsuario: json['idUsuario'] ?? 0,
        tipoAdeudo: json['tipoAdeudo'] ?? '',
        fechaMembresia: json['fechaMembresia'],
        nombreMembresia: json['nombreMembresia'], 
        membresiaId: json['membresiaId'],
        eventoId: json['eventoId'],
        monto: json['monto'] ?? '0.00',
        moneda: json['moneda'] ?? 'MXN',
        cantidadPagada: json['cantidadPagada'] ?? '0',
        descripcion: json['descripcion'] ?? '',
        estatus: json['estatus'] ?? '',
        creadoEl: json['creadoEl'] ?? '',
        actualizadoEl: json['actualizadoEl'] ?? '',
        rfcUsuario: json['rfcUsuario'] ?? '',
        tituloEvento: json['tituloEvento'],
      );
    } catch (e) {
      print('❌ Error procesando item: $e');
      print('JSON que causó el error: $json');
      rethrow;
    }
  }

  factory UserDebtsModel.fromEntity(UserDebtsEntity entity) {
    return UserDebtsModel(
      id: entity.id,
      idUsuario: entity.idUsuario,
      tipoAdeudo: entity.tipoAdeudo,
      fechaMembresia: entity.fechaMembresia,
      nombreMembresia: entity.nombreMembresia,
      membresiaId: entity.membresiaId,
      eventoId: entity.eventoId,
      monto: entity.monto,
      moneda: entity.moneda,
      cantidadPagada: entity.cantidadPagada,
      descripcion: entity.descripcion,
      estatus: entity.estatus,
      creadoEl: entity.creadoEl,
      actualizadoEl: entity.actualizadoEl,
      rfcUsuario: entity.rfcUsuario,
      tituloEvento: entity.tituloEvento,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'tipoAdeudo': tipoAdeudo,
      'fechaMembresia': fechaMembresia,
      'nombreMembresia': nombreMembresia,
      'membresiaId': membresiaId,
      'eventoId': eventoId,
      'monto': monto,
      'moneda': moneda,
      'cantidadPagada': cantidadPagada,
      'descripcion': descripcion,
      'estatus': estatus,
      'creadoEl': creadoEl,
      'actualizadoEl': actualizadoEl,
      'rfcUsuario': rfcUsuario,
      'tituloEvento': tituloEvento,
    };
  }
}