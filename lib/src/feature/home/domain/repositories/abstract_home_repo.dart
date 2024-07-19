import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';

abstract class AbstractHomeRepository {
  Future<Either<Failure, EmployeeModel>> fetchUser(bool isAdmin);
  Future<Either<Failure, List<UserModel>>> fetchUsers(bool isAdmin);
  Future<Either<Failure, List<EmployeeModel>>> fetchEmployee();
  Future<Either<Failure, UserModel>> fetchUserById(String id);
  Future<Either<Failure, UserModel>> toggleVerify(int id, bool value);
}
