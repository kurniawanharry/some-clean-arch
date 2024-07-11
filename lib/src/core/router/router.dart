import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/presentations/pages/login_page.dart';
import 'package:some_app/src/feature/authentication/presentations/pages/register_page.dart';
import 'package:some_app/src/feature/home/presentations/pages/home_page.dart';
import 'package:some_app/src/feature/intro/presentations/pages/intro_page.dart';
import 'package:some_app/src/feature/map/presentations/pages/google_map_page.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const IntroPage();
        },
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (context, state) => const RegisterPage(),
        routes: [
          GoRoute(
            path: 'details/:data&:type',
            builder: (context, state) {
              final jsonData = Uri.decodeComponent(state.pathParameters['data']!);
              final data = json.decode(jsonData) as Map<String, dynamic>;

              final type = state.pathParameters['type'];
              return RegisterPage(
                data: UserModel.fromJson(data),
                type: int.tryParse(type ?? '100'),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: 'home',
        path: '/home/:type',
        builder: (context, state) {
          return HomePage(
            type: int.parse(state.pathParameters['type'] ?? '200'),
          );
        },
      ),
      GoRoute(
        name: 'map',
        path: '/map',
        builder: (context, state) => const GoogleMapPage(),
      ),
    ],
  );
}
