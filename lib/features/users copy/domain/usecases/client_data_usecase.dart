

import 'package:app_cirugia_endoscopica/features/users%20copy/data/models/login_response.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/domain/repositories/user_repository.dart';

class ClientDataUsecase {
  final UserRepository userRepository;

  ClientDataUsecase({required this.userRepository});

 Future<LoginResponse> execute() async {
  final String username = 'defaultUsername'; // Replace with actual default or input value
  final String password = 'defaultPassword'; // Replace with actual default or input value
  final String? base_datos = 'defaultDatabase'; // Replace with actual default or input value
    return await userRepository.loginUser(username, password, );
  }
}