import 'package:goodbuy/domain/entities/product.dart';

abstract class ProductRepository {
  ProductRepository();

  Future<List<Product>> getProducts(int page, int limit);
}
