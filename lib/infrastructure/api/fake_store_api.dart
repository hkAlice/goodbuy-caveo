import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goodbuy/application/dtos/product_dto.dart';
import 'package:goodbuy/utils/cache_utils.dart';

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
      // se for pagina inicial, cache de forma bem basica
      // todo: ideal seria cache url com tempo de expiracao, etc...
      if (page == 1) {
        var cacheData = await CacheHelper.getCache('getProductsInitialPage');
        if (cacheData != null) {
          final List<dynamic> data = jsonDecode(cacheData);
          return data.map((json) => ProductDto.fromJson(json)).toList();
        }
      }

      final response = await _dio.get(
        '/products',
        queryParameters: {
          'limit': limit,
          'page': page
        },
      );

      final List<dynamic> data = response.data;

      if (page == 1) {
        await CacheHelper.saveCache('getProductsInitialPage', jsonEncode(data));
      }
      
      return data.map((json) => ProductDto.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Conexao falhou a responder. Verifique a conexao com a internet e tente novamente');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Conexao falhou. Verifique a conexao com a internet e tente novamente');
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode != 200) {
          throw Exception('Erro no servidor');
        }
      }
      throw Exception('Erro: ${e.message}');
    } catch (e) {
      throw Exception('Exception, stack trace: $e');
    }
  }
}
