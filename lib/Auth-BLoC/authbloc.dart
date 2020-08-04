import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/Auth-BLoC/user-repo.dart';
import 'package:todos/UserDatabase/userdatabase.dart';
import 'authevents.dart';
import 'authstates.dart';


class AuthenticationBloc extends Bloc<AuthenticationEvent,AuthenticationState>{
  final UserRepository userRepo;

  AuthenticationBloc( {@required this.userRepo}):assert(userRepo!=null);

  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event)async* {
    if(event is AuthenticationStarted){
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if(androidInfo.androidId=='2658c69c40768591'){
        //2658c69c40768591
        yield AuthenticationInitial();
        final String hasToken= await userRepo.checkToken();
        if(hasToken!=null){
          yield AuthenticationSuccess(userID:hasToken);
        }
        else{
          yield InitialAuthFailure();
        }
      }
      else{
        yield DenialOfService();
      }
    }
    if(event is AuthenticationLoggedIn){
      yield AuthenticationInProgress();
      Map result=await userRepo.authenticate(username:event.username,password:event.password);
      if(result['userID']!=null){
        print('Authentication Success');
        yield AuthenticationSuccess(userID:result['userID']);
        UserDatabase(userID: result['userID']);
      }
      else if(result['userID']==null){
        yield AuthenticationFailure(error:result['errorMessage']);
      }
    }
    if (event is AuthenticationLoggedOut){
      await userRepo.deleteToken();
      yield LoggedOut();
    }
  }
}

