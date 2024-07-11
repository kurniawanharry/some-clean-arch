import 'package:dartz/dartz.dart';
import 'package:some_app/src/core/network/error/failure.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';

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
