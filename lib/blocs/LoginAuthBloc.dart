import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/utils/AppBloc.dart';
import 'package:rxdart/rxdart.dart';

import 'file:///D:/Practice%20Project/flutter_chat_app/lib/repositories/LoginRepository.dart';

class LoginAuthBloc extends AppBlock {
  final LoginRepository _repository = LoginRepository();

  final BehaviorSubject<CommonsResponse<FirebaseUser>> _logginData =
      BehaviorSubject<CommonsResponse<FirebaseUser>>();

  BehaviorSubject<CommonsResponse<FirebaseUser>> get loginData => _logginData;

  void loginUser() async {
    _logginData.add(CommonsResponse.loading('Please wait user logging in'));
    FirebaseUser response = await _repository.loginUser();

    if (response == null) {
      _logginData.add(CommonsResponse.error('Log-in Failed'));
    } else {
      _logginData.add(CommonsResponse.completed(response,
          message: 'Logged-in successfully'));
    }
  }

  @override
  dispose() {
    _logginData?.close();
  }
}
