

class UserDataEntity {
  final int id;
  final String rfc;
  final String? curp;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String residente;
  final String genero;
  final String? fechaNacimiento;
  final String correoElectronico;
  final String? imagen;
  final String correoElectronicoAlterno;
  final String especialidad1;
  final String especialidad2;
  final String especialidad3;
  final String celular;
  final String telefonoCasa;
  
  // Dirección personal
  final String calle;
  final String numeroExterior;
  final String numeroInterior;
  final String colonia;
  final String codigoPostal;
  final String municipioAlcaldia;
  final String estado;
  final String pais;
  
  // Información de consultorio
  final String consultorioCalle;
  final String consultorioNumeroExterior;
  final String consultorioNumeroInterior;
  final String consultorioColonia;
  final String consultorioCodigoPostal;
  final String consultorioMunicipioAlcaldia;
  final String consultorioEstado;
  final String consultorioPais;
  final String consultorioTelefono;
  
  // Información adicional
  final String nombreAsistente;
  final String telefonoAsistente;
  final String hospital;
  
  // Información fiscal
  final String razonSocial;
  final String regimenFiscal;
  final String codigoPostalFiscal;
  final String correoFiscal;
  
  // Información de membresía
  final int membresiaId;
  final String nombreMembresia;
  final String estatus;
  final String? membresiaExpiracion;
  
  // Información de registro
  final String creadoEl;
  final String fullName;
  
  UserDataEntity({
    required this.id,
    required this.rfc,
    this.curp,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.residente,
    required this.genero,
    this.fechaNacimiento,
    required this.correoElectronico,
    this.imagen,
    required this.correoElectronicoAlterno,
    required this.especialidad1,
    required this.especialidad2,
    required this.especialidad3,
    required this.celular,
    required this.telefonoCasa,
    required this.calle,
    required this.numeroExterior,
    required this.numeroInterior,
    required this.colonia,
    required this.codigoPostal,
    required this.municipioAlcaldia,
    required this.estado,
    required this.pais,
    required this.consultorioCalle,
    required this.consultorioNumeroExterior,
    required this.consultorioNumeroInterior,
    required this.consultorioColonia,
    required this.consultorioCodigoPostal,
    required this.consultorioMunicipioAlcaldia,
    required this.consultorioEstado,
    required this.consultorioPais,
    required this.consultorioTelefono,
    required this.nombreAsistente,
    required this.telefonoAsistente,
    required this.hospital,
    required this.razonSocial,
    required this.regimenFiscal,
    required this.codigoPostalFiscal,
    required this.correoFiscal,
    required this.membresiaId,
    required this.nombreMembresia,
    required this.estatus,
    this.membresiaExpiracion,
    required this.creadoEl,
    required this.fullName,
  });
}