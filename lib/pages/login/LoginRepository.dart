import 'package:firebase_auth/firebase_auth.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/providers/LoginProvider.dart';

///
/// Created by Amit Kumar Sahoo on 10/29/2020
/// LoginRepository : Provides login provider object
///
class LoginRepository{
  LoginProvider _loginProvider = LoginProvider();

  ///Provides method for login user
  Future<FirebaseUser> loginUser(){
    return _loginProvider.signinUserWithGoogle();
  }

  ///Provides method for check if user already sign in or not
  Future<bool> checkForUserLogin(){
    return _loginProvider.isSignIn();
  }

  ///Provides method for logout user
  Future<bool> logoutUser(){
    return _loginProvider.signOutUser();
  }
}