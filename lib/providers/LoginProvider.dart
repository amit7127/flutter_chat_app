import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/utils/PreferenceUtils.dart';
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
    //await Firebase.initializeApp();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    GoogleSignInAccount userAccount = await signIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await userAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    //Login successful
    if (firebaseUser != null) {
      final QuerySnapshot resultQuery = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;

      if (documentSnapshots.length == 0) {
        await Firestore.instance
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
        User user = User(
            firebaseUser.uid, firebaseUser.displayName, firebaseUser.photoUrl);
        PreferenceUtils.saveUserDetailsPreference(user);
      } else {
        //Write data to local
        currentUser = firebaseUser;
        User user = User(
            documentSnapshots[0]['id'],
            documentSnapshots[0]['nickname'],
            documentSnapshots[0]['photoUrl'],
            documentSnapshots[0]['aboutMe']);
        PreferenceUtils.saveUserDetailsPreference(user);
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
}
