import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/delete_usecase.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/refresh_token_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/user_id_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/users_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/verify_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UsersUseCase usersUseCase;
  final UserIdUseCase userIdUseCase;
  final VerifyUseCase verifyUseCase;
  final DeleteUseCase deleteUseCase;
  final RefreshTokenUseCase refreshUseCase;
  final AuthSharedPrefs authSharedPrefs;

  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];

  HomeCubit(
    this.userIdUseCase,
    this.usersUseCase,
    this.verifyUseCase,
    this.refreshUseCase,
    this.deleteUseCase,
    this.authSharedPrefs,
  ) : super(HomeInitial());

  Future fetchUsers(bool isAdmin) async {
    try {
      emit(HomeLoading());
      final result = await usersUseCase.call(isAdmin);
      result.fold((l) {
        emit(HomeFailure(l.errorMessage));
      }, (r) async {
        allUsers = r;
        emit(HomeUsersSuccess(r));
      });
    } catch (error) {
      emit(HomeFailure(error.toString()));
    }
  }

  searchUsers(String query) {
    if (query.isEmpty) {
      emit(HomeUsersSuccess(allUsers));
    } else {
      List<UserModel> filteredUsers = allUsers.where((user) {
        return user.name!.toLowerCase().contains(query.toLowerCase()) ||
            user.nik!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(HomeUsersSuccess(filteredUsers));
    }
  }

  toggleVerification(int id, bool value) async {
    try {
      emit(HomeLoading());

      var index = allUsers.indexWhere((element) => element.id == id);
      if (index != -1) {
        allUsers[index].isVerified = value;
        emit(HomeUsersSuccess(allUsers));
      }

      final result = await verifyUseCase.call(Params(
        firstValue: id,
        secondValue: value,
      ));

      result.fold((l) {
        emit(HomeFailure(l.errorMessage));
        allUsers[index].isVerified = !value;
        emit(HomeUsersSuccess(allUsers));
      }, (r) async {
        emit(VerifySuccess(r));
        var index = allUsers.indexWhere((element) => element.id == r.id);
        allUsers[index].isVerified = r.isVerified;
        emit(HomeUsersSuccess(allUsers));
      });
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  deleteUser(int id, UserModel? model) async {
    try {
      emit(HomeLoading());
      var index = allUsers.indexWhere((element) => element.id == id);

      final result = await deleteUseCase.call(id);

      result.fold((l) {
        emit(HomeFailure(l.errorMessage));
      }, (r) async {
        if (index != -1) {
          allUsers.removeAt(index);
        }
        emit(HomeDeleted());
        emit(HomeUsersSuccess(allUsers));
      });
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  filterUsers(String gender, String? disability) {
    if (gender == 'semua' && disability == null) {
      filteredUsers = List.from(allUsers);
    } else if (gender != 'semua' && disability == null) {
      var list = allUsers.where((user) => user.gender == gender).toList();
      filteredUsers = List.from(list);
    } else if (gender == 'semua' && disability != null) {
      var list = allUsers.where((user) => user.disability == disability).toList();
      filteredUsers = List.from(list);
    } else {
      var list =
          allUsers.where((user) => user.gender == gender && user.disability == disability).toList();
      filteredUsers = List.from(list);
    }
    emit(HomeUsersSuccess(filteredUsers));
  }

  Future refreshToken(bool isAdmin) async {
    try {
      emit(HomeLoading());
      final result = await refreshUseCase.call(NoParams());
      result.fold((l) {
        emit(HomeFailure(l.errorMessage));
      }, (r) async {
        // Save the token to shared preferences
        await authSharedPrefs.saveToken(r.accessToken!);
        await authSharedPrefs.saveType(r.userType ?? 200);

        fetchUsers(isAdmin);
      });
    } catch (error) {
      emit(HomeFailure(error.toString()));
    }
  }

  updateUser(int id, UserModel model) {
    var index = allUsers.indexWhere((element) => element.id == id);

    allUsers[index] = model;
    emit(HomeUsersSuccess(allUsers));
  }

  filterMap(bool verif, bool nonVerif) {
    if (verif && nonVerif) {
      filteredUsers = List.from(allUsers);
    } else if (!verif && nonVerif) {
      var list = allUsers.where((user) => user.isVerified == false).toList();
      filteredUsers = List.from(list);
    } else if (verif && !nonVerif) {
      var list = allUsers.where((user) => user.isVerified == true).toList();
      filteredUsers = List.from(list);
    } else {
      filteredUsers = [];
    }
    emit(HomeUsersSuccess(filteredUsers));
  }
}
