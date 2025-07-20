import 'package:dio/dio.dart';
import 'package:goodbuy/application/dtos/product_dto.dart';

/// API do FakeStore - docs: https://fakestoreapi.com/docs
/// vamos fingir que 'page' seria o queryParameter para paginacao
class FakeStoreApi {
  final Dio _dio;

  FakeStoreApi(this._dio);

  Future<List<ProductDto>> getProducts({
    required int limit,
    required int page,
  }) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          'limit': limit,
          'page': page
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ProductDto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Exception, stack trace: $e');
    }
  }
}
