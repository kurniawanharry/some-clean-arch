import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:some_app/src/core/helper/helper.dart';
import 'package:some_app/src/core/router/router.dart';
import 'package:some_app/src/core/styles/app_theme.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/delete_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_by_id_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_employee_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/refresh_token_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_in_usecases.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/logout_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_karyawan_usercase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:some_app/src/feature/authentication/presentations/cubit/auth_cubit.dart';
import 'package:some_app/src/feature/employee/presentations/cubit/employee_cubit.dart';
import 'package:some_app/src/feature/home/domain/usecase/employee_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/user_id_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/user_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/users_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/verify_usecase.dart';
import 'package:some_app/src/feature/home/presentations/cubit/home_cubit.dart';
import 'package:intl/date_symbol_data_local.dart';

///NIK
///NAMA
///MSISDN
///PASSWORD
///GENDER
///T&L
///TIPE DISABILITAS
///ADDRESS
///COORDINATE

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await initInjections();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppNotifier(),
      child: Consumer<AppNotifier>(
        builder: (_, value, child) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<AuthCubit>(
                  create: (context) => AuthCubit(
                    getIt<SignInUseCase>(),
                    getIt<AuthSharedPrefs>(),
                    getIt<SignUpUseCase>(),
                    getIt<LogoutUseCase>(),
                    getIt<EditUseCase>(),
                    getIt<EditByIdUseCase>(),
                    getIt<RefreshTokenUseCase>(),
                    getIt<SignEmployeeUseCase>(),
                    getIt<EditEmployeeUseCase>(),
                  ),
                ),
                BlocProvider<HomeCubit>(
                  create: (context) => HomeCubit(
                    getIt<UserIdUseCase>(),
                    getIt<UsersUseCase>(),
                    getIt<VerifyUseCase>(),
                    getIt<RefreshTokenUseCase>(),
                    getIt<DeleteUseCase>(),
                    getIt<AuthSharedPrefs>(),
                  ),
                ),
                BlocProvider<EmployeeCubit>(
                  create: (context) => EmployeeCubit(
                    getIt<UserUseCase>(),
                    getIt<EmployeeUseCase>(),
                  ),
                ),
              ],
              child: MaterialApp.router(
                title: 'Some App',
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
                theme: Themes.defaultThemes(context, isDark: false),
                // darkTheme: Themes.defaultThemes(context, isDark: true),
                themeMode: value.darkTheme,
                localizationsDelegates: const [
                  // GlobalMaterialLocalizations.delegate,
                  // GlobalWidgetsLocalizations.delegate,
                  // GlobalCupertinoLocalizations.delegate,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppNotifier extends ChangeNotifier {
  late ThemeMode? darkTheme;

  AppNotifier() {
    _initialise();
  }

  Future _initialise() async {
    darkTheme = Helper.isDarkTheme();

    notifyListeners();
  }

  updateThemeTitle(ThemeMode newDarkTheme) {
    darkTheme = newDarkTheme;
    if (Helper.isDarkTheme() == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
    notifyListeners();
  }
}
