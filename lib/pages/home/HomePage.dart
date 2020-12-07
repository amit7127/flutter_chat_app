import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
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
  TextEditingController searchEditingController = TextEditingController();
  Icon actionIcon = Icon(Icons.search);
  Widget appBarTitle;

  @override
  void initState() {
    super.initState();
    bloc = HomeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(S.of(context).homePageTitle, searchEditingController,
          () => navigateToSettingsPage()),
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
}
