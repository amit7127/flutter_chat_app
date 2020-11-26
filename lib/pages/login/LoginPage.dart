import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/login/LoginAuthBloc.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/utils/ScaleConfig.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/home/HomePage.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// Created by Amit Kumar Sahoo on 10/29/2020
/// LoginScreen : login widget
///
class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn signIn = GoogleSignIn();

  SharedPreferences preferences;

  LoginAuthBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = LoginAuthBloc();
    // isSignedIn();
    bloc.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {

    //Initialize the intl for default language of the app
    //By default it's 'en'
    ScaleConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.red, Colors.purpleAccent])),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter Chat App',
              style: TextStyle(
                  fontSize: 65.0, color: Colors.white, fontFamily: 'Signatra'),
            ),
            GestureDetector(
              child: Container(
                width: 260.0,
                height: 50.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(50.0)),
              ),
              onTap: () {
                debugPrint('Google login clicked');
                bloc.loginUser();
              },
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
              child: StreamBuilder<CommonsResponse<FirebaseUser>>(
                stream: bloc.loginData.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<CommonsResponse<FirebaseUser>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.status == Status.LOADING) {
                      //Loading screen
                      return circularProgress();
                    } else if (snapshot.data.status == Status.ERROR) {
                      Fluttertoast.showToast(msg: snapshot.data.message);
                      return Container();
                    } else if (snapshot.data.status == Status.COMPLETED) {
                      Fluttertoast.showToast(msg: snapshot.data.message);
                      SchedulerBinding.instance
                          .addPostFrameCallback((timeStamp) {
                        navigateToHomePage();
                      });
                      return Container();
                    }
                  }
                  return Container();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
              child: StreamBuilder<CommonsResponse<bool>>(
                stream: bloc.isLogin.stream,
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
            ),
          ],
        ),
      ),
    );
  }

  void navigateToHomePage() {
    Navigator.push(context,
        MaterialPageRoute<HomeScreen>(builder: (context) => HomeScreen()));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
