import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/pages/login/LoginRepository.dart';
import 'package:flutter_chat_app/utils/AppBloc.dart';
import 'package:rxdart/rxdart.dart';
import 'search_user_repository.dart';

///
/// Created by Amit Kumar Sahoo on 11/2/2020.
/// search_user_bloc.dart :

class SearchUserBloc extends AppBlock {
  final BuildContext _context;
  final SearchRepository _homeRepo = SearchRepository();

  SearchUserBloc(this._context);

  final BehaviorSubject<User> _userData = BehaviorSubject<User>();
  final BehaviorSubject<CommonsResponse<List<User>>> _usersFromSearch = BehaviorSubject<CommonsResponse<List<User>>>();
  BehaviorSubject<User> get userData => _userData;
  BehaviorSubject<CommonsResponse<List<User>>> get userFromSearch => _usersFromSearch;

  ///get user data from Preferences
  void getUserDataFromDevice() async {
    var userData = await _homeRepo.getSavedUserDataFromDevice();
    _userData.add(userData);
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
    _userData.close();
  }
}
