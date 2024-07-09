import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/home/domain/repositories/abstract_home_repo.dart';

class UserIdUseCase extends UseCase<UserModel, String> {
  final AbstractHomeRepository repository;

  UserIdUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(params) async {
    final result = await repository.fetchUserById(params);
    return result.fold((l) {
      return Left(l);
    }, (r) async {
      return Right(r);
    });
  }
}
