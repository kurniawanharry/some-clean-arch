import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/styles/app_dimens.dart';
import 'package:some_app/src/core/styles/app_text_style.dart';

class AppTheme {
  /// Light theme
  static final ThemeData appTheme = ThemeData(
    dialogBackgroundColor: AppColors.lightGray,
    cardColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(
      // shadowColor: AppColors.lightGray,
      color: AppColors.white,
      elevation: 2,
      toolbarTextStyle: const TextTheme(
        titleLarge: AppTextStyle.xxxLargeBlack,
      ).bodyLarge,
      titleTextStyle: const TextTheme(
        titleLarge: AppTextStyle.xxxLargeBlack,
      ).titleLarge,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    fontFamily: "Georgia",
    scaffoldBackgroundColor: AppColors.white,
    iconTheme: const IconThemeData(color: AppColors.black, size: 25),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyle.xxxLargeBlack,
      headlineMedium: AppTextStyle.xLargeBlack,
      titleMedium: AppTextStyle.xSmallBlack,
      titleSmall: AppTextStyle.smallBlack,
      bodyLarge: AppTextStyle.largeBlack,
      bodyMedium: AppTextStyle.mediumBlack,
    ),

    // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.primaryColor),
    // inputDecorationTheme: InputDecorationTheme(
    //     fillColor: AppColors.transparent,
    //     contentPadding: EdgeInsets.symmetric(
    //       horizontal: 10.sp,
    //     ),
    //     suffixIconColor: AppColors.black,
    //     border: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(10.sp),
    //         borderSide: const BorderSide(color: AppColors.white, width: 1)),
    //     enabledBorder: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(10.sp),
    //         borderSide: const BorderSide(color: AppColors.white, width: 1)),
    //     focusedBorder: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(10.sp),
    //         borderSide: const BorderSide(color: AppColors.white, width: 1)),
    //     errorMaxLines: 2),
  );

  /// Dark theme
  static final ThemeData darkAppTheme = ThemeData(
    dialogBackgroundColor: AppColors.primaryColor,

    cardColor: AppColors.orange.withOpacity(0.5),
    appBarTheme: AppBarTheme(
      shadowColor: AppColors.white,
      color: AppColors.darkGray,
      elevation: 0,
      toolbarTextStyle: const TextTheme(
        titleLarge: AppTextStyle.xxxLargeWhite,
      ).bodyLarge,
      titleTextStyle: const TextTheme(
        titleLarge: AppTextStyle.xxxLargeWhite,
      ).titleLarge,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    fontFamily: "Georgia",
    scaffoldBackgroundColor: AppColors.primaryColor,
    iconTheme: const IconThemeData(color: AppColors.white, size: 25),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyle.xxxLargeWhite,
      headlineMedium: AppTextStyle.xLargeWhite,
      titleMedium: AppTextStyle.xSmallWhite,
      titleSmall: AppTextStyle.smallWhite,
      bodyLarge: AppTextStyle.largeWhite,
      bodyMedium: AppTextStyle.mediumWhite,
    ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: AppColors.primaryColor,
    //     padding: EdgeInsets.symmetric(
    //       horizontal: 50.w,
    //       vertical: 12.h,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    // ),
    // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.primaryColor),
    // inputDecorationTheme: InputDecorationTheme(
    //   contentPadding: EdgeInsets.symmetric(
    //     horizontal: 10.w,
    //   ),
    //   filled: true,
    //   suffixIconColor: AppColors.white,
    //   fillColor: AppColors.transparent,
    //   border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10.sp),
    //       borderSide: const BorderSide(color: AppColors.lightGray, width: 1)),
    //   enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10.sp),
    //       borderSide: const BorderSide(color: AppColors.lightGray, width: 1)),
    //   focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10.sp),
    //       borderSide: const BorderSide(color: AppColors.lightGray, width: 1)),
    //   errorMaxLines: 2,
    // ),
  );
}

class Themes {
  static ThemeData defaultThemes(BuildContext context, {bool isDark = false}) {
    return ThemeData(
      useMaterial3: true,
      dialogBackgroundColor: isDark ? AppColors.primaryColor : AppColors.main,
      platform: Platform.isAndroid ? TargetPlatform.android : TargetPlatform.iOS,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: isDark ? AppColors.primaryColor : AppColors.main,
      iconTheme: IconThemeData(color: isDark ? AppColors.white : AppColors.black, size: 25),
      textTheme: isDark
          ? const TextTheme(
              headlineLarge: AppTextStyle.xxxLargeWhite,
              headlineMedium: AppTextStyle.xLargeWhite,
              titleMedium: AppTextStyle.xSmallWhite,
              titleSmall: AppTextStyle.smallWhite,
              bodyLarge: AppTextStyle.largeWhite,
              bodyMedium: AppTextStyle.mediumWhite,
            )
          : const TextTheme(
              headlineLarge: AppTextStyle.xxxLargeBlack,
              headlineMedium: AppTextStyle.xLargeBlack,
              titleMedium: AppTextStyle.mediumBlack,
              titleSmall: AppTextStyle.smallBlack,
              bodyLarge: AppTextStyle.largeBlack,
              bodyMedium: AppTextStyle.mediumBlack,
            ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.standarBorder,
          ),
          borderSide: const BorderSide(
            color: AppColors.darkGray,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.standarBorder,
          ),
          borderSide: const BorderSide(
            color: AppColors.lightGray,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.standarBorder,
          ),
          borderSide: const BorderSide(
            color: AppColors.secondary,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.primaryColor : AppColors.secondary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.standarButtonBorder),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: AppColors.secondary,
          selectedForegroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
