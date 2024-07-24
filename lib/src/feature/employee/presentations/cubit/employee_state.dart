part of 'employee_cubit.dart';

sealed class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

final class EmployeeInitial extends EmployeeState {}

class HomeEmployeesLoading extends EmployeeState {}

class HomeEmployeesSuccess extends EmployeeState {
  final List<EmployeeModel> users;

  const HomeEmployeesSuccess(this.users);

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

class HomeEmployeeDeleted extends EmployeeState {}
