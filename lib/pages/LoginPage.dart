import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/HomePage.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn signIn = GoogleSignIn();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoggedIn = false;
  bool isLoading = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();

    isSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        image: AssetImage(
                            'assets/images/google_signin_button.png'),
                        fit: BoxFit.cover)),
              ),
              onTap: () {
                debugPrint('Google login clicked');
                googleSignIn();
              },
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
              child: isLoading ? circularProgress() : Container(),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> googleSignIn() async {
    //await Firebase.initializeApp();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    preferences = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });
    //
    GoogleSignInAccount userAccount = await signIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await userAccount.authentication;

    debugPrint("Hello ${googleSignInAuthentication.idToken}");

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    //
    debugPrint('Google auth success ${credential.toString()}');
    //
    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    debugPrint('Firebase auth success ${firebaseUser.displayName}');

    //Login successful
    if (firebaseUser != null) {
      final QuerySnapshot resultQuery = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;

      if (documentSnapshots.length == 0) {
        Firestore.instance
            .collection('user')
            .document(firebaseUser.uid)
            .setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'aboutMe': 'About me',
          'createAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null,
        });

        //Write data to local
        currentUser = firebaseUser;
        await preferences.setString('id', firebaseUser.uid);
        await preferences.setString('nickname', firebaseUser.displayName);
        await preferences.setString('photoUrl', firebaseUser.photoUrl);
      } else {
        //Write data to local
        currentUser = firebaseUser;
        await preferences.setString('id', documentSnapshots[0]['id']);
        await preferences.setString(
            'nickname', documentSnapshots[0]['nickname']);
        await preferences.setString(
            'photoUrl', documentSnapshots[0]['photoUrl']);
        await preferences.setString('aboutMe', documentSnapshots[0]['aboutMe']);
      }

      Fluttertoast.showToast(msg: 'Sign in success');
      debugPrint('Sign in success');
      setState(() {
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: 'Try Again, Sign-in failed');
      setState(() {
        isLoading = false;
      });
    }
  }

  void isSignedIn() async {
    // this.setState(() {
    //   isLoggedIn = true;
    // });
    //
    // preferences = await SharedPreferences.getInstance();
    //
    // isLoggedIn = await signIn.isSignedIn();
    // if (isLoggedIn) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
    // }
  }
}
