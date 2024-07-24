import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/domain/repositories/abstract_auth_repo.dart';

class DeleteEmployeeUseCase extends UseCase<EmployeeModel, int> {
  final AbstractAuthRepository repository;

  DeleteEmployeeUseCase(this.repository);

  @override
  Future<Either<Failure, EmployeeModel>> call(params) async {
    final result = await repository.deleteEmployee(params);
    return result.fold((l) {
      return Left(l);
    }, (r) async {
      return Right(r);
    });
  }
}
