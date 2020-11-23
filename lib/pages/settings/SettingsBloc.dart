import 'package:flutter_chat_app/models/User.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/settings/SettingsRepository.dart';
import 'package:flutter_chat_app/utils/AppBloc.dart';
import 'package:rxdart/rxdart.dart';

///
/// Created by  on 11/23/2020.
/// SettingsBloc.dart : To Provide data related to settings page
///

class SettingsBloc extends AppBlock {
  final SettingsRepo _settingsRepo = SettingsRepo();

  final BehaviorSubject<User> _userData = BehaviorSubject<User>();

  BehaviorSubject<User> get userData => _userData;

  void getUserDataFromDevice() async {
    User userData = await _settingsRepo.getSavedUserDataFromDevice();
    _userData.add(userData);
  }

  @override
  void dispose() {
    _userData?.close();
  }
}
