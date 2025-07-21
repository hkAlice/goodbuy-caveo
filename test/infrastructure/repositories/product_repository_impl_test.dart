import 'package:flutter_test/flutter_test.dart';
import 'package:goodbuy/application/dtos/product_dto.dart';
import 'package:goodbuy/domain/entities/product.dart';
import 'package:goodbuy/infrastructure/api/fake_store_api.dart';
import 'package:goodbuy/infrastructure/repositories/product_repository_impl.dart';

// api fake da fakestore api
class FakeFakeStoreApi implements FakeStoreApi {
  final List<ProductDto> _productDtos;
  final Exception? _exception;

  int? lastPageCalled;
  int? lastLimitCalled;
  
  FakeFakeStoreApi({
    List<ProductDto>? productDtos,
    Exception? exception,
  }) : _productDtos = productDtos ?? [],
       _exception = exception;
  
  @override
  Future<List<ProductDto>> getProducts({
    required int limit,
    required int page,
  }) async {
    // qual a ultima pagina chamada
    lastPageCalled = page;
    lastLimitCalled = limit;
    
    if (_exception != null) {
      throw _exception;
    }
    
    // simula paginacao
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= _productDtos.length) {
      return [];
    }
    
    final lastIndex = endIndex > _productDtos.length ? _productDtos.length : endIndex;
    return _productDtos.sublist(startIndex, lastIndex);
  }
}

void main() {
  group('ProductRepositoryImpl', () {
    // teste
    final testProductDtos = [
      ProductDto(
        id: 1,
        title: 'produto 1',
        price: 416.0,
        description: 'blah',
        category: 'categoria',
        image: 'imagem_1.jpg',
      ),
      ProductDto(
        id: 2,
        title: 'produto 2',
        price: 8290.0,
        description: 'blahblah',
        category: 'Test Category',
        image: 'imagem_2.jpg',
      ),
      ProductDto(
        id: 3,
        title: 'produto 3',
        price: 10.0,
        description: 'blahblahblah',
        category: 'Test Category',
        image: 'imagem_3.jpg',
      ),
    ];

    test('retorna se api estiver ok e dto->entity ok', () async {
      final api = FakeFakeStoreApi(productDtos: testProductDtos);
      final repository = ProductRepositoryImpl(api);
      
      // pega produtos do repo fake
      final products = await repository.getProducts(1, 2);
      
      expect(api.lastPageCalled, 1);
      expect(api.lastLimitCalled, 2);
      
      expect(products, isA<List<Product>>());
      expect(products.length, 2);
      
      // verificar se mapeamento esta ok
      expect(products[0].id, testProductDtos[0].id);
      expect(products[0].title, testProductDtos[0].title);
      expect(products[0].price, testProductDtos[0].price);
      expect(products[0].description, testProductDtos[0].description);
      expect(products[0].category, testProductDtos[0].category);
      expect(products[0].image, testProductDtos[0].image);
      
      expect(products[1].id, testProductDtos[1].id);
    });

    test('retorna lista vazia se api retornar vazio', () async {
      // Arrange
      final api = FakeFakeStoreApi(productDtos: []);
      final repository = ProductRepositoryImpl(api);
      
      // Act
      final products = await repository.getProducts(1, 10);
      
      // Assert
      expect(products, isA<List<Product>>());
      expect(products.isEmpty, true);
    });

    test('retorna exception em erro de api', () async {
      // Arrange
      final testException = Exception('API error');
      final api = FakeFakeStoreApi(exception: testException);
      final repository = ProductRepositoryImpl(api);
      
      // Act & Assert
      expect(
        () => repository.getProducts(1, 10),
        throwsA(testException),
      );
    });

    test('retorna paginacao correta', () async {
      // Arrange
      final api = FakeFakeStoreApi(productDtos: testProductDtos);
      final repository = ProductRepositoryImpl(api);

      // pagina 1
      final products1 = await repository.getProducts(1, 2);
      
      expect(api.lastPageCalled, 1);
      expect(api.lastLimitCalled, 2);
      expect(products1.length, 2);
      expect(products1[0].id, 1);
      expect(products1[1].id, 2);
      
      // pagina 2
      final products2 = await repository.getProducts(2, 2);
      
      expect(api.lastPageCalled, 2);
      expect(api.lastLimitCalled, 2);
      expect(products2.length, 1);
      expect(products2[0].id, 3);
    });
  });
}