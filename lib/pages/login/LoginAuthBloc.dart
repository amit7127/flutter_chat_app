import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/utils/AppBloc.dart';
import 'package:rxdart/rxdart.dart';

import 'LoginRepository.dart';

///
/// Created by Amit Kumar Sahoo on 10/29/2020
/// LoginAuthBloc.dart : Login related methods BLOC
///
class LoginAuthBloc extends AppBlock {
  final LoginRepository _repository = LoginRepository();

  final BehaviorSubject<CommonsResponse<FirebaseUser>> _logginData =
      BehaviorSubject<CommonsResponse<FirebaseUser>>();

  final BehaviorSubject<CommonsResponse<bool>> _isLogin =
      BehaviorSubject<CommonsResponse<bool>>();

  BehaviorSubject<CommonsResponse<FirebaseUser>> get loginData => _logginData;

  BehaviorSubject<CommonsResponse<bool>> get isLogin => _isLogin;

  //Login user with google account
  void loginUser() async {
    _logginData.add(CommonsResponse.loading('Please wait user logging in'));
    var response = await _repository.loginUser();

    if (response == null) {
      _logginData.add(CommonsResponse.error('Log-in Failed'));
    } else {
      _logginData.add(CommonsResponse.completed(response,
          message: 'Logged-in successfully'));
    }
  }

  //Check if user already logged in
  void isLoggedIn() async {
    _isLogin.add(CommonsResponse.loading('Checking, user login data'));
    var loginData = await _repository.checkForUserLogin();

    if (loginData == null) {
      _isLogin.add(CommonsResponse.error('Unable to fetch user data'));
    } else if (loginData) {
      _isLogin.add(CommonsResponse.completed(loginData,
          message: 'User is already logged-in'));
    } else {
      _isLogin.add(CommonsResponse.completed(loginData,
          message: 'Please sign-in using google account.'));
    }
  }

  @override
  void dispose() {
    _logginData?.close();
    _isLogin.close();
  }
}
