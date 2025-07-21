import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodbuy/presentation/widgets/loading_widget.dart';
import 'package:goodbuy/presentation/widgets/page_error_widget.dart';
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
      if (!ref.read(productsProvider.notifier).hasError) {
        ref.read(productsProvider.notifier).fetchMoreProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider);
    final hasError = ref.read(productsProvider.notifier).hasError;

    // ideal seria errors nao apagarem o conteudo todo!
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoodBuy'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: productsAsyncValue.when(
          skipError: true,
          data: (products) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView.builder(
                  //controller: _scrollController,
                  itemCount: products.length + 1,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == products.length) {
                      if (hasError) {
                        return PageErrorWidget(
                          onTap: () {
                            ref.read(productsProvider.notifier).fetchMoreProducts();
                          },
                        );
                      }
                      else {
                        return LoadingWidget();
                      }
                    }
                
                    final product = products.elementAt(index);
                    return ProductItemWidget(product: product,);
                  },
                ),
              ],
            );
          },
          loading: () => Center(
            child: LoadingWidget(),
          ),
          error: (error, stackTrace) {
            return Center(
              child: PageErrorWidget(
                onTap: () {
                  ref.invalidate(productsProvider);
                },
              ),
            );
          },
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
