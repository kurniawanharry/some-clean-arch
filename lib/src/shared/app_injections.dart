import 'package:some_app/src/core/network/dio_network.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/shared/data/data_source/app_share.dart';
import 'package:some_app/src/shared/data/data_source/imgur.dart';

initAppInjections() {
  getIt.registerFactory<AppSharedPrefs>(() => AppSharedPrefs(getIt()));
  getIt.registerFactory<ImgurClient>(() => ImgurClient(DioNetwork.appAPI));
}
