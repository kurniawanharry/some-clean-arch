import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:some_app/src/core/network/dio_network.dart';
import 'package:some_app/src/core/util/log/app_logger.dart';
import 'package:some_app/src/feature/authentication/auth_injections.dart';
import 'package:some_app/src/feature/home/home_injections.dart';
import 'package:some_app/src/shared/app_injections.dart';

final getIt = GetIt.instance;

initInjections() async {
  await initSharedPrefsInjections();
  await initAppInjections();
  await initDioInjections();
  await initAuthInjections();
  await initHomeInjections();
}

initSharedPrefsInjections() async {
  getIt.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  await getIt.isReady<SharedPreferences>();
}

Future<void> initDioInjections() async {
  initRootLogger();
  DioNetwork.initDio();
}
