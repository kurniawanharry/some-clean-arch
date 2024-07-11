part of 'auth_cubit.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final TokenModel user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AuthLoggedOut extends AuthState {}

class AuthRegistered extends AuthState {
  final UserResponseModel user;

  const AuthRegistered(this.user);

  @override
  List<Object> get props => [user];
}

class AuthEditSucceed extends AuthState {}

class AuthEditByIdSucceed extends AuthState {
  final UserResponseModel model;

  const AuthEditByIdSucceed(this.model);

  @override
  List<Object> get props => [model];
}
