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

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final getProductsUseCase = ref.watch(getProductsUseCaseProvider);
  // todo: tirar paginacao hardcoded aqui
  return getProductsUseCase(1, 20);
});
