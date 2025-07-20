

import 'package:goodbuy/domain/use-cases/get_products_use_case.dart';
import 'package:goodbuy/application/repositories/product_repository.dart';
import 'package:goodbuy/domain/entities/product.dart';
import 'package:goodbuy/shared/command.dart';

class LoadProductsCommand implements Command<List<Product>> {
  final ProductRepository _repository;
  final int page;
  final int limit;

  LoadProductsCommand(
    this._repository, {
    required this.page,
    required this.limit,
  });

  @override
  Future<List<Product>> execute() async {
    return await _repository.getProducts(page, limit);
  }
}

class LoadProductsUseCase implements GetProductsUseCase {
  final ProductRepository _repository;

  LoadProductsUseCase(this._repository);

  @override
  Future<List<Product>> call(int page, int limit) async {
    final command = LoadProductsCommand(_repository, page: page, limit: limit);
    return await command.execute();
  }
}
