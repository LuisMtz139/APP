
import 'package:app_cirugia_endoscopica/features/users%20copy/data/models/login_response.dart';

abstract class UserRepository {
  
  Future<LoginResponse> loginUser(String username, String password, [String? base_datos]);
}
