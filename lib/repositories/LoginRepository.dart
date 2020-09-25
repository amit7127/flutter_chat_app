import 'package:firebase_auth/firebase_auth.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/providers/LoginProvider.dart';

class LoginRepository{
  LoginProvider _loginProvider = LoginProvider();
  Future<FirebaseUser> loginUser(){
    return _loginProvider.SigninUserWithGoogle();
  }
}