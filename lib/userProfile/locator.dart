import 'package:expiree_app/userProfile/auth_repo.dart';
//import 'package:firebaseprofiletutorial/repository/storage_repo.dart';
import 'package:expiree_app/userProfile/user_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthRepo>(AuthRepo());
  locator.registerSingleton<UserController>(UserController());
}
