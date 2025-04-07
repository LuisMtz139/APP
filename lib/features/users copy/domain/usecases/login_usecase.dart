

import 'package:app_cirugia_endoscopica/features/users%20copy/data/models/login_response.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/domain/repositories/user_repository.dart';

class LoginUsecase {
  final UserRepository userRepository;

  LoginUsecase({required this.userRepository});

  Future<LoginResponse> execute(String username, String password, [String? base_datos]) async {
    return await userRepository.loginUser(username, password, );
  }
}