import 'package:expiree_app/notification/bloc_base.dart';
import 'package:expiree_app/notification/notification_bloc.dart';
//import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';

class AppBloc implements BlocBase {
  //UserBloc _userBloc;
  NotificationBloc _notificationBloc;

  AppBloc() {
    //_userBloc = UserBloc();
    _notificationBloc = NotificationBloc();
  }

  Future<void> init() async {
    //await _userBloc.init();
    await _notificationBloc.init();
  }

  //UserBloc get userBloc => _userBloc;
  NotificationBloc get notificationBloc => _notificationBloc;

  @override
  void dispose() {
    //_userBloc.dispose();
    _notificationBloc.dispose();
  }
}
