import 'package:app_cirugia_endoscopica/features/events/domain/entities/events/events_entity.dart';

class EventsModel extends EventsEntity {
  EventsModel({
    required int id,
    required String titulo,
    required String tipoEvento,
    required String fechaInicio,
    required String fechaFin,
    required String ubicacion,
    required int puntosRecertificacion,
    required String creadoEl,
    required String actualizadoEl,
    required String precioInvitado,
    required String descripcion,
    required String bannerS3Llave,
    required String posterS3Llave,
    required bool publicado,
    required bool enInicio,
    required String enlaceExterno,
    String? fechaLimiteRegistro,
    int? limiteUsuarios,
    required String monedaPrecios,
    required List<int> membresiasConAcceso,
    required int usuariosPagados,
    required int usuariosInscritos,
    String? isInEvent,
    String? enfermeraO,
    String? estudiante,
    String? expresidente,
    String? noSocio,
    String? noSocioResidente,
    String? socioALACE,
    String? socioActivo,
    String? socioHonorario,
    String? socioResidente,
    String? socioTitular,
    String? tecnicoA,
    List<ActivityEntity> activities = const [],
  }) : super(
    id: id,
    titulo: titulo,
    tipoEvento: tipoEvento,
    fechaInicio: fechaInicio,
    fechaFin: fechaFin,
    ubicacion: ubicacion,
    puntosRecertificacion: puntosRecertificacion,
    creadoEl: creadoEl,
    actualizadoEl: actualizadoEl,
    precioInvitado: precioInvitado,
    descripcion: descripcion,
    bannerS3Llave: bannerS3Llave,
    posterS3Llave: posterS3Llave,
    publicado: publicado,
    enInicio: enInicio,
    enlaceExterno: enlaceExterno,
    fechaLimiteRegistro: fechaLimiteRegistro,
    limiteUsuarios: limiteUsuarios,
    monedaPrecios: monedaPrecios,
    membresiasConAcceso: membresiasConAcceso,
    usuariosPagados: usuariosPagados,
    usuariosInscritos: usuariosInscritos,
    enfermeraO: enfermeraO,
    estudiante: estudiante,
    expresidente: expresidente,
    noSocio: noSocio,
    noSocioResidente: noSocioResidente,
    socioALACE: socioALACE,
    socioActivo: socioActivo,
    socioHonorario: socioHonorario,
    socioResidente: socioResidente,
    socioTitular: socioTitular,
    tecnicoA: tecnicoA,
    isInEvent: isInEvent,
    activities: activities,
  );

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    // Parseo de actividades
    List<ActivityEntity> parseActivities(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((item) {
          if (item is Map<String, dynamic>) {
            return ActivityEntity(
              id: item['id'] ?? 0,
              eventoId: item['eventoId'] ?? 0,
              dia: item['dia'] ?? '',
              horaInicio: item['horaInicio'] ?? '',
              horaFin: item['horaFin'] ?? '',
              nombreActividad: item['nombreActividad'] ?? '',
              ponente: item['ponente'] ?? '',
              ubicacionActividad: item['ubicacionActividad'] ?? '',
              creadoEl: item['creadoEl'] ?? '',
              actualizadoEl: item['actualizadoEl'] ?? '',
            );
          }
          return ActivityEntity(
            id: 0,
            eventoId: 0,
            dia: '',
            horaInicio: '',
            horaFin: '',
            nombreActividad: '',
            ponente: '',
            ubicacionActividad: '',
            creadoEl: '',
            actualizadoEl: '',
          );
        }).toList();
      }
      return [];
    }

    // Resto del código existente...
    List<int> parseMembresiasConAcceso(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((item) {
          if (item is int) return item;
          if (item is String) return int.tryParse(item) ?? 0;
          return 0;
        }).toList().cast<int>();
      }
      return [];
    }

    // Manejo seguro de precios
    String parsePrice(dynamic value) {
      if (value == null) return '0.00';
      if (value is String) return value;
      if (value is num) return value.toString();
      return '0.00';
    }

    try {
      return EventsModel(
        id: json['id'] is int ? json['id'] : 0,
        titulo: json['titulo']?.toString() ?? '',
        tipoEvento: json['tipoEvento']?.toString() ?? '',
        fechaInicio: json['fechaInicio']?.toString() ?? '',
        fechaFin: json['fechaFin']?.toString() ?? '',
        ubicacion: json['ubicacion']?.toString() ?? '',
        puntosRecertificacion: json['puntosRecertificacion'] is int 
            ? json['puntosRecertificacion'] 
            : (json['puntosRecertificacion'] is String 
                ? int.tryParse(json['puntosRecertificacion']) ?? 0 
                : 0),
        creadoEl: json['creadoEl']?.toString() ?? '',
        actualizadoEl: json['actualizadoEl']?.toString() ?? '',
        precioInvitado: parsePrice(json['precioInvitado']),
        descripcion: json['descripcion']?.toString() ?? '',
        bannerS3Llave: json['bannerS3Llave']?.toString() ?? '',
        posterS3Llave: json['posterS3Llave']?.toString() ?? '',
        publicado: json['publicado'] is bool ? json['publicado'] : false,
        enInicio: json['enInicio'] is bool ? json['enInicio'] : false,
        enlaceExterno: json['enlaceExterno']?.toString() ?? '',
        fechaLimiteRegistro: json['fechaLimiteRegistro']?.toString(),
        limiteUsuarios: json['limiteUsuarios'] is int 
            ? json['limiteUsuarios'] 
            : (json['limiteUsuarios'] is String 
                ? int.tryParse(json['limiteUsuarios']) 
                : null),
        monedaPrecios: json['monedaPrecios']?.toString() ?? 'MXN',
        membresiasConAcceso: parseMembresiasConAcceso(json['membresiasConAcceso']),
        usuariosPagados: json['usuariosPagados'] is int 
            ? json['usuariosPagados'] 
            : (json['usuariosPagados'] is String 
                ? int.tryParse(json['usuariosPagados']) ?? 0 
                : 0),
        usuariosInscritos: json['usuariosInscritos'] is int 
            ? json['usuariosInscritos'] 
            : (json['usuariosInscritos'] is String 
                ? int.tryParse(json['usuariosInscritos']) ?? 0 
                : 0),
        enfermeraO: json['Enfermera/o']?.toString(),
        estudiante: json['Estudiante']?.toString(),
        expresidente: json['Expresidente']?.toString(),
        noSocio: json['No Socio']?.toString(),
        noSocioResidente: json['No Socio residente']?.toString(),
        socioALACE: json['Socio ALACE']?.toString(),
        socioActivo: json['Socio Activo']?.toString(),
        socioHonorario: json['Socio Honorario']?.toString(),
        socioResidente: json['Socio Residente']?.toString(),
        socioTitular: json['Socio Titular']?.toString(),
        tecnicoA: json['Técnico/a']?.toString(),
        isInEvent: json['isInEvent']?.toString(),
        activities: parseActivities(json['activities']), // Agregamos el parseo de actividades
      );
    } catch (e, stackTrace) {
      print('❌ Error en EventsModel.fromJson: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ JSON recibido: $json');
      
      // Retornamos un modelo con valores por defecto para evitar errores críticos
      return EventsModel(
        id: 0,
        titulo: 'Error en datos',
        tipoEvento: '',
        fechaInicio: '',
        fechaFin: '',
        ubicacion: '',
        puntosRecertificacion: 0,
        creadoEl: '',
        actualizadoEl: '',
        precioInvitado: '0.00',
        descripcion: 'Error al procesar datos del evento',
        bannerS3Llave: '',
        posterS3Llave: '',
        publicado: false,
        enInicio: false,
        isInEvent: '',
        enlaceExterno: '',
        monedaPrecios: 'MXN',
        membresiasConAcceso: [],
        usuariosPagados: 0,
        usuariosInscritos: 0,
        activities: [], // Inicializamos con lista vacía
      );
    }
  }

  factory EventsModel.fromEntity(EventsEntity entity) {
    return EventsModel(
      id: entity.id,
      titulo: entity.titulo,
      tipoEvento: entity.tipoEvento,
      fechaInicio: entity.fechaInicio,
      fechaFin: entity.fechaFin,
      ubicacion: entity.ubicacion,
      puntosRecertificacion: entity.puntosRecertificacion,
      creadoEl: entity.creadoEl,
      actualizadoEl: entity.actualizadoEl,
      precioInvitado: entity.precioInvitado,
      descripcion: entity.descripcion,
      bannerS3Llave: entity.bannerS3Llave,
      posterS3Llave: entity.posterS3Llave,
      publicado: entity.publicado,
      enInicio: entity.enInicio,
      enlaceExterno: entity.enlaceExterno,
      fechaLimiteRegistro: entity.fechaLimiteRegistro,
      limiteUsuarios: entity.limiteUsuarios,
      monedaPrecios: entity.monedaPrecios,
      membresiasConAcceso: entity.membresiasConAcceso,
      usuariosPagados: entity.usuariosPagados,
      usuariosInscritos: entity.usuariosInscritos,
      enfermeraO: entity.enfermeraO,
      estudiante: entity.estudiante,
      expresidente: entity.expresidente,
      noSocio: entity.noSocio,
      noSocioResidente: entity.noSocioResidente,
      socioALACE: entity.socioALACE,
      socioActivo: entity.socioActivo,
      socioHonorario: entity.socioHonorario,
      socioResidente: entity.socioResidente,
      socioTitular: entity.socioTitular,
      tecnicoA: entity.tecnicoA,
      isInEvent: entity.isInEvent,
      activities: entity.activities, // Incluimos las actividades
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'tipoEvento': tipoEvento,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
      'ubicacion': ubicacion,
      'puntosRecertificacion': puntosRecertificacion,
      'creadoEl': creadoEl,
      'actualizadoEl': actualizadoEl,
      'precioInvitado': precioInvitado,
      'descripcion': descripcion,
      'bannerS3Llave': bannerS3Llave,
      'posterS3Llave': posterS3Llave,
      'publicado': publicado,
      'enInicio': enInicio,
      'enlaceExterno': enlaceExterno,
      'fechaLimiteRegistro': fechaLimiteRegistro,
      'limiteUsuarios': limiteUsuarios,
      'monedaPrecios': monedaPrecios,
      'membresiasConAcceso': membresiasConAcceso,
      'usuariosPagados': usuariosPagados,
      'usuariosInscritos': usuariosInscritos,
      'Enfermera/o': enfermeraO,
      'Estudiante': estudiante,
      'Expresidente': expresidente,
      'No Socio': noSocio,
      'No Socio residente': noSocioResidente,
      'Socio ALACE': socioALACE,
      'Socio Activo': socioActivo,
      'Socio Honorario': socioHonorario,
      'Socio Residente': socioResidente,
      'Socio Titular': socioTitular,
      'Técnico/a': tecnicoA,
      'isInEvent': isInEvent,
      'activities': activities.map((activity) => {
        'id': activity.id,
        'eventoId': activity.eventoId,
        'dia': activity.dia,
        'horaInicio': activity.horaInicio,
        'horaFin': activity.horaFin,
        'nombreActividad': activity.nombreActividad,
        'ponente': activity.ponente,
        'ubicacionActividad': activity.ubicacionActividad,
        'creadoEl': activity.creadoEl,
        'actualizadoEl': activity.actualizadoEl,
      }).toList(), // Incluimos las actividades en el JSON
    };
  }
}