import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/home/domain/usecase/employee_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/user_usecase.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final UserUseCase userUseCase;
  final EmployeeUseCase employeeUseCase;
  EmployeeCubit(
    this.userUseCase,
    this.employeeUseCase,
  ) : super(EmployeeInitial());

  List<EmployeeModel> allUsers = [];
  List<EmployeeModel> filteredUsers = [];

  Future fetchEmpolyee() async {
    try {
      emit(const HomeEmployeesSuccess([], isLoading: true));
      final result = await employeeUseCase.call(NoParams());
      result.fold((l) {
        emit(const HomeEmployeesSuccess([]));
      }, (r) async {
        allUsers = r;
        emit(HomeEmployeesSuccess(r, isFailed: false));
      });
    } catch (error) {
      emit(HomeEmployeesFailed(error.toString()));
    }
  }

  searchUsers(String query) {
    if (query.isEmpty) {
      emit(HomeEmployeesSuccess(allUsers, isFailed: false));
    } else {
      List<EmployeeModel> filteredUsers = allUsers.where((user) {
        return user.name!.toLowerCase().contains(query.toLowerCase()) ||
            user.username!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(HomeEmployeesSuccess(filteredUsers, isFailed: false));
    }
  }

  Future fetchUser(bool isAdmin) async {
    try {
      emit(EmployeeLoading());
      final result = await userUseCase.call(isAdmin);
      result.fold((l) {}, (r) async {
        emit(HomeEmployeeSuccess(r));
      });
    } catch (error) {
      emit(HomeEmployeesFailed(error.toString()));
    }
  }

  updateUser(int id, EmployeeModel model, {bool isAdmin = false}) {
    if (isAdmin) {
      var index = allUsers.indexWhere((element) => element.id == id);

      allUsers[index] = model;
      emit(HomeEmployeesSuccess(allUsers));
    }
  }
}
