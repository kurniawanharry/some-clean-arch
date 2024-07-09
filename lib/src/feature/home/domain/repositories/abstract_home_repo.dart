import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';

abstract class AbstractHomeRepository {
  Future<Either<Failure, UserModel>> fetchUser();
  Future<Either<Failure, List<UserModel>>> fetchUsers();
  Future<Either<Failure, UserModel>> fetchUserById(String id);
  Future<Either<Failure, UserModel>> toggleVerify(int id, bool value);
}
