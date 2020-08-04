import 'package:flutter_bloc/flutter_bloc.dart';
import 'themeevent.dart';
import 'themestate.dart';

class ThemeBloc extends Bloc<ThemeEvent,ThemeState>{
  @override
  ThemeState get initialState =>CurrentThemeState(activeTheme:true);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event)async* {
    if(event is SetLightTheme){
      yield CurrentThemeState(activeTheme:true);
      //true indicates light-mode
    }
    else if(event is SetDarkTheme){
      yield CurrentThemeState(activeTheme:false);
      //false indicates dark-mode
    }
  }
}