import 'package:flutter/material.dart';
import 'package:louie_shop/provider/auth.dart';
import 'package:louie_shop/screens/order_screen.dart';
import 'package:louie_shop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

import '../screens/products_overview_screens.dart';

class appDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Yor Order'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProductOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Order'),
            onTap: () {
              Navigator.of(context).pushNamed(orderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text('User Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(userProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('log out '),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context,listen: false).logOut();

            },
          ),


        ],
      ),
    );
  }
}
