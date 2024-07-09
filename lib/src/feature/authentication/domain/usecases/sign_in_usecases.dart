import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';
import 'package:some_app/src/feature/authentication/domain/repositories/abstract_auth_repo.dart';

class SignInUseCase extends UseCase<TokenModel, SignInModel> {
  final AbstractAuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, TokenModel>> call(params) async {
    final result = await repository.signIn(params);
    return result.fold((l) {
      return Left(l);
    }, (r) async {
      return Right(r);
    });
  }
}
