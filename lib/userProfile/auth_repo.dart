import 'package:firebase_auth/firebase_auth.dart';
import 'package:expiree_app/userProfile/user_model.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthRepo();

  Future<UserModel> getUser() async {
    var firebaseUser = await _auth.currentUser();
    return UserModel(firebaseUser.uid,
        displayName: firebaseUser.displayName);
  }

  Future<void> updateDisplayName(String displayName) async {
    var user = await _auth.currentUser();

    user.updateProfile(
      UserUpdateInfo()..displayName = displayName,
    );
  }

  Future<bool> validatePassword(String password) async {
    var firebaseUser = await _auth.currentUser();

    var authCredentials = EmailAuthProvider.getCredential(
        email: firebaseUser.email, password: password);
    try {
      var authResult = await firebaseUser
          .reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = await _auth.currentUser();
    firebaseUser.updatePassword(password);
  }
}
