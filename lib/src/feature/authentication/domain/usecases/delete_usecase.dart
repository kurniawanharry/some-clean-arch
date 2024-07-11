import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/domain/repositories/abstract_auth_repo.dart';

class DeleteUseCase extends UseCase<UserModel, int> {
  final AbstractAuthRepository repository;

  DeleteUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(params) async {
    final result = await repository.delete(params);
    return result.fold((l) {
      return Left(l);
    }, (r) async {
      return Right(r);
    });
  }
}
