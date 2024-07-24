import 'package:some_app/src/core/network/dio_network.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/remote/auth_impl_api.dart';
import 'package:some_app/src/feature/authentication/data/repositories/auth_repo_impl.dart';
import 'package:some_app/src/feature/authentication/domain/repositories/abstract_auth_repo.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_by_id_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_employee_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/refresh_token_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_in_usecases.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/logout_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_employee_usercase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_up_usecase.dart';

initAuthInjections() {
  getIt.registerSingleton<AuthImplApi>(AuthImplApi(DioNetwork.appAPI));
  getIt.registerSingleton<AbstractAuthRepository>(AuthRepositoryImpl(getIt()));
  getIt.registerSingleton<AuthSharedPrefs>(AuthSharedPrefs(getIt()));
  getIt.registerSingleton<SignInUseCase>(SignInUseCase(getIt()));
  getIt.registerSingleton<LogoutUseCase>(LogoutUseCase(getIt()));
  getIt.registerSingleton<SignUpUseCase>(SignUpUseCase(getIt()));
  getIt.registerSingleton<SignEmployeeUseCase>(SignEmployeeUseCase(getIt()));
  getIt.registerSingleton<EditEmployeeUseCase>(EditEmployeeUseCase(getIt()));
  getIt.registerSingleton<EditUseCase>(EditUseCase(getIt()));
  getIt.registerSingleton<EditByIdUseCase>(EditByIdUseCase(getIt()));
  getIt.registerSingleton<RefreshTokenUseCase>(RefreshTokenUseCase(getIt()));
}
