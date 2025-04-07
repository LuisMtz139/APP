class LoginResponse {
  final bool success;
  final String token;
  final UserData user;

  LoginResponse({
    required this.success,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
      user: UserData.fromJson(json['user'] ?? {}),
    );
  }
}

class UserData {
  final int id;
  final String rfc;
  final String nombre;
  final String correoElectronico;
  final int membresia;
  final String membresiaNombre;
  final String estatus;

  UserData({
    required this.id,
    required this.rfc,
    required this.nombre,
    required this.correoElectronico,
    required this.membresia,
    required this.membresiaNombre,
    required this.estatus,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      rfc: json['rfc'] ?? '',
      nombre: json['nombre'] ?? '',
      correoElectronico: json['correoElectronico'] ?? '',
      membresia: json['membresia'] ?? 0,
      membresiaNombre: json['membresiaNombre'] ?? '',
      estatus: json['estatus'] ?? '',
    );
  }
}