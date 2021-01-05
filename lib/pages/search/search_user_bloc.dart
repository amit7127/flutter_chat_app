import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/common_response.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/utils/app_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'search_user_repository.dart';

///
/// Created by Amit Kumar Sahoo on 11/2/2020.
/// search_user_bloc.dart : Search user page bloc
///

class SearchUserBloc extends AppBlock {
  final BuildContext _context;
  final SearchRepository _homeRepo = SearchRepository();
  String userId;

  SearchUserBloc(this._context);

  final BehaviorSubject<User> _userData = BehaviorSubject<User>();
  final BehaviorSubject<CommonsResponse<List<User>>> _usersFromSearch =
      BehaviorSubject<CommonsResponse<List<User>>>();

  BehaviorSubject<User> get userData => _userData;

  BehaviorSubject<CommonsResponse<List<User>>> get userFromSearch =>
      _usersFromSearch;

  ///get user data from Preferences
  void getUserDataFromDevice() async {
    var userData = await _homeRepo.getSavedUserDataFromDevice();
    _userData.add(userData);
  }

  ///Search user
  ///[searchQuery] : String search key word
  void searchUsers(String searchQuery) async {
    if (searchQuery.isNotEmpty) {
      _usersFromSearch
          .add(CommonsResponse.loading(S.of(_context).user_fetching_dialog));

      userId ??= await _homeRepo.getCurrentUserIdFromPreference();
      var dataSnapShots = await _homeRepo.getListOfUsersFromString(searchQuery);
      var usersList = <User>[];

      dataSnapShots.documents.forEach((element) {
        var user = User.fromMap(element.data);

        if (user != null && user.id != userId) {
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
    _usersFromSearch.close();
  }
}
