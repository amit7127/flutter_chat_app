import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/common_response.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/pages/drawer/app_drawer.dart';
import 'package:flutter_chat_app/pages/settings/settings_page.dart';
import 'package:flutter_chat_app/utils/string_utils.dart';
import 'package:flutter_chat_app/utils/extension_utils.dart';
import 'package:flutter_chat_app/widgets/home_app_bar.dart';
import 'package:flutter_chat_app/widgets/progress_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../chatting/chatting_page.dart';
import 'search_user_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  SearchUserBloc bloc;
  User currentUser;
  TextEditingController searchEditingController;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    searchEditingController = TextEditingController();
    searchEditingController.addListener(_searchUser);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Initialize bloc
    bloc = SearchUserBloc(context);
    bloc.getUserDataFromDevice();

    super.build(context);

    return Scaffold(
      key: _drawerKey,
      appBar: HomeAppBar(
          appBarTitle: S.of(context).homePageTitle,
          searchEditingController: searchEditingController,
          onSettingsButtonTapped: openDrawer,
          onProfileButtonClicked: navigateToSettingsPage),
      endDrawer: AppDrawer(refreshWidget: refreshWidget),
      body: Stack(
        children: <Widget>[
          StreamBuilder<User>(
            stream: bloc.userData.stream,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                //If data available show circular profile image
                currentUser = snapshot.data;
                return Container();
              } else {
                //Data is not available or data is empty for the profile image, so show placeholder
                return circularProgress();
              }
            },
          ),
          StreamBuilder<CommonsResponse<List<User>>>(
              stream: bloc.userFromSearch.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<CommonsResponse<List<User>>> snapShot) {
                if (snapShot.hasData) {
                  if (snapShot.data.status == Status.LOADING) {
                    return circularProgress();
                  } else if (snapShot.data.status == Status.COMPLETED) {
                    if (snapShot.data.data != null &&
                        snapShot.data.data.isNotEmpty) {
                      return _searchedUsersView(snapShot.data.data);
                    } else {
                      return _noResultScreen();
                    }
                  } else {
                    Fluttertoast.showToast(msg: snapShot.data.message);
                    return _noResultScreen();
                  }
                } else {
                  return _noResultScreen();
                }
              }),
        ],
      ),
    );
  }

  void refreshWidget() {
    setState(() {});
  }

  ///No search data available screen
  Widget _noResultScreen() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.group, color: Colors.lightBlueAccent, size: 100),
            Text(
              searchEditingController.text.isEmpty
                  ? S.of(context).search_user_hint
                  : S.of(context).no_result_hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  ///Search result for the users
  Widget _searchedUsersView(List<User> usersList) {
    return ListView.builder(
        itemCount: usersList.length,
        itemBuilder: (context, index) {
          var user = usersList[index];
          var joinedDate = StringUtils.getChatListDateFormat(
              serverTime: user.createdAt, context: context);
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.nickname.titleCase(),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              subtitle: Text(S.of(context).user_joined_text(joinedDate)),
              onTap: () => navigateToChatPage(user),
            ),
          );
        });
  }

  ///Search user in fire store
  void _searchUser() {
    var searchQuery = searchEditingController.text;
    if (searchQuery.isNotEmpty) {
      bloc.searchUsers(searchQuery);
    }
  }

  ///clear search text box
  void emptyTextFormField() {
    if (searchEditingController != null) searchEditingController.clear();
  }

  ///navigate to Settings page
  void navigateToSettingsPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Settings()));
  }

  ///Open drawer
  void openDrawer() {
    _drawerKey.currentState.openEndDrawer();
  }

  void navigateToChatPage(User receiverUser) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(receiverUser, currentUser)));
  }

  @override
  bool get wantKeepAlive => true;
}
