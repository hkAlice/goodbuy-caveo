import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodbuy/shared/constants/api_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    headers: {
      'User-Agent': ApiConstants.userAgent,
      'Content-Type': 'application/json',
    },
    connectTimeout: const Duration(seconds: ApiConstants.timeout),
    receiveTimeout: const Duration(seconds: ApiConstants.timeout),
    // todo: retryEvaluator ou retryInterceptor
  ));
});
