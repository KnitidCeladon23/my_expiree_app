import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class CurrentUser extends ChangeNotifier {
  String _uid;
  String _email;

  String get getUid => _uid;

  String get getEmail => _email;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async {
    String retVal = "error";

    try {
      FirebaseUser _firebaseUser = await _auth.currentUser();
      _uid = _firebaseUser.uid;
      _email = _firebaseUser.email;
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      _uid = null;
      _email = null;
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  Future<String> signUpUser(String email, String password, name) async {
    String retVal = "error";

    try {
      final authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await updateUserName(name, authResult.user);


      retVal = "success";
    } catch (e) {
      retVal = e.message;
    }

    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "error";

    try {
      AuthResult _authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      _uid = _authResult.user.uid;
      _email = _authResult.user.email;
      retVal = "success";
    } catch (e) {
      retVal = e.message;
    }

    return retVal;
  }
//     //code does not work
//     Future<String> loginUserWithGoogle() async {
//     String retVal = "error";
//     GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly',]);
//       /*scopes: [
//         'email',
//         'https://www.googleapis.com/auth/contacts.readonly',
//       ],
//     );*/
//     try {
//       GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
//       print(_googleUser);
//       GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.getCredential(
//           idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
//       AuthResult _authResult = await _auth.signInWithCredential(credential);
//       print(_authResult);
//       _uid = _authResult.user.uid;
//       _email = _authResult.user.email;
//       retVal = "success";
//     } catch (e) {
//       retVal = e.message;
//     }

//     return retVal;
//   }
 }