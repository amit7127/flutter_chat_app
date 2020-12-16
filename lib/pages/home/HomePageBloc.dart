import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/pages/home/HomeRepsitory.dart';
import 'package:flutter_chat_app/pages/login/LoginRepository.dart';
import 'package:flutter_chat_app/utils/AppBloc.dart';
import 'package:rxdart/rxdart.dart';

///
/// Created by Amit Kumar Sahoo on 11/2/2020.
/// HomePageBloc.dart :

class HomeBloc extends AppBlock {
  final BuildContext _context;
  final LoginRepository _repository = LoginRepository();
  final HomeRepository _homeRepo = HomeRepository();

  HomeBloc(this._context);

  final BehaviorSubject<CommonsResponse<bool>> _logout =
      BehaviorSubject<CommonsResponse<bool>>();
  final BehaviorSubject<User> _userData = BehaviorSubject<User>();
  final BehaviorSubject<CommonsResponse<List<User>>> _usersFromSearch = BehaviorSubject<CommonsResponse<List<User>>>();

  BehaviorSubject<CommonsResponse<bool>> get logout => _logout;
  BehaviorSubject<User> get userData => _userData;
  BehaviorSubject<CommonsResponse<List<User>>> get userFromSearch => _usersFromSearch;

  ///get user data from Preferences
  void getUserDataFromDevice() async {
    var userData = await _homeRepo.getSavedUserDataFromDevice();
    _userData.add(userData);
  }

  ///logout user
  void logOutUser() async {
    _logout.add(CommonsResponse.loading(S.of(_context).logout_wait_message));
    var loginData = await _repository.logoutUser();

    if (loginData == null) {
      _logout
          .add(CommonsResponse.error(S.of(_context).error_in_logout_message));
    } else if (loginData == true) {
      _logout.add(CommonsResponse.completed(loginData,
          message: S.of(_context).logout_success_message));
    } else {
      _logout.add(CommonsResponse.completed(loginData,
          message: S.of(_context).unable_to_logout_message));
    }
  }

  ///Search user
  void searchUsers(String searchQuery) async{
    if(searchQuery.isNotEmpty){
      _usersFromSearch.add(CommonsResponse.loading(S.of(_context).user_fetching_dialog));

      var dataSnapShots = await _homeRepo.getListOfUsersFromString(searchQuery);
      var usersList = <User>[];

      dataSnapShots.documents.forEach((element) {
        var user = User.fromMap(element.data);

        if(user != null){
          usersList.add(user);
        }
      });
      _usersFromSearch.add(CommonsResponse.completed(usersList));

    } else {
      _usersFromSearch.add(CommonsResponse.completed(null));
    }
  }

  @override
  void dispose() {
    _logout.close();
    _userData.close();
  }
}
