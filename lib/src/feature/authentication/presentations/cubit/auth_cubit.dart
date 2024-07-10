import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/refresh_token_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_in_usecases.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/logout_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_up_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final EditUseCase editUseCase;
  final RefreshTokenUseCase refreshUseCase;
  final AuthSharedPrefs authSharedPrefs;

  AuthCubit(
    this.signInUseCase,
    this.authSharedPrefs,
    this.signUpUseCase,
    this.logoutUseCase,
    this.editUseCase,
    this.refreshUseCase,
  ) : super(AuthInitial());

  Future<void> signIn(SignInModel params) async {
    try {
      emit(AuthLoading());
      final result = await signInUseCase.call(params);
      result.fold((l) {
        emit(AuthFailure(l.errorMessage));
      }, (r) async {
        // Save the token to shared preferences
        await authSharedPrefs.saveToken(r.accessToken!);
        await authSharedPrefs.saveType(r.userType ?? 200);

        emit(AuthSuccess(r));
      });
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<void> signUp(SignUpModel params) async {
    try {
      emit(AuthLoading());
      final result = await signUpUseCase.call(params);
      result.fold((l) {
        emit(AuthFailure(l.errorMessage));
      }, (r) async {
        emit(AuthRegistered(r));
      });
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<void> edit(EditModel params) async {
    try {
      emit(AuthLoading());
      final result = await editUseCase.call(params);
      result.fold((l) {
        emit(AuthFailure(l.errorMessage));
      }, (r) async {
        emit(AuthEditSucceed());
      });
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future logout() async {
    try {
      emit(AuthLoading());
      await authSharedPrefs.removeToken();
      emit(AuthLoggedOut());
      // final result = await logoutUseCase.call(NoParams());
      // result.fold((l) {
      //   emit(AuthFailure(l.errorMessage));
      // }, (r) async {

      // });
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future refreshToken() async {
    try {
      emit(AuthLoading());
      final result = await refreshUseCase.call(NoParams());
      result.fold((l) {
        emit(AuthFailure(l.errorMessage));
      }, (r) async {
        // Save the token to shared preferences
        await authSharedPrefs.saveToken(r.accessToken!);
        await authSharedPrefs.saveType(r.userType ?? 200);

        emit(AuthSuccess(r));
      });
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }
}
