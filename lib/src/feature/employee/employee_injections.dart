import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/home/domain/usecase/employee_usecase.dart';

initEmployeeInjections() {
  getIt.registerSingleton<EmployeeUseCase>(EmployeeUseCase(getIt()));
}
