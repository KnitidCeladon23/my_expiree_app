import 'dart:io';

import 'package:expiree_app/userProfile/locator.dart';
import 'package:expiree_app/userProfile/user_model.dart';
import 'package:expiree_app/userProfile/auth_repo.dart';

class UserController {
  UserModel _currentUser;
  AuthRepo _authRepo = locator.get<AuthRepo>();
  Future init;

  UserController() {
    init = initUser();
  }

  Future<UserModel> initUser() async {
    _currentUser = await _authRepo.getUser();
    return _currentUser;
  }

  UserModel get currentUser => _currentUser;

  void updateDisplayName(String displayName) {
    _currentUser.displayName = displayName;
    _authRepo.updateDisplayName(displayName);
  }

  Future<bool> validateCurrentPassword(String password) async {
    return await _authRepo.validatePassword(password);
  }

  void updateUserPassword(String password) {
    _authRepo.updatePassword(password);
  }
}
