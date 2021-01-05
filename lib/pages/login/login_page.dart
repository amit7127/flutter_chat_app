import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/common_response.dart';
import 'package:flutter_chat_app/pages/home/home_page.dart';
import 'package:flutter_chat_app/pages/search/search_user_page.dart';
import 'package:flutter_chat_app/utils/scale_config.dart';
import 'package:flutter_chat_app/widgets/progress_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_auth_bloc.dart';

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
    //ScaleConfig().init(context);

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
              S.of(context).welcome_text,
              style: TextStyle(
                  fontSize: ScaleConfig.blockSizeHorizontal * 18, color: Colors.white, fontFamily: 'Signatra'),
            ),
            GestureDetector(
              child: Container(
                width: ScaleConfig.blockSizeHorizontal * 70,
                height: ScaleConfig.blockSizeVertical * 8,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover,
                    ),
                    //borderRadius: BorderRadius.circular(ScaleConfig.blockSizeHorizontal * 15)
                ),
              ),
              onTap: () {
                debugPrint('Google login clicked');
                bloc.loginUser();
              },
            ),
            Padding(
              padding: EdgeInsets.all(ScaleConfig.blockSizeHorizontal * 2),
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
              padding: EdgeInsets.all(ScaleConfig.blockSizeHorizontal * 2),
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

  ///After success login replace to Home page
  void navigateToHomePage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute<HomePage>(builder: (context) => HomePage()));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
