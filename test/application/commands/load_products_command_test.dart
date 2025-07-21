import 'package:flutter_test/flutter_test.dart';
import 'package:goodbuy/application/commands/load_products_command.dart';
import 'package:goodbuy/application/repositories/product_repository.dart';
import 'package:goodbuy/domain/entities/product.dart';

// repositorio fake para teste de interface 
class FakeProductRepository implements ProductRepository {
  final List<Product> _products;
  final Exception? _exception;
  
  FakeProductRepository({
    List<Product>? products,
    Exception? exception,
  }) : _products = products ?? [],
       _exception = exception;
  
  @override
  Future<List<Product>> getProducts(int page, int limit) async {
    if (_exception != null) {
      throw _exception;
    }
    
    // fingir paginacao
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= _products.length) {
      return [];
    }
    
    final lastIndex = endIndex > _products.length ? _products.length : endIndex;
    return _products.sublist(startIndex, lastIndex);
  }
}

void main() {
  group('LoadProductsCommand', () {
    // teste
    final testProducts = [
      Product(
        id: 1,
        title: 'produto 1',
        price: 416.0,
        description: 'blah',
        category: 'categoria',
        image: 'imagem_1.jpg',
      ),
      Product(
        id: 2,
        title: 'produto 2',
        price: 8290.0,
        description: 'blahblah',
        category: 'Test Category',
        image: 'imagem_2.jpg',
      ),
      Product(
        id: 3,
        title: 'produto 3',
        price: 10.0,
        description: 'blahblahblah',
        category: 'Test Category',
        image: 'imagem_3.jpg',
      ),
    ];

    test('retorna sucesso quando o repositorio retornar OK', () async {
      final repository = FakeProductRepository(products: testProducts);
      final command = LoadProductsCommand(
        repository,
        page: 1,
        limit: 2,
      );
      
      // teste command execute
      final result = await command.execute();
      
      expect(result.isSuccess, true);
      expect(result.data, isA<List<Product>>());
      expect(result.data!.length, 2);
      expect(result.data![0].id, 1);
      expect(result.data![1].id, 2);
    });

    test('retorna sucesso com array vazio para fim de paginacao', () async {
      final repository = FakeProductRepository(products: testProducts);
      final command = LoadProductsCommand(
        repository,
        page: 3,
        limit: 2,
      );
      
      // teste command execute
      final result = await command.execute();
      
      expect(result.isSuccess, true);
      expect(result.data, isA<List<Product>>());
      expect(result.data!.isEmpty, true);
    });

    
    test('retorna paginacao correta', () async {
      final repository = FakeProductRepository(products: testProducts);
      
      final command1 = LoadProductsCommand(
        repository,
        page: 1,
        limit: 2,
      );

      final command2 = LoadProductsCommand(
        repository,
        page: 2,
        limit: 2,
      );
      
      // teste command execute
      final result1 = await command1.execute();
      final result2 = await command2.execute();
      
      expect(result1.isSuccess, true);
      expect(result1.data!.length, 2);
      expect(result1.data![0].id, 1);
      expect(result1.data![1].id, 2);
      
      expect(result2.isSuccess, true);
      expect(result2.data!.length, 1);
      expect(result2.data![0].id, 3);
    });
  });
  
}
