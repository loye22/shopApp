import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louie_shop/provider/cart_provider.dart';
import 'package:louie_shop/provider/product_provider.dart';
import 'package:louie_shop/widgets/app_drawer.dart';
import 'package:louie_shop/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:louie_shop/screens/cart_screen.dart';

import '../widgets/badge.dart';

enum filterSelection { Favoreit, all }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/ProductOverviewScreen';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _favoreit = false;
  var _isInit = true;

  var _isloaded = true;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   Provider.of<product_provider>(context,listen: false).fetchData();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      Provider.of<product_provider>(context, listen: false)
          .fetchData()
          .then((_) {setState(() {
        _isloaded = false;
          });});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Only Favoreit'),
                value: filterSelection.Favoreit,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: filterSelection.all,
              ),
            ],
            onSelected: (filterSelection x) {
              setState(() {
                if (x == filterSelection.all) {
                  _favoreit = false;
                } else {
                  _favoreit = true;
                }
              });
            },
          ),
          Consumer<cartProvider>(
            builder: (_, cartProvider, ss) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(cartScreen.routeName);
                },
              ),
              value: cartProvider.getItemLenght.toString(),
              color: Colors.pink,
            ),
          )
        ],
      ),
      drawer: appDrawer(),
      body: _isloaded
          ? Center(
              child: CircularProgressIndicator(

              ),
            )
          : productGride(_favoreit),
    );
  }
}
