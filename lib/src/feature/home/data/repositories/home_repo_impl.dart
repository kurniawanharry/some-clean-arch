import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/exceptions.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/home/data/data_sources/remote/home_impl_api.dart';
import 'package:some_app/src/feature/home/domain/repositories/abstract_home_repo.dart';

class HomeRepositoryImpl extends AbstractHomeRepository {
  final HomeImpleApi homeImpleApi;

  HomeRepositoryImpl(this.homeImpleApi);

  @override
  Future<Either<Failure, EmployeeModel>> fetchUser(bool isAdmin) async {
    try {
      final result = await homeImpleApi.fetchUser(isAdmin);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, UserModel>> fetchUserById(String id) async {
    try {
      final result = await homeImpleApi.fetchUserById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> fetchUsers(bool isAdmin) async {
    try {
      final result = await homeImpleApi.fetchUsers(isAdmin);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, UserModel>> toggleVerify(int id, bool value) async {
    try {
      final result = await homeImpleApi.toggleVerification(id, value);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeModel>>> fetchEmployee() async {
    try {
      final result = await homeImpleApi.fetchEmployee();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }
}
