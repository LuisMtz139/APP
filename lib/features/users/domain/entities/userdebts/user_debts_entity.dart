class UserDebtsEntity {
  final String id;
  final int idUsuario;
  final String tipoAdeudo;
  final int? fechaMembresia;
  final String? nombreMembresia; 
  final int? membresiaId;
  final int? eventoId;  
  final String monto;
  final String moneda;
  final String cantidadPagada;
  final String descripcion;
  final String estatus;
  final String creadoEl;
  final String actualizadoEl;
  final String rfcUsuario;
  final String? tituloEvento;

  UserDebtsEntity({
    required this.id,
    required this.idUsuario,
    required this.tipoAdeudo,
    this.fechaMembresia,
    this.nombreMembresia,  
    this.membresiaId,
    this.eventoId,
    required this.monto,
    required this.moneda,
    required this.cantidadPagada,
    required this.descripcion,
    required this.estatus,
    required this.creadoEl,
    required this.actualizadoEl,
    required this.rfcUsuario,
    this.tituloEvento,
  });
}