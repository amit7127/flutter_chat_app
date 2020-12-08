import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/widgets/AppDrawer.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/home/HomePageBloc.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/login/LoginPage.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/settings/SettingsPage.dart';

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
            return AppDrawer(snapshot.data.photoUrl, changeLanguage, navigateToSettingsPage);
          } else {
            //Data is not available or data is empty for the profile image, so show placeholder
            return AppDrawer('', changeLanguage, navigateToSettingsPage);
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton.icon(
              onPressed: () => bloc.logOutUser(),
              icon: Icon(Icons.close),
              label: Text(S.of(context).logoutButtonText)),
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
          Text(
            S.of(context).hello,
            style: TextStyle(fontSize: 32),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  setState(() {
                    S.load(Locale('en'));
                  });
                },
                child: Text('English'),
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    S.load(Locale('fr'));
                  });
                },
                child: Text('French'),
              )
            ],
          )
        ],
      ),
    );
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
  void changeLanguage(Locale locale){
    print(locale.languageCode);
    setState(() {
      S.load(locale);
    });
  }
}
