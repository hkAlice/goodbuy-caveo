import 'package:flutter/material.dart';
import 'package:goodbuy/domain/entities/product.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product;

  const ProductItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FlutterLogo(),
      trailing: IconButton(icon: Icon(Icons.star_border_rounded), onPressed: () => {},),
      title: Text(product.title),
      subtitle: Text('R\$ ${product.price.toString()}'),
    );
  }
}
