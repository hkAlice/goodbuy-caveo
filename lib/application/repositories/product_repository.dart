import 'package:goodbuy/domain/entities/product.dart';
import 'package:goodbuy/infrastructure/api/fake_store_api.dart';

class ProductRepository {
  final FakeStoreApi _api;

  ProductRepository(this._api);

  Future<List<Product>> getProducts(int page, int limit) async {
    final productDtos = await _api.getProducts(limit: limit);
    
    return productDtos.map((dto) => dto.toEntity()).toList();
  }
}
