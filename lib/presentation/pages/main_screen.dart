import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodbuy/shared/providers.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // verifica se scroll chegou no fim e carrega mais produtos
    // todo: arrumar para pre-carregar *antes* do maxScrollExtent!
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      ref.read(productsProvider.notifier).fetchMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GoodBuy'),
        elevation: 2.0,
      ),
      body: productsAsyncValue.when(
        data: (products) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: products.length + 1,
            itemBuilder: (context, index) {
              if (index == products.length) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final product = products.elementAt(index);
              return ListTile(
                title: Text(product.title),
                subtitle: Text('R\$ ${product.price.toString()}'),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const Center(
          child: Text('deu ruim'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Produtos'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrinho'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
      ),
    );
  }
}
