import 'package:goodbuy/application/commands/command.dart';
import 'package:goodbuy/application/repositories/product_repository.dart';
import 'package:goodbuy/domain/entities/product.dart';

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
  Future<Result<List<Product>>> execute() async {
    try {
      final products = await _repository.getProducts(page, limit);
      return Result.success(products);
    } catch (e, s) {
      return Result.error(e, s);
    }
  }
}
