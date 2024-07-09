import 'package:dio/dio.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/remote/abstract_token_api.dart';

class TokenImplApi extends AbstractTokenApi {
  final Dio dio;

  CancelToken cancelToken = CancelToken();

  TokenImplApi(this.dio);

  @override
  Future<String> refreshToken() {
    throw UnimplementedError();
  }
}
