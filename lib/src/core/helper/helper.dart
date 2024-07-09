import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:some_app/src/core/util/constants/constants.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/shared/data/data_source/app_share.dart';

class Helper {
  /// Get language
  // static LanguageEnum getLang() {
  //   LanguageEnum? lang;
  //   lang = sl<AppSharedPrefs>().getLang();
  //   lang = lang ?? LanguageEnum.en;
  //   return lang;
  // }

  /// Get svg picture path
  static String getSvgPath(String name) {
    return "$svgPath$name";
  }

  /// Get image picture path
  static String getImagePath(String name) {
    return "$imagePath$name";
  }

  /// Get vertical space
  static double getVerticalSpace() {
    return 10.h;
  }

  /// Get horizontal space
  static double getHorizontalSpace() {
    return 10.w;
  }

  /// Get Dio Header
  static Map<String, dynamic> getHeaders() {
    return {}..removeWhere((key, value) => value == null);
  }

  static ThemeMode? isDarkTheme() {
    if (getIt<AppSharedPrefs>().getIsDarkTheme()) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }
}
