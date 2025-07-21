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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onInitScrollCheck();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onInitScrollCheck() {
    // verifica se precisamos buscar mais conteudo para preencher tela
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent <= _scrollController.position.viewportDimension) {
          _fetchMore();
    }
  }

  void _onScroll() {
    // verifica se scroll chegou no fim e carrega mais produtos
    final offset = 250;
    if (_scrollController.hasClients &&
         _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - offset) {
          _fetchMore();
    }
  }

  void _fetchMore() {
    if (!ref.read(productsProvider.notifier).hasError) {
      ref.read(productsProvider.notifier).fetchMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider);
    final hasError = ref.read(productsProvider.notifier).hasError;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GoodBuy'),
        elevation: 2.0,
      ),
      body: productsAsyncValue.when(
        skipError: true,
        data: (products) {
          return ListView.builder(
            controller: _scrollController,
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
