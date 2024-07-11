import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:some_app/src/core/network/error/dio_error_handler.dart';
import 'package:some_app/src/core/network/error/exceptions.dart';
import 'package:some_app/src/core/util/constants/network_constants.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/remote/abstract_auth_api.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_response_model.dart';

class AuthImplApi extends AbstractAuthApi {
  final Dio dio;

  CancelToken cancelToken = CancelToken();

  AuthImplApi(this.dio);

  @override
  Future<TokenModel> signIn(SignInModel params) async {
    try {
      final result = await dio.post('${Env.urlApiAuth}/login', data: jsonEncode(params.toJson()));
      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return TokenModel.fromJson(result.data);
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<UserResponseModel> signUp(SignUpModel params) async {
    try {
      final result =
          await dio.post('${Env.urlApiAuth}/register', data: jsonEncode(params.toJson()));
      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return UserResponseModel.fromJson(result.data);
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future logout() async {
    try {
      final result = await dio.post('${Env.urlApiAuth}/logout');
      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return result.data;
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<bool> edit(EditModel params) async {
    try {
      final result = await dio.post(
        Env.urlApiUser,
        data: jsonEncode(params.toJson()),
      );
      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return true;
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<TokenModel> refreshToken() async {
    try {
      final result = await dio.post('${Env.urlApiAuth}/refresh');
      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return TokenModel.fromJson(result.data);
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<UserResponseModel> editById(int id, EditModel params) async {
    try {
      final result = await dio.post(
        '${Env.urlApiAdmin}/users/$id',
        data: jsonEncode(params.toJson()),
      );
      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return UserResponseModel.fromJson(result.data);
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final result = await dio.delete(
        '${Env.urlApiAdmin}/users/$id',
      );
      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return result.data;
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}
