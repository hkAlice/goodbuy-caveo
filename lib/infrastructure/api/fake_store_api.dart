import 'package:dio/dio.dart';
import 'package:goodbuy/application/dtos/product_dto.dart';

class FakeStoreApi {
  final Dio _dio;

  FakeStoreApi(this._dio);

  // todo: paginar
  Future<List<ProductDto>> getProducts({required int limit}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ProductDto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('errouuuuu $e');
    }
  }
}
