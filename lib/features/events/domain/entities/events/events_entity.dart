class EventsEntity {
  final int id;
  final String titulo;
  final String tipoEvento;
  final String fechaInicio;
  final String fechaFin;
  final String ubicacion;
  final int puntosRecertificacion;
  final String creadoEl;
  final String actualizadoEl;
  final String precioInvitado;
  final String descripcion;
  final String bannerS3Llave;
  final String posterS3Llave;
  final bool publicado;
  final bool enInicio;
  final String enlaceExterno;
  final String? fechaLimiteRegistro;
  final int? limiteUsuarios;
  final String monedaPrecios;
  final List<int> membresiasConAcceso;
  final int usuariosPagados;
  final int usuariosInscritos;
  
  final String? enfermeraO;
  final String? estudiante;
  final String? expresidente;
  final String? noSocio;
  final String? noSocioResidente;
  final String? socioALACE;
  final String? socioActivo;
  final String? socioHonorario;
  final String? socioResidente;
  final String? socioTitular;
  final String? tecnicoA;

  EventsEntity({
    required this.id,
    required this.titulo,
    required this.tipoEvento,
    required this.fechaInicio,
    required this.fechaFin,
    required this.ubicacion,
    required this.puntosRecertificacion,
    required this.creadoEl,
    required this.actualizadoEl,
    required this.precioInvitado,
    required this.descripcion,
    required this.bannerS3Llave,
    required this.posterS3Llave,
    required this.publicado,
    required this.enInicio,
    required this.enlaceExterno,
    this.fechaLimiteRegistro,
    this.limiteUsuarios,
    required this.monedaPrecios,
    required this.membresiasConAcceso,
    required this.usuariosPagados,
    required this.usuariosInscritos,
    this.enfermeraO,
    this.estudiante,
    this.expresidente,
    this.noSocio,
    this.noSocioResidente,
    this.socioALACE,
    this.socioActivo,
    this.socioHonorario,
    this.socioResidente,
    this.socioTitular,
    this.tecnicoA,
  });

  
}