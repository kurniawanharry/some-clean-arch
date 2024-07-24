part of 'home_cubit.dart';

@immutable
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeAdminLoading extends HomeState {}

class HomeUsersSuccess extends HomeState {
  final List<UserModel> users;

  const HomeUsersSuccess(this.users);

  @override
  List<Object> get props => users;
}

class HomeAdmin extends HomeState {}

class VerifySuccess extends HomeState {
  final UserModel value;

  const VerifySuccess(this.value);
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);

  @override
  List<Object> get props => [message];
}

class HomeFailed extends HomeState {}

class HomeDeleted extends HomeState {}
