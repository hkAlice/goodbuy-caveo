import 'package:goodbuy/domain/entities/product.dart';

// interface para use-case de paginacao para produtos
abstract class GetProductsUseCase {
  Future<List<Product>> call(int page, int limit);
}