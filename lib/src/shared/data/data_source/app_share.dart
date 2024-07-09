import 'package:shared_preferences/shared_preferences.dart';
import 'package:some_app/src/core/util/constants/local_constants.dart';

class AppSharedPrefs {
  final SharedPreferences _preferences;

  AppSharedPrefs(this._preferences);

  /// __________ Language __________ ///
  // LanguageEnum? getLang() {
  //   String? data = _preferences.getString(lang);
  //   return LanguageEnum.values.firstWhere((element) => element.local == data);
  // }

  // void setLang(LanguageEnum language) {
  //   _preferences.setString(lang, language.local);
  // }

  /// __________ Dark Theme __________ ///
  bool getIsDarkTheme() {
    return _preferences.getBool(theme) ?? false;
  }

  void setDarkTheme(bool isDark) {
    _preferences.setBool(theme, isDark);
  }
}
