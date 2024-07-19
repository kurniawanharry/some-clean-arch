import 'package:dio/dio.dart';
import 'package:some_app/src/core/network/error/dio_error_handler.dart';
import 'package:some_app/src/core/network/error/exceptions.dart';
import 'package:some_app/src/core/util/constants/network_constants.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/home/data/data_sources/remote/abstract_home_api.dart';

class HomeImpleApi extends AbstractHomeApi {
  final Dio dio;

  CancelToken cancelToken = CancelToken();

  HomeImpleApi(this.dio);

  @override
  Future<EmployeeModel> fetchUser(bool isAdmin) async {
    try {
      final result = await dio.get(isAdmin ? Env.urlApiAdmin : Env.urlApiEmployee);

      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return EmployeeModel.fromJson(result.data);
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<UserModel> fetchUserById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> fetchUsers(bool isAdmin) async {
    try {
      final result = await dio.get('${isAdmin ? Env.urlApiAdmin : Env.urlApiEmployee}/disabled');

      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return UserModel.fromJsonList(result.data);
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<UserModel> toggleVerification(int id, bool value) async {
    try {
      final result =
          await dio.post('${Env.urlApiAdmin}/disabled/verify/$id', data: {"is_verified": value});

      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return UserModel.fromJson(result.data);
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<List<EmployeeModel>> fetchEmployee() async {
    try {
      final result = await dio.get('${Env.urlApiAdmin}/employees');

      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return EmployeeModel.fromJsonList(result.data);
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}
