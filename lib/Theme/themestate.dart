import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable{
  @override
  List<Object> get props => [];
}

class CurrentThemeState extends ThemeState{
  final bool activeTheme;
  //active theme value determines dark and light themes
  //true fot light theme
  //false for black theme
  CurrentThemeState({@required this.activeTheme});

  @override
  List<Object> get props => [activeTheme];
}







