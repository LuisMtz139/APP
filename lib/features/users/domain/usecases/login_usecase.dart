

import 'package:app_cirugia_endoscopica/features/users/data/models/login_response.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/repositories/user_repository.dart';

class LoginUsecase {
  final UserRepository userRepository;

  LoginUsecase({required this.userRepository});

  Future<LoginResponse> execute(String username, String password) async {
    return await userRepository.signin(username, password, );
  }
}