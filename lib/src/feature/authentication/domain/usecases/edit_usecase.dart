import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_response_model.dart';
import 'package:some_app/src/feature/authentication/domain/repositories/abstract_auth_repo.dart';

class EditUseCase extends UseCase<UserResponseModel, EditModel> {
  final AbstractAuthRepository repository;

  EditUseCase(this.repository);

  @override
  Future<Either<Failure, UserResponseModel>> call(params) async {
    final result = await repository.edit(params);
    return result.fold((l) {
      return Left(l);
    }, (r) async {
      return Right(r);
    });
  }
}
