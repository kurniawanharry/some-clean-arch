import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';

abstract class AbstractHomeApi {
  Future<EmployeeModel> fetchUser(bool isAdmin);
  Future<List<UserModel>> fetchUsers(bool isAdmin);
  Future<List<EmployeeModel>> fetchEmployee();
  Future<UserModel> fetchUserById(String id);
  Future<UserModel> toggleVerification(int id, bool value);
}
