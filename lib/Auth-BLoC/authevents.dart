import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}
//auth token check in the state

class AuthenticationLoggedIn extends AuthenticationEvent {
  final String username;
  final String password;
  // actual auth starts here

  const AuthenticationLoggedIn({@required this.username,@required this.password});

  @override
  List<Object> get props => [username];

  @override
  String toString() => 'AuthenticationLoggedIn { token: $username }';
}

class AuthenticationLoggedOut extends AuthenticationEvent {}
