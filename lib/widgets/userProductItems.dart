import 'package:flutter/material.dart';
import 'package:louie_shop/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../screens/products_overview_screens.dart';
import 'package:louie_shop/screens/editProductScreen.dart';

class userProductsItems extends StatelessWidget {
  final String title;
  final String id;

  final String imageUrl;

  userProductsItems({this.title, this.imageUrl, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(editProductScreen.routeName,
                      arguments: this.id);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<product_provider>(context, listen: false)
                        .removeProductById(id);
                  } catch (e) {
                    return Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Couldnot delete the item'),
                    ));
                  }
                },
                icon: Icon(
                  Icons.delete_outline_outlined,
                  color: Theme.of(context).errorColor,
                ))
          ],
        ),
      ),
    );
  }
}
