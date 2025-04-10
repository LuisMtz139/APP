
import 'package:app_cirugia_endoscopica/features/users/data/models/login_response.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/user_data_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/userdebts/user_debts_entity.dart';

abstract class UserRepository {
  
  Future<LoginResponse> signin(String username, String password);
  Future<List<UserDataEntity>> userData();
  Future<List<UserDebtsEntity>> userdebts();
}
