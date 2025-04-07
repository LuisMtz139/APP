
import 'package:app_cirugia_endoscopica/features/users%20copy/data/datasources/user_data_sources.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/data/models/login_response.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSourcesImp userLocalDataSources;

  UserRepositoryImpl({required this.userLocalDataSources});


  
  @override
   Future<LoginResponse> loginUser(String username, String password ) async {
    return await userLocalDataSources.signin(username, password, );
  }
  
}
