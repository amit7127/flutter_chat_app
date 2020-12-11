import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/utils/extension_utils.dart';
import 'package:flutter_chat_app/widgets/AppDrawer.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/home/HomePageBloc.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/login/LoginPage.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/settings/SettingsPage.dart';

import '../chatting_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  HomeBloc bloc;
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
    bloc = HomeBloc(context);
    bloc.getUserDataFromDevice();

    return Scaffold(
      key: _drawerKey,
      appBar: HomeAppBar(S.of(context).homePageTitle, searchEditingController,
          openDrawer, navigateToSettingsPage),
      endDrawer: StreamBuilder<User>(
        stream: bloc.userData.stream,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            //If data available show circular profile image
            return AppDrawer(snapshot.data.photoUrl, changeLanguage,
                navigateToSettingsPage, logoutUser);
          } else {
            //Data is not available or data is empty for the profile image, so show placeholder
            return AppDrawer(
                '', changeLanguage, navigateToSettingsPage, logoutUser);
          }
        },
      ),
      body: Stack(
        children: <Widget>[
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
          Padding(
            padding: EdgeInsets.all(6.0),
            child: StreamBuilder<CommonsResponse<bool>>(
              stream: bloc.logout.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<CommonsResponse<bool>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.status == Status.LOADING) {
                    //Loading screen
                    return circularProgress();
                  } else if (snapshot.data.status == Status.ERROR) {
                    Fluttertoast.showToast(msg: snapshot.data.message);
                    return Container();
                  } else if (snapshot.data.status == Status.COMPLETED) {
                    Fluttertoast.showToast(msg: snapshot.data.message);
                    if (snapshot.data.data == true) {
                      SchedulerBinding.instance
                          .addPostFrameCallback((timeStamp) {
                        navigateToLoginPage();
                      });
                    }
                    return Container();
                  }
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
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
          var joinedDate = DateFormat('dd MMMM yyyy - hh:mm:aa').format(
              DateTime.fromMillisecondsSinceEpoch((int.parse(user.createdAt))));
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
    bloc.searchUsers(searchQuery);
  }

  ///Logout user
  void logoutUser() {
    bloc.logOutUser();
  }

  ///navigates to home page
  void navigateToLoginPage() {
    Navigator.push(context,
        MaterialPageRoute<HomeScreen>(builder: (context) => LoginScreen()));
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

  ///Change language of the app
  void changeLanguage(Locale locale) {
    print(locale.languageCode);
    setState(() {
      S.load(locale);
    });
  }

  void navigateToChatPage(User receiverUser) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(receiverUser.id,
                receiverUser.nickname, receiverUser.photoUrl)));
  }
}
