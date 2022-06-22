import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:louie_shop/screens/product_sceen_detales.dart';
import 'package:provider/provider.dart';
import 'package:louie_shop/provider/auth.dart';
import '../models/products.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';

class productItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item_data = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<cartProvider>(context, listen: false);
    final s = Scaffold.of(context);
    final authToken = Provider.of<AuthProvider>(context, listen: false);
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          child: Hero(
            tag: item_data.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image:NetworkImage( item_data.imageUrl,)
            ),
          ),

        footer: GridTileBar(
          title: Text(
            item_data.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, p, _) =>
                IconButton(
                  icon: item_data.isFavorite
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: () async {
                    try {
                      await item_data.toggleFavorite(
                          item_data.id, authToken.token, authToken.userId);
                    } catch (e) {
                      print('errrrrrrrrror');
                      return s.showSnackBar(SnackBar(
                        content: Text('some thing went wrong'),
                      ));
                    }
                  },
                ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItems(item_data.id, item_data.price, item_data.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added to the cart',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO ',
                    onPressed: () {
                      cart.removeSingleItem(item_data.id);
                    },
                  ),
                ),
              );
            },
          ),
          backgroundColor: Colors.black38,
        ),
      ),
    ),
    onTap: () {
    Navigator.of(context)
        .pushNamed(ProductDetalsScreen.routeName, arguments: item_data.id);
    },
    );
  }
}
