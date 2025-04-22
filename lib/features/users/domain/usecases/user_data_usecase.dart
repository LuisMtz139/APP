

import 'package:app_cirugia_endoscopica/features/users/domain/entities/user_data_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/repositories/user_repository.dart';

class UserDataUsecase {
  final UserRepository userRepository;

  UserDataUsecase({required this.userRepository});

 Future<List<UserDataEntity>> execute() async {
  
    return await userRepository.userData();
  }
}