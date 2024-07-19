import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/core/util/usescases/usecases.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/home/domain/repositories/abstract_home_repo.dart';

class EmployeeUseCase extends UseCase<List<EmployeeModel>, NoParams> {
  final AbstractHomeRepository repository;

  EmployeeUseCase(this.repository);

  @override
  Future<Either<Failure, List<EmployeeModel>>> call(params) async {
    final result = await repository.fetchEmployee();
    return result.fold((l) {
      return Left(l);
    }, (r) async {
      return Right(r);
    });
  }
}
