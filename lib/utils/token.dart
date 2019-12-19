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

  static Future<List<String>> getTokenList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("tokens")) {
      prefs.setStringList("tokens", []);
    }
    return prefs.getStringList("tokens");
  }

  static Future<void> addToTokenList(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tokens = prefs.getStringList("tokens");
    tokens.add(token);
    prefs.setStringList("tokens", tokens);
    return;
  }

  static Future<void> removeFromTokenList(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tokens = prefs.getStringList("tokens");
    tokens.remove(token);
    prefs.setStringList("tokens", tokens);
    return;
  }
}