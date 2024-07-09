import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/shared/data/data_source/app_share.dart';

initAppInjections() {
  getIt.registerFactory<AppSharedPrefs>(() => AppSharedPrefs(getIt()));
}
