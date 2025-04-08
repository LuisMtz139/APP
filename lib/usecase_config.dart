
import 'package:app_cirugia_endoscopica/features/events/data/datasources/event_data_sources.dart';
import 'package:app_cirugia_endoscopica/features/events/data/repositories/event_repository_imp.dart';
import 'package:app_cirugia_endoscopica/features/events/domain/usecases/events_usecase.dart';
import 'package:app_cirugia_endoscopica/features/users/data/datasources/user_data_sources.dart';
import 'package:app_cirugia_endoscopica/features/users/data/repositories/user_repository_imp.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/user_data_usecase.dart';
import 'package:app_cirugia_endoscopica/features/users/domain/usecases/login_usecase.dart';

class UsecaseConfig {
  UserDataSourcesImp? userDataSourcesImp;
  UserRepositoryImpl? userRepositoryImpl;
  LoginUsecase? loginUsecase;
  
  UserDataUsecase? userDataUsecase;
  EventDataSourcesImp? eventDataSourcesImp;
  EventRepositoryImp? eventRepositoryImpl;
  EventsUsecase? eventsUsecase;

  UsecaseConfig(){
    userDataSourcesImp = UserDataSourcesImp();
    userRepositoryImpl = UserRepositoryImpl(userDataSources: userDataSourcesImp!);
    loginUsecase = LoginUsecase(userRepository: userRepositoryImpl!);

    eventDataSourcesImp = EventDataSourcesImp();
    eventRepositoryImpl = EventRepositoryImp(userDataSources: eventDataSourcesImp!);
    eventsUsecase = EventsUsecase(eventRepository: eventRepositoryImpl!);
    
    userDataUsecase = UserDataUsecase(userRepository:  userRepositoryImpl!);
   
    }
}