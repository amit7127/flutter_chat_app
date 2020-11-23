import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/login/LoginRepository.dart';
import 'package:flutter_chat_app/utils/AppBloc.dart';
import 'package:rxdart/rxdart.dart';

///
/// Created by Amit Kumar Sahoo on 11/2/2020.
/// HomePageBloc.dart :

class HomeBloc extends AppBlock {
  final LoginRepository _repository = LoginRepository();

  final BehaviorSubject<CommonsResponse<bool>> _logout =
      BehaviorSubject<CommonsResponse<bool>>();

  BehaviorSubject<CommonsResponse<bool>> get logout => _logout;

  ///logout user
  void logOutUser() async {
    _logout.add(CommonsResponse.loading('Logging out user, please wait.'));
    bool loginData = await _repository.logoutUser();
    print('returned from logout $loginData');


    if (loginData == null) {
      _logout.add(CommonsResponse.error(
          'Error: while logging out user.'));
    } else if (loginData == true) {
      _logout.add(CommonsResponse.completed(loginData,
          message: 'User logged out successfully'));
    } else {
      _logout.add(CommonsResponse.completed(loginData,
          message: 'Unable to logout user, please try after some time'));
    }
  }

  @override
  void dispose() {
    _logout.close();
  }
}
