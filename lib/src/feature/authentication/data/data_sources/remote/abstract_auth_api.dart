import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_response_model.dart';

abstract class AbstractAuthApi {
  // Get all article
  Future<TokenModel> signIn(SignInModel params);

  Future<UserResponseModel> signUp(bool isAdmin, SignUpModel params);

  Future<EmployeeModel> signEmployee(EmployeeModel params);

  Future<EmployeeModel> editEmployee(int id, EmployeeModel params);

  Future<EmployeeModel> deleteEmployee(int id);

  Future<UserResponseModel> edit(EditModel params);

  Future<UserResponseModel> editById(bool isAdmin, int id, EditModel params);

  Future<TokenModel> refreshToken();

  Future<UserModel> delete(int id);

  Future logout();
}
