import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/home/HomePageBloc.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/login/LoginPage.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/settings/SettingsPage.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  HomeBloc bloc;
  Icon actionIcon = Icon(Icons.search);
  Widget appBarTitle = Text('Home Page');
  TextEditingController searchEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = HomeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          'Home Page', searchEditingController, () => navigateToSettingsPage()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton.icon(
              onPressed: () => bloc.logOutUser(),
              icon: Icon(Icons.close),
              label: Text("Sign out")),
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

  ///navigate to Settings page
  void navigateToSettingsPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Settings()));
  }
}
