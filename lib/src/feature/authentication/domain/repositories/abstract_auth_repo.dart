import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_response_model.dart';

abstract class AbstractAuthRepository {
  Future<Either<Failure, TokenModel>> signIn(SignInModel params);
  Future<Either<Failure, UserResponseModel>> signUp(bool isAdmin, SignUpModel params);
  Future<Either<Failure, EmployeeModel>> signEmployee(EmployeeModel params);
  Future<Either<Failure, EmployeeModel>> editEmployee(int id, EmployeeModel params);
  Future<Either<Failure, EmployeeModel>> deleteEmployee(int id);
  Future<Either<Failure, TokenModel>> refreshToken();
  Future<Either<Failure, UserResponseModel>> edit(EditModel params);
  Future<Either<Failure, UserResponseModel>> editById(int id, EditModel params);
  Future<Either<Failure, UserModel>> delete(int params);
  Future<Either<Failure, dynamic>> logout();
}
