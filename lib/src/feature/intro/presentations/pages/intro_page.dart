import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:some_app/src/core/helper/helper.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 1),
      () async => getIt<AuthSharedPrefs>().getToken()?.then((token) {
        if (token == null) {
          context.pushReplacementNamed('login');
        } else {
          final payload = parseJwt(token);
          final expiration = parseExpiration(payload);

          final type = getIt<AuthSharedPrefs>().getType() ?? 100;

          var isExpired = isTokenExpired(expiration);
          if (isExpired) {
            context.pushReplacementNamed('login');
          } else {
            context.pushReplacementNamed('home', pathParameters: {'type': '$type'});
          }
        }
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Image.asset(
            Helper.getImagePath("logo.png"),
            // color: Helper.isDarkTheme() ? AppColors.white : null,
            width: 200.w,
            height: 200.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> parseJwt(String token) {
    return JwtDecoder.decode(token);
  }

  DateTime parseExpiration(Map<String, dynamic> payload) {
    final exp = payload['exp'];
    if (exp == null) {
      throw Exception('Token does not contain expiration date');
    }

    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }

  bool isTokenExpired(DateTime expiration) {
    return DateTime.now().isAfter(expiration);
  }
}
