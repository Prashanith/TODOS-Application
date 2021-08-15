import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/Auth-BLoC/authbloc.dart';
import 'package:todos/Auth-BLoC/authstates.dart';
import 'package:todos/Auth-BLoC/user-repo.dart';
import 'package:todos/Login-BLoC/loginbloc.dart';
import 'package:todos/Login-BLoC/loginevents.dart';
import 'package:todos/Login-BLoC/loginstates.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  final bool checkState=true;

  LoginPage({Key key, @required this.userRepository}):
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo's",style: TextStyle(color: Colors.tealAccent),),
        centerTitle: true,
        backgroundColor:  Colors.grey[800],
      ),
      body:Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8,0.0),
                  tileMode: TileMode.repeated,
                  colors: [
                    Colors.white,
                    Colors.grey[300],
                    Colors.red

                  ],
                  stops: [0.0,5.0,1.0],
              )
            ),
          ),
          LoginForm(),
        ],
      ),
    );
  }
}


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final username=TextEditingController();
  final password=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  final themeColor=Colors.grey[800];

  @override
  Widget build(BuildContext context) {

    onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: username.text,
          password: password.text,
        ),
      );
    }
    return BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state){
          if (state is AuthenticationFailure){
            print('snack bar details');
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
              SnackBar(
                content: Text('Login Failed ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.fromLTRB(35,50,35,0),
              child:Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Theme(
                      data: ThemeData(
                        cardColor: themeColor,
                        primaryColor: themeColor,
                        primaryColorDark: themeColor,
                      ),
                      child: TextFormField(
                        onEditingComplete: ()=>_formKey.currentState.validate(),
                        validator: (username){
                          if(username.isEmpty){
                            return 'Email Address cannot be empty';
                          }
                          if(!EmailValidator.validate(username)){
                            return 'Email Address not provided';
                          }
                          else
                            return null;
                        },
                        keyboardType:TextInputType.emailAddress,
                        cursorColor: themeColor,
                        style: TextStyle(
                          color: themeColor,
                        ),
                        decoration: InputDecoration(labelText: 'username',
                          enabledBorder:  OutlineInputBorder(
                            borderSide:  BorderSide(color:themeColor),
                          ),
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: themeColor,
                          ),
                        ),
                        controller: username,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Theme(
                      data: ThemeData(
                        cardColor: themeColor,
                        primaryColor:themeColor,
                        primaryColorDark: themeColor,
                      ),
                      child: TextFormField(
                        onEditingComplete: ()=>_formKey.currentState.validate(),
                        validator: (password){
                          return password.length<8?'Minimum 8 characters':null;
                        },
                        obscureText: true,
                        cursorColor: themeColor,
                        style: TextStyle(
                          color: themeColor,
                        ),
                        decoration: InputDecoration(labelText: 'password',
                          enabledBorder:  OutlineInputBorder(
                            borderSide:  BorderSide(color:themeColor),
                          ),
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: themeColor,
                          ),
                        ),
                        controller: password,
                      ),
                    ),
                    SizedBox(height: 15,),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: themeColor,
                      onPressed: () async{
                        if(_formKey.currentState.validate()&&EmailValidator.validate(username.text)){
                          onLoginButtonPressed();
                        }
                        else{}
                      },
                      child: Text('Login',style: TextStyle(color: Colors.tealAccent),),
                    ),
                    BlocBuilder<AuthenticationBloc,AuthenticationState>(
                        builder: (context,state){
                          return Column(
                            children: <Widget>[
                              SizedBox(height: 15,),
                              state is AuthenticationInProgress?
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.grey[800]),
                                strokeWidth: 5,
                              ):SizedBox(height: 0,),
                            ],
                          );
                        }
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  }
}







