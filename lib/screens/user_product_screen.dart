import 'package:flutter/material.dart';
import 'package:louie_shop/provider/product_provider.dart';
import 'package:louie_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:louie_shop/screens/editProductScreen.dart';
import '../widgets/userProductItems.dart';

class userProductScreen extends StatelessWidget {
  static const routeName = '/userProductScreen';

  Future<void> _fun(BuildContext context) async {
    await Provider.of<product_provider>(context, listen: false)
        .fetchData(true);
  }

  @override
  Widget build(BuildContext context) {
  //  final products_P = Provider.of<product_provider>(context);
    print('this should run once');
    return Scaffold(
      appBar: AppBar(
        title: Text('You Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(editProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fun(context),
        builder: (ctx, snap) =>
        snap.connectionState == ConnectionState.waiting
            ? Center(child:CircularProgressIndicator(),)
            : RefreshIndicator(
          onRefresh: () async {
            await Provider.of<product_provider>(context, listen: false)
                .fetchData(true);
          },
          child: Consumer<product_provider>(
            builder: (ctx,products_P,_) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemBuilder: (_, i) =>
                    Column(
                      children: [
                        userProductsItems(
                          id: products_P.items[i].id,
                          title: products_P.items[i].title,
                          imageUrl: products_P.items[i].imageUrl,
                        ),
                        Divider()
                      ],
                    ),
                itemCount: products_P.items.length,
              ),
            ),
          ),
        ),
      ),
      drawer: appDrawer(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:louie_shop/provider/product_provider.dart';
// import 'package:louie_shop/widgets/app_drawer.dart';
// import 'package:provider/provider.dart';
// import 'package:louie_shop/screens/editProductScreen.dart';
// import '../widgets/userProductItems.dart';
//
// class userProductScreen extends StatelessWidget {
//   static const routeName = '/userProductScreen';
//
//   @override
//   Widget build(BuildContext context) {
//     final products_P = Provider.of<product_provider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('You Products'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).pushNamed(editProductScreen.routeName);
//             },
//             icon: Icon(Icons.add),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async{
//           await Provider.of<product_provider>(context,listen: false).fetchData(true);
//
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView.builder(
//             itemBuilder: (_, i) => Column(
//               children: [
//                 userProductsItems(
//                   id: products_P.items[i].id,
//                   title: products_P.items[i].title,
//                   imageUrl: products_P.items[i].imageUrl,
//                 ),
//                 Divider()
//               ],
//             ),
//             itemCount: products_P.items.length,
//           ),
//         ),
//       ),
//       drawer: appDrawer(),
//     );
//   }
// }
//
//
//
