import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {}

class Params {
  final int firstValue;
  final bool secondValue;

  Params({required this.firstValue, required this.secondValue});
}

class EditIdParams {
  final int firstValue;
  final EditModel secondValue;

  EditIdParams({required this.firstValue, required this.secondValue});
}

class EditIdEmployeeParams {
  final int firstValue;
  final EmployeeModel secondValue;

  EditIdEmployeeParams({required this.firstValue, required this.secondValue});
}

class SignUpParams {
  final bool isAdmin;
  final SignUpModel model;

  SignUpParams({required this.isAdmin, required this.model});
}
