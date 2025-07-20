import 'package:dio/dio.dart';
import 'package:goodbuy/shared/constants/api_constants.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'User-Agent': ApiConstants.userAgent,
          'Content-Type': 'application/json',
        },
      ),
    );

    return dio;
  }
}
