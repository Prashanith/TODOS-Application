import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/Login-BLoC/loginbloc.dart';
import 'package:todos/Screens/Home/home.dart';
import 'file:///C:/Users/prash/Projects/Flutter%20Apps/todos/lib/Screens/SplashScreen.dart';
import 'package:todos/Theme/themebloc.dart';
import 'package:todos/Theme/themeevent.dart';

import 'Auth-BLoC/authbloc.dart';
import 'Auth-BLoC/authevents.dart';
import 'Auth-BLoC/authstates.dart';
import 'Auth-BLoC/user-repo.dart';
import 'Screens/Authenticate/Login.dart';
import 'UserDatabase/ip-denial.dart';

//SimpleBlocDelegate prints the changes in streams

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) {
              return AuthenticationBloc(userRepo: userRepository)
                ..add(AuthenticationStarted());
            },
          ),
          //provides authentication
          BlocProvider<ThemeBloc>(
            create: (BuildContext context) =>ThemeBloc()..add(SetLightTheme()),
          ),
          //provides theme
          BlocProvider(
            create: (context) {
              return LoginBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                userRepository: userRepository,
              );
            },
            child: LoginPage(userRepository: userRepository),
          ),
          //provides LoginPage
        ],
        child: MyApp(userRepository: userRepository),
      )
  );
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state){
          if (state is AuthenticationInitial) {
            return SplashScreen();
          }
          if(state is DenialOfService){
            return DenyUsage();
          }
          if (state is AuthenticationSuccess) {
            return Home(uid:state.userID);
          }
          if(state is AuthenticationInProgress){
            return LoginPage(userRepository: userRepository);
          }
          if ((state is AuthenticationFailure)|(state is InitialAuthFailure)) {
            return LoginPage(userRepository:userRepository);
          }
          else{
            return LoginPage(userRepository: null);
          }
        },
      ),
    );
  }
}

