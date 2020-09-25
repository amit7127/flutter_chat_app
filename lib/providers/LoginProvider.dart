import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginProvider {
  final GoogleSignIn signIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  Future<FirebaseUser> SigninUserWithGoogle() async {
    //await Firebase.initializeApp();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    GoogleSignInAccount userAccount = await signIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await userAccount.authentication;

    //debugPrint("Hello ${googleSignInAuthentication.idToken}");

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    //
    //debugPrint('Google auth success ${credential.toString()}');
    //
    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    //debugPrint('Firebase auth success ${firebaseUser.displayName}');

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
        //await preferences.setString('id', firebaseUser.uid);
        //await preferences.setString('nickname', firebaseUser.displayName);
        //await preferences.setString('photoUrl', firebaseUser.photoUrl);
      } else {
        //Write data to local
        currentUser = firebaseUser;
        // await preferences.setString('id', documentSnapshots[0]['id']);
        // await preferences.setString(
        //     'nickname', documentSnapshots[0]['nickname']);
        // await preferences.setString(
        //     'photoUrl', documentSnapshots[0]['photoUrl']);
        // await preferences.setString('aboutMe', documentSnapshots[0]['aboutMe']);
      }
      // Fluttertoast.showToast(msg: 'Sign in success');
      // debugPrint('Sign in success');
      // setState(() {
      //   isLoading = false;
      // });
    } else {
      // Fluttertoast.showToast(msg: 'Try Again, Sign-in failed');
      // setState(() {
      //   isLoading = false;
      // });
    }

    return firebaseUser;
  }
}
