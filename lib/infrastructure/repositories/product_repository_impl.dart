import 'package:goodbuy/application/dtos/product_dto.dart';
import 'package:goodbuy/application/repositories/product_repository.dart';
import 'package:goodbuy/domain/entities/product.dart';
import 'package:goodbuy/infrastructure/api/fake_store_api.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FakeStoreApi _api;

  ProductRepositoryImpl(this._api);

  @override
  Future<List<Product>> getProducts(int page, int limit) async {
    final productsDto = await _api.getProducts(page: page, limit: limit);
    return productsDto.map((dto) => dto.toDomain()).toList();
  }
}
