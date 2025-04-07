
import 'package:app_cirugia_endoscopica/features/users%20copy/data/datasources/user_local_data_sources.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/data/models/login_response.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSources userLocalDataSources;

  UserRepositoryImpl({required this.userLocalDataSources});


  
  @override
   Future<LoginResponse> loginUser(String username, String password, [String? base_datos]) async {
    return await userLocalDataSources.loginUser(username, password, base_datos);
  }
  
}
