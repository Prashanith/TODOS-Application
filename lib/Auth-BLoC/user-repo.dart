import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository{
  final verifiedUserId=FlutterSecureStorage();
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;

  Future<Map> authenticate({
    @required username,@required password
  }) async{
    AuthResult result;
    String errorMessage;
    try{
      result = await _firebaseAuth.signInWithEmailAndPassword(email: username, password: password);
    }
    catch(e){
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if(result==null){
      return {
        'userID':null,
        'errorMessage':errorMessage,
      };
    }
    await verifiedUserId.write(key:'verifiedUser', value:result.user.uid);
    return {
      'userID':result.user.uid,
      'errorMessage':null,
    };

  }

  //deletes the existing token and gets logged out
  Future<void> deleteToken() async{
    await Future.delayed(Duration(seconds: 1));
    _firebaseAuth.signOut().then((value) async =>
    await verifiedUserId.deleteAll()
    );
    print('Logout Successful');
    return;
  }

  //re-verification  of existing token to login
  // returns false if token does not exist else returns true
  Future<String> checkToken() async{
    await Future.delayed(Duration(seconds: 1));
    String verifiedUserToken = await verifiedUserId.read(key:'verifiedUser');
    if(verifiedUserToken==null){
      return null;
    }
    else {
      return verifiedUserToken;
    }
  }
}