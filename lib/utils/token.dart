import 'package:shared_preferences/shared_preferences.dart';

class TokenUtil {
  static String _token;

  static Future<bool> tokenPresent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("token");
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    return _token;
  }

  static Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = token;
    return (await prefs.setString("token", token));
  }

  static Future<bool> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("token");
  }
}