import 'package:flutter/material.dart';
import 'package:louie_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../provider/product_provider.dart';

class productGride extends StatelessWidget {
  final bool _isFavoreit  ;
  productGride( this._isFavoreit);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<product_provider>(context);
    final product = _isFavoreit ? productsData.favoreitItems : productsData.items;


    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: product.length,
      itemBuilder: (ctx, indx) => ChangeNotifierProvider.value(
        value:product[indx],
        child: productItem(),
      ),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
