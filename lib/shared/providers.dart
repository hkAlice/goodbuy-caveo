import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodbuy/application/repositories/product_repository.dart';
import 'package:goodbuy/application/use-cases/load_products_use_case.dart';
import 'package:goodbuy/domain/entities/product.dart';
import 'package:goodbuy/domain/use-cases/get_products_use_case.dart';
import 'package:goodbuy/infrastructure/api/fake_store_api.dart';
import 'package:goodbuy/infrastructure/repositories/product_repository_impl.dart';
import 'package:goodbuy/shared/clients/dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create();
});

final fakeStoreApiProvider = Provider<FakeStoreApi>((ref) {
  final dio = ref.watch(dioProvider);
  return FakeStoreApi(dio);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final api = ref.watch(fakeStoreApiProvider);
  return ProductRepositoryImpl(api);
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return LoadProductsUseCase(repository);
});

final productsProvider =
    StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductNotifier(ref);
});

// todo: idealmente estaria em /application/
class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductNotifier(this._ref) : super(const AsyncValue.loading()) {
    _fetchInitialProducts();
  }

  final Ref _ref;
  int _page = 1;
  final int _limit = 20;
  bool _isLoading = false;
  bool _hasError = false;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> _fetchInitialProducts() async {
    _page = 1;
    state = const AsyncValue.loading();
    await _fetchProducts(isInitialPage: true);
  }

  Future<void> _fetchProducts({bool isInitialPage = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    _hasError = false;
    
    // mantem state anterior
    final previous = state.value ?? [];

    try {
      final getProductsUseCase = _ref.read(getProductsUseCaseProvider);
      final products = await getProductsUseCase.call(_page, _limit);

      if (isInitialPage) {
        // troca o state pelo novo
        state = AsyncValue.data(products);
      } else {
        // adiciona novos produtos ao state anterior
        state = AsyncValue.data([...previous, ...products]);
      }
      _page++;
    } catch (e, s) {
      _hasError = true;

      if (previous.isEmpty) {
        state = AsyncValue.error(e, s);
      }
      else {
        state = AsyncValue.data(previous);
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> fetchMoreProducts() async {
    await _fetchProducts();
  }
}

