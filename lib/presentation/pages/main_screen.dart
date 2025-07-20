import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodbuy/presentation/widgets/product_item_widget.dart';
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

    // todo: ideal seria adicionar um postFrameCallback para carregar mais caso a tela nao preencha

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
    final offset = 250;
    if (_scrollController.hasClients &&
         _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - offset) {
      ref.read(productsProvider.notifier).fetchMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider);

    // ideal seria errors nao apagarem o conteudo todo!
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    VerticalDivider(),
                    Text("Carregando")
                  ],
                );
              }

              final product = products.elementAt(index);
              return ProductItemWidget(product: product,);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48),
                const SizedBox(height: 16),
                const Text('Falha ao carregar conteúdo.'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    ref.read(productsProvider.notifier).fetchMoreProducts();
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        },
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
