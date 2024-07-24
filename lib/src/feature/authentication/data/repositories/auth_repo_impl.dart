import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/exceptions.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/remote/auth_impl_api.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_response_model.dart';
import 'package:some_app/src/feature/authentication/domain/repositories/abstract_auth_repo.dart';

class AuthRepositoryImpl extends AbstractAuthRepository {
  final AuthImplApi articlesApi;

  AuthRepositoryImpl(
    this.articlesApi,
  );

  @override
  Future<Either<Failure, TokenModel>> signIn(SignInModel params) async {
    try {
      final result = await articlesApi.signIn(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, dynamic>> logout() async {
    try {
      final result = await articlesApi.logout();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, UserResponseModel>> signUp(bool isAdmin, SignUpModel params) async {
    try {
      final result = await articlesApi.signUp(isAdmin, params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, UserResponseModel>> edit(EditModel params) async {
    try {
      final result = await articlesApi.edit(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, TokenModel>> refreshToken() async {
    try {
      final result = await articlesApi.refreshToken();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, UserResponseModel>> editById(
      bool isAdmin, int id, EditModel params) async {
    try {
      final result = await articlesApi.editById(isAdmin, id, params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, UserModel>> delete(int params) async {
    try {
      final result = await articlesApi.delete(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> editEmployee(int id, EmployeeModel params) async {
    try {
      final result = await articlesApi.editEmployee(id, params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> signEmployee(EmployeeModel params) async {
    try {
      final result = await articlesApi.signEmployee(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> deleteEmployee(int id) async {
    try {
      final result = await articlesApi.deleteEmployee(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }
}
