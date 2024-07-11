import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/user_response_model.dart';
import 'package:some_app/src/feature/authentication/domain/repositories/abstract_auth_repo.dart';

class EditByIdUseCase extends UseCase<UserResponseModel, EditIdParams> {
  final AbstractAuthRepository repository;

  EditByIdUseCase(this.repository);

  @override
  Future<Either<Failure, UserResponseModel>> call(params) async {
    final result = await repository.editById(params.firstValue, params.secondValue);
    return result.fold((l) {
      return Left(l);
    }, (r) async {
      return Right(r);
    });
  }
}
