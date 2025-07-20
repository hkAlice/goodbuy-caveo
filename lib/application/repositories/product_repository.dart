import 'package:goodbuy/domain/entities/product.dart';
import 'package:goodbuy/infrastructure/api/fake_store_api.dart';

abstract class ProductRepository {
  final FakeStoreApi _api;

  ProductRepository(this._api);

  Future<List<Product>> getProducts(int page, int limit);
}
