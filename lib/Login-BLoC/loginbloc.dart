import 'package:todos/Auth-BLoC/authbloc.dart';
import 'package:todos/Auth-BLoC/authevents.dart';
import 'package:todos/Auth-BLoC/user-repo.dart';
import 'package:meta/meta.dart';
import 'package:todos/Login-BLoC/loginevents.dart';
import 'package:todos/Login-BLoC/loginstates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc
  });

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event)async*{
    if(event is LoginButtonPressed){
      final String user = event.username;
      final String passwordCheck = event.password;

      yield LoginInitial();
      authenticationBloc.add(AuthenticationLoggedIn(username: user,password: passwordCheck));
    }
  }

}