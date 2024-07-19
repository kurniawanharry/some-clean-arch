part of 'employee_cubit.dart';

sealed class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

final class EmployeeInitial extends EmployeeState {}

class HomeEmployeesSuccess extends EmployeeState {
  final List<EmployeeModel> users;
  final bool isLoading;
  final bool? isFailed;

  const HomeEmployeesSuccess(this.users, {this.isLoading = false, this.isFailed});

  @override
  List<Object> get props => users;
}

class EmployeeLoading extends EmployeeState {}

class HomeEmployeesFailed extends EmployeeState {
  final String message;

  const HomeEmployeesFailed(this.message);

  @override
  List<Object> get props => [message];
}

class HomeEmployeeSuccess extends EmployeeState {
  final EmployeeModel user;

  const HomeEmployeeSuccess(this.user);

  @override
  List<Object> get props => [user];
}
