import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static Future<bool> setIdentity({required String identity}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("identity", identity);
    return true;
  }

  static Future<String> getIdentity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString("identity");
    return path ?? "error";
  }
}
