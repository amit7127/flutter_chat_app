import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/pages/drawer/app_drawer_repository.dart';
import 'package:flutter_chat_app/utils/AppBloc.dart';
import 'package:rxdart/rxdart.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 28-12-2020.
/// app_drawer_bloc.dart :
///
class AppDrawerBloc extends AppBlock{
  final AppDrawerRepo _repository = AppDrawerRepo();

  final BehaviorSubject<CommonsResponse<bool>> _logout =
  BehaviorSubject<CommonsResponse<bool>>();
  final BehaviorSubject<User> _userData = BehaviorSubject<User>();

  BehaviorSubject<CommonsResponse<bool>> get logout => _logout;
  BehaviorSubject<User> get userData => _userData;

  ///get user data from Preferences
  void getUserDataFromDevice() async {
    var userData = await _repository.getSavedUserDataFromDevice();
    _userData.add(userData);
  }

  ///logout user
  void logOutUser(BuildContext context) async {
    _logout.add(CommonsResponse.loading(S.of(context).logout_wait_message));
    var loginData = await _repository.logoutUser();

    if (loginData == null) {
      _logout
          .add(CommonsResponse.error(S.of(context).error_in_logout_message));
    } else if (loginData == true) {
      _logout.add(CommonsResponse.completed(loginData,
          message: S.of(context).logout_success_message));
    } else {
      _logout.add(CommonsResponse.completed(loginData,
          message: S.of(context).unable_to_logout_message));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

}