import 'package:shared_preferences/shared_preferences.dart';

class AuthSharedPrefs {
  static const String _tokenKey = 'token';
  static const String _typeKey = 'type';

  final SharedPreferences preferences;

  AuthSharedPrefs(this.preferences);

  /// __________ Clear Storage __________ ///
  Future<bool> clearAllLocalData() async {
    return true;
  }

  Future saveToken(String token) async {
    await preferences.setString(_tokenKey, token);
  }

  Future saveType(int type) async {
    await preferences.setInt(_typeKey, type);
  }

  Future<String?>? getToken() async {
    return preferences.getString(_tokenKey);
  }

  bool isAdmin() {
    var result = preferences.getInt(_typeKey);
    if (result == 100) {
      return true;
    }
    return false;
  }

  Future<void> removeToken() async {
    await preferences.remove(_tokenKey);
  }
}
