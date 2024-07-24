import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_response_model.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_by_id_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_employee_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/edit_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/refresh_token_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_in_usecases.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/logout_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_employee_usercase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:some_app/src/shared/data/data_source/imgur.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final EditUseCase editUseCase;
  final EditByIdUseCase editByIdUseCase;
  final RefreshTokenUseCase refreshUseCase;
  final AuthSharedPrefs authSharedPrefs;
  final SignEmployeeUseCase signEmployeeUseCase;
  final EditEmployeeUseCase editEmployeeUseCase;
  AuthCubit(
    this.signInUseCase,
    this.authSharedPrefs,
    this.signUpUseCase,
    this.logoutUseCase,
    this.editUseCase,
    this.editByIdUseCase,
    this.refreshUseCase,
    this.signEmployeeUseCase,
    this.editEmployeeUseCase,
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

  Future<void> signUp(bool isAdmin, SignUpModel params) async {
    try {
      emit(AuthLoading());
      if (params.photo != 'file') {
        var image = await getIt<ImgurClient>().fetchImgur(params.photo ?? '');
        params.photo = image?.data?.first ?? '';
      }

      if (params.ktp != 'file') {
        var image = await getIt<ImgurClient>().fetchImgur(params.ktp ?? '');
        params.ktp = image?.data?.first ?? '';
      }

      final result = await signUpUseCase.call(SignUpParams(isAdmin: isAdmin, model: params));
      result.fold((l) {
        emit(AuthFailure(l.errorMessage));
      }, (r) async {
        emit(AuthRegistered());
      });
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<void> createEmplyoee(EmployeeModel params) async {
    try {
      emit(AuthLoading());
      final result = await signEmployeeUseCase.call(params);
      result.fold((l) {
        emit(AuthFailure(l.errorMessage));
      }, (r) async {
        emit(AuthEmployeCreated());
      });
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<void> editEmplyoee(int id, EmployeeModel params) async {
    try {
      emit(AuthLoading());
      final result =
          await editEmployeeUseCase.call(EditIdEmployeeParams(firstValue: id, secondValue: params));
      result.fold((l) {
        emit(AuthFailure(l.errorMessage));
      }, (r) async {
        emit(AuthEmployeEdited(r));
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
        emit(AuthEditByIdSucceed(r));
      });
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<void> editById(bool isAdmin, int id, EditModel params) async {
    try {
      emit(AuthLoading());

      if (params.photo != 'file' && !params.photo!.startsWith('https')) {
        var image = await getIt<ImgurClient>().fetchImgur(params.photo ?? '');
        params.photo = image?.data?.first ?? '';
      }

      if (params.ktp != 'file' && !params.ktp!.startsWith('https')) {
        var image = await getIt<ImgurClient>().fetchImgur(params.ktp ?? '');
        params.ktp = image?.data?.first ?? '';
      }

      final result = await editByIdUseCase
          .call(EditIdParams(isAdmin: isAdmin, firstValue: id, secondValue: params));
      result.fold((l) {
        emit(AuthFailure(l.errorMessage));
      }, (r) async {
        emit(AuthEditByIdSucceed(r));
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
