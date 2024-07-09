import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/home/domain/usecase/user_id_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/user_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/users_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/verify_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserUseCase userUseCase;
  final UsersUseCase usersUseCase;
  final UserIdUseCase userIdUseCase;
  final VerifyUseCase verifyUseCase;

  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];

  HomeCubit(
    this.userIdUseCase,
    this.userUseCase,
    this.usersUseCase,
    this.verifyUseCase,
  ) : super(HomeInitial());

  Future fetchUser() async {
    try {
      emit(HomeLoading());
      final result = await userUseCase.call(NoParams());
      result.fold((l) {
        if (l is ServerFailure) {
          if (l.statusCode == 401) {
            emit(HomeFailed());
          }
        } else if (l is CancelTokenFailure) {
          if (l.statusCode == 401) {
            emit(HomeFailed());
          }
        } else {
          emit(HomeFailure(l.errorMessage));
        }
      }, (r) async {
        emit(HomeUserSuccess(r));
      });
    } catch (error) {
      emit(HomeFailure(error.toString()));
    }
  }

  Future fetchUsers() async {
    try {
      emit(HomeLoading());
      final result = await usersUseCase.call(NoParams());
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
      emit(UserLoading());

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
}
