import 'package:goodbuy/application/commands/load_products_command.dart';
import 'package:goodbuy/application/repositories/product_repository.dart';
import 'package:goodbuy/domain/entities/product.dart';
import 'package:goodbuy/domain/use-cases/get_products_use_case.dart';

class LoadProductsUseCase implements GetProductsUseCase {
  final ProductRepository _repository;

  LoadProductsUseCase(this._repository);

  @override
  Future<List<Product>> call(int page, int limit) async {
    final command = LoadProductsCommand(_repository, page: page, limit: limit);
    final result = await command.execute();
    
    if (result.isSuccess && result.data != null) {
      return result.data!;
    } else {
      throw result.error ?? Exception('Unknown error occurred');
    }
  }
}
