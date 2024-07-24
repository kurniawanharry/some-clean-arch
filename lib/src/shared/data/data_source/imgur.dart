import 'package:dio/dio.dart';
import 'package:some_app/src/core/network/error/dio_error_handler.dart';
import 'package:some_app/src/core/network/error/exceptions.dart';
import 'package:some_app/src/core/util/constants/network_constants.dart';
import 'package:some_app/src/shared/data/models/imgur_response.dart';

class ImgurClient {
  final Dio dio;

  ImgurClient(this.dio);

  Future<ImgurResponse?> fetchImgur(String image) async {
    try {
      final result = await dio.post(Env.urlApiImage, data: {
        "image": [
          image,
        ]
      });

      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return ImgurResponse.fromJson(result.data);
    } on DioException catch (e) {
      throw ServerException(handleDioError(e), e.response?.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}
