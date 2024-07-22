import 'package:go_router/go_router.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/presentations/pages/employee_page.dart';
import 'package:some_app/src/feature/authentication/presentations/pages/login_page.dart';
import 'package:some_app/src/feature/authentication/presentations/pages/register_page.dart';
import 'package:some_app/src/feature/home/presentations/pages/home.dart';
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
            path: 'details/:type',
            builder: (context, state) {
              final data = state.extra as UserModel?;

              final type = state.pathParameters['type'];
              return RegisterPage(
                data: data,
                type: int.tryParse(type ?? '100'),
              );
            },
          ),
          GoRoute(
            path: 'create/:type',
            builder: (context, state) {
              final type = state.pathParameters['type'];
              return RegisterPage(
                type: int.tryParse(type ?? '100'),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: 'employee',
        path: '/employee',
        builder: (context, state) => const EmployeePage(),
        routes: [
          GoRoute(
            path: 'details/:type',
            builder: (context, state) {
              final data = state.extra as EmployeeModel?;

              final type = state.pathParameters['type'];
              return EmployeePage(
                data: data,
                type: int.tryParse(type ?? '100'),
              );
            },
          ),
        ],
      ),

      // GoRoute(
      //   name: 'home',
      //   path: '/home/:type',
      //   builder: (context, state) {
      //     return const GoogleMapHomePage();
      //   },
      // ),

      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) {
          return const Home();
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
