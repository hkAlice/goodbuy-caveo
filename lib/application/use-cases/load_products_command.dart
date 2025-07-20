

import 'package:goodbuy/application/repositories/product_repository.dart';
import 'package:goodbuy/domain/entities/product.dart';

/// todo: para escalar melhor, criar classe abstrata "Command" com generics T
class LoadProductsCommand {
  final ProductRepository _repository;
  final int page;
  final int limit;

  LoadProductsCommand(this._repository, {
    required this.page,
    required this.limit,
  });

  Future<List<Product>> execute() async {
    return await _repository.getProducts(page, limit);
  }
}
