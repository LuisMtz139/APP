
import 'package:app_cirugia_endoscopica/common/services/auth_service.dart';
import 'package:app_cirugia_endoscopica/features/users/data/datasources/user_data_sources.dart';
import 'package:app_cirugia_endoscopica/features/users/data/models/login_response.dart';
import 'package:app_cirugia_endoscopica/features/users/data/models/userdata/user_data_model.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/user_data_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/entities/userdebts/user_debts_entity.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSourcesImp userDataSources;

  UserRepositoryImpl({required this.userDataSources});

    final AuthService authService = AuthService();

  
  @override
   Future<LoginResponse> signin(String username, String password ) async {
    return await userDataSources.signin(username, password, );
  }

  @override
  Future<List<UserDataEntity>> userData() async {
    final token = await authService.getToken();
    
    if (token == null) {
      throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
    }

    return await userDataSources.userData(token);
  }

  @override
  Future<List<UserDebtsEntity>> userdebts() async {
     final token = await authService.getToken();
    
    if (token == null) {
      throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
    }

    return await userDataSources.userdebts(token);
  }
  
 
  
}
