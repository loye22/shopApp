import 'package:flutter/material.dart';
import 'package:louie_shop/provider/orders.dart';
import 'package:louie_shop/provider/product_provider.dart';
import 'package:louie_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';

class orderScreen extends StatelessWidget {
  static const routeName = '/orderScreen';


  @override
  Widget build(BuildContext context) {
   // final orderP = Provider.of<orderprovider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your order'),
        ),
        body: FutureBuilder(
          future:
          Provider.of<orderprovider>(context, listen: false).fitchOrder(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snap.error != null) {
                print('erorr');
              } else {
                return Consumer<orderprovider>( builder: (ctx,orderP,_)=>ListView.builder(
                  itemBuilder: (ctx, i) =>
                      orderItemWidget(
                        order: orderP.orders[i],
                      ),
                  itemCount: orderP.orders.length,
                ),);
              }
            }
          },
        )
      //
      //     _isLoaded ? Center(child: CircularProgressIndicator
      //     ()) : ListView.builder(
      // itemBuilder: (ctx, i) => orderItemWidget(
      // order: orderP.orders[i],
      // ),
      // itemCount: orderP.orders
      // .
      // length
      // ,
      // )
      // ,
    );
  }

}