import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:some_app/src/core/helper/helper.dart';
import 'package:some_app/src/core/network/logger_interceptor.dart';
import 'package:some_app/src/core/util/constants/network_constants.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/core/util/log/app_logger.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/data/models/token_model.dart';

class DioNetwork {
  static late Dio appAPI;
  static late Dio retryAPI;

  static void initDio() {
    appAPI = Dio(baseOptions(Env.apiUrl));
    appAPI.interceptors.add(loggerInterceptor());
    appAPI.interceptors.add(appQueuedInterceptorsWrapper());

    retryAPI = Dio(baseOptions(Env.apiUrl));
    retryAPI.interceptors.add(loggerInterceptor());
    retryAPI.interceptors.add(interceptorsWrapper());
  }

  static LoggerInterceptor loggerInterceptor() {
    return LoggerInterceptor(
      logger,
      request: true,
      requestBody: true,
      error: true,
      responseBody: true,
      responseHeader: false,
      requestHeader: true,
    );
  }

  ///__________App__________///

  /// App Api Queued Interceptor
  static QueuedInterceptorsWrapper appQueuedInterceptorsWrapper() {
    return QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, r) async {
        Map<String, dynamic> headers = Helper.getHeaders();

        final String? token = await _getToken(); // Retrieve token

        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }

        if (kDebugMode) {
          print("Headers");
          print(json.encode(headers));
        }
        options.headers = headers;
        appAPI.options.headers = headers;
        return r.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, try to refresh the token
          final refreshToken = await _getToken();
          if (refreshToken != null) {
            try {
              final newToken = await _refreshToken();
              await _saveToken(newToken);

              // Update the failed request with the new token
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer ${newToken.accessToken}';

              // Retry the failed request
              final response = await retryAPI.request(
                options.path,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
                data: options.data,
                queryParameters: options.queryParameters,
              );

              return handler.resolve(response);
            } catch (e) {
              // Handle token refresh failure (e.g., logout the user)
              return handler.reject(error);
            }
          } else {
            // Handle missing refresh token (e.g., logout the user)
            return handler.reject(error);
          }
        } else {
          return handler.next(error);
        }
      },
      onResponse: (Response<dynamic> response, ResponseInterceptorHandler handler) async {
        return handler.next(response);
      },
    );
  }

  /// App interceptor
  static InterceptorsWrapper interceptorsWrapper() {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, r) async {
        Map<String, dynamic> headers = Helper.getHeaders();

        final String? token = await _getToken(); // Retrieve token

        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }

        options.headers = headers;
        appAPI.options.headers = headers;

        return r.next(options);
      },
      onResponse: (response, handler) async {
        if ("${(response.data["code"] ?? "0")}" != "0") {
          return handler.resolve(response);
          // return handler.reject(DioError(requestOptions: response.requestOptions, response: response, error: response, type: DioErrorType.response));
        } else {
          return handler.next(response);
        }
      },
      onError: (error, handler) {
        try {
          return handler.next(error);
        } catch (e) {
          return handler.reject(error);
          // onUnexpectedError(handler, error);
        }
      },
    );
  }

  static BaseOptions baseOptions(String url) {
    Map<String, dynamic> headers = Helper.getHeaders();

    return BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds: 10), // Set connection timeout
        receiveTimeout: const Duration(seconds: 10), // Set receive timeout
        sendTimeout: const Duration(seconds: 10), // Set se
        validateStatus: (s) {
          return s! < 300;
        },
        headers: headers..removeWhere((key, value) => value == null),
        responseType: ResponseType.json);
  }

  static Future<String?> _getToken() async {
    final AuthSharedPrefs authSharedPrefs = getIt<AuthSharedPrefs>();
    return await authSharedPrefs.getToken();
  }

  static Future<TokenModel> _refreshToken() async {
    final response = await retryAPI.post('${Env.urlApiAuth}/refresh');
    if (response.statusCode == 200) {
      return TokenModel.fromJson(response.data);
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  static Future<void> _saveToken(TokenModel token) async {
    final AuthSharedPrefs authSharedPrefs = getIt<AuthSharedPrefs>();
    await authSharedPrefs.saveToken(token.accessToken!);
  }
}
