import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/blocs/HomePageBloc.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/pages/LoginPage.dart';
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

  @override
  void initState() {
    super.initState();
    bloc = HomeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
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
                        navigateToHomePage();
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

  void navigateToHomePage() {
    Navigator.push(context,
        MaterialPageRoute<HomeScreen>(builder: (context) => LoginScreen()));
  }
}
