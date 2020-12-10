import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/utils/Constants.dart';
import 'package:flutter_chat_app/utils/PreferenceUtils.dart';
import 'package:flutter_chat_app/utils/StringUtils.dart';
import 'package:google_sign_in/google_sign_in.dart';

///
/// Created by Amit Kumar Sahoo on 10/29/2020
/// LoginProvider : Provides login related methods
///
class LoginProvider {
  final GoogleSignIn signIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  ///
  /// sign in user with google account
  ///
  Future<FirebaseUser> signinUserWithGoogle() async {
    var userAccount = await signIn.signIn();
    var googleSignInAuthentication = await userAccount.authentication;

    final credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    var firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    //Login successful
    if (firebaseUser != null) {
      final resultQuery = await Firestore.instance
          .collection(Constants.USER_TABLE_NAME)
          .where(Constants.USER_ID, isEqualTo: firebaseUser.uid)
          .getDocuments();
      final documentSnapshots = resultQuery.documents;

      if (documentSnapshots.isEmpty) {
        await Firestore.instance
            .collection(Constants.USER_TABLE_NAME)
            .document(firebaseUser.uid)
            .setData({
          Constants.USER_NICKNAME: firebaseUser.displayName.toLowerCase(),
          Constants.USER_PHOTOURL: firebaseUser.photoUrl,
          Constants.USER_ID: firebaseUser.uid,
          Constants.USER_ABOUTME: 'About me',
          Constants.USER_CREATEDAT:
              DateTime.now().millisecondsSinceEpoch.toString(),
          Constants.USER_CHATTINGWITH: null,
          Constants.USER_NAME_CASE_SEARCH : StringUtils.setSearchParam(firebaseUser.displayName.toLowerCase())
        });

        //Write data to local
        currentUser = firebaseUser;
        var user = User(firebaseUser.uid,
            firebaseUser.displayName.toLowerCase(), firebaseUser.photoUrl, 'About me');
        await PreferenceUtils.saveUserDetailsPreference(user);
      } else {
        //Write data to local
        currentUser = firebaseUser;
        var user = User(
            documentSnapshots[0][Constants.USER_TABLE_NAME],
            documentSnapshots[0][Constants.USER_NICKNAME],
            documentSnapshots[0][Constants.USER_PHOTOURL],
            documentSnapshots[0][Constants.USER_ABOUTME]);
        await PreferenceUtils.saveUserDetailsPreference(user);
      }
    } else {
      //Sign in failed

      // Fluttertoast.showToast(msg: 'Try Again, Sign-in failed');
    }

    return firebaseUser;
  }

  ///
  /// Check if user is already signed in or not
  Future<bool> isSignIn() async {
    return await signIn.isSignedIn();
  }

  /// This method Signs out current user
  Future<bool> signOutUser() async {
    var status = false;
    await firebaseAuth.signOut();
    await signIn.disconnect();
    await signIn.signOut();

    status = true;
    return status;
  }
}
