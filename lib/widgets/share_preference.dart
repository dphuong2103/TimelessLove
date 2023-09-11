import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {
  static const String prefNameLocale = 'locale';

  static late SharedPreferences pref;
  static initiatePreference() async {
    pref = await SharedPreferences.getInstance();
  }
}
