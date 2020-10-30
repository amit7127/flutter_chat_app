import 'package:firebase_auth/firebase_auth.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/providers/LoginProvider.dart';

///
/// Created by Amit Kumar Sahoo on 10/29/2020
/// LoginRepository : Provides login provider object
///
class LoginRepository{
  LoginProvider _loginProvider = LoginProvider();

  Future<FirebaseUser> loginUser(){
    return _loginProvider.signinUserWithGoogle();
  }

  Future<bool> checkForUserLogin(){
    return _loginProvider.isSignIn();
  }
}