import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class ImageCacheCustom {
  static final Map<String, Uint8List> _cache = {};

  static Future<Uint8List> getImage(String url) async {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    } else {
      final Dio dio = Dio();
      final Response<List<int>> response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final Uint8List bytes = Uint8List.fromList(response.data!);
      _cache[url] = bytes;
      return bytes;
    }
  }

  static Future<Uint8List> loadLocalImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }
}
