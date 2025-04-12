
import 'package:app_cirugia_endoscopica/features/users/domain/entities/userdebts/user_debts_entity.dart';

class UserDebtsModel extends UserDebtsEntity {
  UserDebtsModel({
    required String id,
    required int idUsuario,
    required String tipoAdeudo,
    int? fechaMembresia,
    required String nombreMembresia,
    int? membresiaId,
    String? eventoId,
    required String monto,
    required String moneda,
    required String cantidadPagada,
    required String descripcion,
    required String estatus,
    required String creadoEl,
    required String actualizadoEl,
    required String rfcUsuario,
    String? tituloEvento,
  }) : super(
          id: id,
          idUsuario: idUsuario,
          tipoAdeudo: tipoAdeudo,
          fechaMembresia: fechaMembresia,
          nombreMembresia: nombreMembresia,
          membresiaId: membresiaId,
          eventoId: eventoId,
          monto: monto,
          moneda: moneda,
          cantidadPagada: cantidadPagada,
          descripcion: descripcion,
          estatus: estatus,
          creadoEl: creadoEl,
          actualizadoEl: actualizadoEl,
          rfcUsuario: rfcUsuario,
          tituloEvento: tituloEvento,
        );

  factory UserDebtsModel.fromJson(Map<String, dynamic> json) {
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
      estatus: json['estatus'] ?? 'pendiente',
      creadoEl: json['creadoEl'] ?? '',
      actualizadoEl: json['actualizadoEl'] ?? '',
      rfcUsuario: json['rfcUsuario'] ?? '',
      tituloEvento: json['tituloEvento'],
    );
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

  @override
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