import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String userID;
  AuthenticationSuccess({@required this.userID});
}

class InitialAuthFailure extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String error;
  AuthenticationFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class LoggedOut extends AuthenticationState{}

class DenialOfService extends AuthenticationState{}
