import 'package:some_app/src/feature/authentication/data/models/user_model.dart';

abstract class AbstractHomeApi {
  Future<UserModel> fetchUser();
  Future<List<UserModel>> fetchUsers();
  Future<UserModel> fetchUserById(String id);
  Future<UserModel> toggleVerification(int id, bool value);
}
