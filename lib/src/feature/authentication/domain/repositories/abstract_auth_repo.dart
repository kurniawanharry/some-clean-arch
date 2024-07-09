import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';

abstract class AbstractAuthRepository {
  Future<Either<Failure, TokenModel>> signIn(SignInModel params);
  Future<Either<Failure, UserModel>> signUp(SignUpModel params);
  Future<Either<Failure, bool>> edit(EditModel params);
  Future<Either<Failure, dynamic>> logout();
}
