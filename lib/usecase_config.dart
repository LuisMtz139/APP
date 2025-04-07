
import 'package:app_cirugia_endoscopica/features/users%20copy/data/datasources/user_local_data_sources.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/data/repositories/user_repository_imp.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/domain/usecases/client_data_usecase.dart';
import 'package:app_cirugia_endoscopica/features/users%20copy/domain/usecases/login_usecase.dart';

class UsecaseConfig {
  UserLocalDataSourcesImp? userLocalDataSourcesImp;
  UserRepositoryImpl? userRepositoryImpl;
  LoginUsecase? loginUsecase;
  
  ClientDataUsecase? clientedataUsecase;
 

    UsecaseConfig(){
    userLocalDataSourcesImp = UserLocalDataSourcesImp();
    userRepositoryImpl = UserRepositoryImpl(userLocalDataSources: userLocalDataSourcesImp!);
    loginUsecase = LoginUsecase(userRepository: userRepositoryImpl!);
    
    clientedataUsecase = ClientDataUsecase(userRepository:  userRepositoryImpl!);
   
    }
}