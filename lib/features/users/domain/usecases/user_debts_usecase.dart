import 'package:app_cirugia_endoscopica/features/users/domain/entities/userdebts/user_debts_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/repositories/user_repository.dart';

class UserDebtsUsecase {
  final UserRepository userRepository;
  UserDebtsUsecase({required this.userRepository});
  Future<List<UserDebtsEntity>> execute() async {
    return await userRepository.userdebts();
  }
}