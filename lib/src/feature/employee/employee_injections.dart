import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/domain/usecases/delete_employee_usecase.dart';
import 'package:some_app/src/feature/home/domain/usecase/employee_usecase.dart';

initEmployeeInjections() {
  getIt.registerSingleton<EmployeeUseCase>(EmployeeUseCase(getIt()));
  getIt.registerSingleton<DeleteEmployeeUseCase>(DeleteEmployeeUseCase(getIt()));
}
