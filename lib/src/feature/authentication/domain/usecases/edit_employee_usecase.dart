import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/domain/repositories/abstract_auth_repo.dart';

class EditEmployeeUseCase extends UseCase<EmployeeModel, EditIdEmployeeParams> {
  final AbstractAuthRepository repository;

  EditEmployeeUseCase(this.repository);

  @override
  Future<Either<Failure, EmployeeModel>> call(params) async {
    final result = await repository.editEmployee(params.firstValue, params.secondValue);
    return result.fold((l) {
      return Left(l);
    }, (r) async {
      return Right(r);
    });
  }
}
