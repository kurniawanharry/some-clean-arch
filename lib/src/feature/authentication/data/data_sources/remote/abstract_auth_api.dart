import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_response_model.dart';

abstract class AbstractAuthApi {
  // Get all article
  Future<TokenModel> signIn(SignInModel params);

  Future<UserResponseModel> signUp(SignUpModel params);

  Future<bool> edit(EditModel params);

  Future<UserResponseModel> editById(int id, EditModel params);

  Future<TokenModel> refreshToken();

  Future<UserModel> delete(int id);

  Future logout();
}
