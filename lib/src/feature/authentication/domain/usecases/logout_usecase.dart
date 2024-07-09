import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/domain/repositories/abstract_auth_repo.dart';

class LogoutUseCase extends UseCase<dynamic, NoParams> {
  final AbstractAuthRepository repository;

  LogoutUseCase(this.repository);
  @override
  Future<Either<Failure, dynamic>> call(NoParams params) async {
    final result = await repository.logout();
    return result.fold((l) {
      return Left(l);
    }, (r) async {
      return Right(r);
    });
  }
}
