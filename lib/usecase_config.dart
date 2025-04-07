
import 'package:app_cirugia_endoscopica/features/users/data/datasources/user_data_sources.dart';
import 'package:app_cirugia_endoscopica/features/users/data/repositories/user_repository_imp.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/user_data_usecase.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/login_usecase.dart';

class UsecaseConfig {
  UserDataSourcesImp? userDataSourcesImp;
  UserRepositoryImpl? userRepositoryImpl;
  LoginUsecase? loginUsecase;
  
  UserDataUsecase? userDataUsecase;
 

    UsecaseConfig(){
    userDataSourcesImp = UserDataSourcesImp();
    userRepositoryImpl = UserRepositoryImpl(userDataSources: userDataSourcesImp!);
    loginUsecase = LoginUsecase(userRepository: userRepositoryImpl!);
    
    userDataUsecase = UserDataUsecase(userRepository:  userRepositoryImpl!);
   
    }
}