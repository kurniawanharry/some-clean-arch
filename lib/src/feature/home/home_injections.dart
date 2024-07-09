import 'package:some_app/src/core/network/dio_network.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/home/data/data_sources/local/home_shared_prefs.dart';
import 'package:some_app/src/feature/home/data/data_sources/remote/home_impl_api.dart';
import 'package:some_app/src/feature/home/data/repositories/home_repo_impl.dart';
import 'package:some_app/src/feature/home/domain/repositories/abstract_home_repo.dart';
import 'package:some_app/src/feature/home/domain/usecase/user_id_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/user_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/users_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/verify_usecase.dart';

initHomeInjections() {
  getIt.registerSingleton<HomeImpleApi>(HomeImpleApi(DioNetwork.appAPI));
  getIt.registerSingleton<AbstractHomeRepository>(HomeRepositoryImpl(getIt()));
  getIt.registerSingleton<HomeSharedPrefs>(HomeSharedPrefs(getIt()));
  getIt.registerSingleton<UserUseCase>(UserUseCase(getIt()));
  getIt.registerSingleton<UsersUseCase>(UsersUseCase(getIt()));
  getIt.registerSingleton<UserIdUseCase>(UserIdUseCase(getIt()));
  getIt.registerSingleton<VerifyUseCase>(VerifyUseCase(getIt()));
}
