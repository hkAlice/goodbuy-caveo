import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodbuy/application/repositories/product_repository.dart';
import 'package:goodbuy/application/use-cases/load_products_command.dart';
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
    _fetchProducts();
  }

  final Ref _ref;
  int _page = 1;
  final int _limit = 20;
  bool _isLoading = false;

  Future<void> _fetchProducts() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final getProductsUseCase = _ref.read(getProductsUseCaseProvider);
      final products = await getProductsUseCase.call(_page, _limit);

      state = AsyncValue.data([...state.value ?? [], ...products]);
      _page++;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> fetchMoreProducts() async {
    await _fetchProducts();
  }
}
