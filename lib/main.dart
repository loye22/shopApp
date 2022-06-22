import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:louie_shop/provider/cart_provider.dart';
import 'package:louie_shop/provider/orders.dart';
import 'package:louie_shop/provider/product_provider.dart';
import 'package:louie_shop/screens/4.1%20auth_screen.dart';
import 'package:louie_shop/screens/order_screen.dart';
import 'package:louie_shop/screens/product_sceen_detales.dart';
import 'package:louie_shop/screens/products_overview_screens.dart';
import 'package:louie_shop/screens/user_product_screen.dart';
import 'package:louie_shop/widgets/16.1%20splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:louie_shop/screens/cart_screen.dart';
import 'package:louie_shop/screens/editProductScreen.dart';
import 'provider/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => cartProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, product_provider>(
            update: (ctx, authP, prevuosPrductsData) =>
                product_provider(authP.token, authP.userId),
          ),
          ChangeNotifierProxyProvider<AuthProvider, orderprovider>(
              update: (ctx, auth, previosData) => orderprovider(auth.token,
                  auth.userId, previosData == null ? [] : previosData.orders)),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, p, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Laton'),
            home: p.isAuth
                ? ProductOverviewScreen() //:AuthScreen(),
                :FutureBuilder(
                    future: p.tryautoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting  ? SplashScreen() : AuthScreen()),

            routes: {
              ProductDetalsScreen.routeName: (ctx) => ProductDetalsScreen(),
              cartScreen.routeName: (ctx) => cartScreen(),
              orderScreen.routeName: (ctx) => orderScreen(),
              userProductScreen.routeName: (ctx) => userProductScreen(),
              editProductScreen.routeName: (ctx) => editProductScreen(),
              ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            },
          ),
        ));
  }
}

//
// MaterialApp(
// title: 'MyShop',
// theme: ThemeData(
// primarySwatch: Colors.purple,
// accentColor: Colors.deepOrange,
// fontFamily: 'Laton'),
// home: p.isAuth ? ProductOverviewScreen() : AuthScreen(),
// routes: {
// ProductDetalsScreen.routeName: (ctx) => ProductDetalsScreen(),
// cartScreen.routeName: (ctx) => cartScreen(),
// orderScreen.routeName: (ctx) => orderScreen(),
// userProductScreen.routeName: (ctx) => userProductScreen(),
// editProductScreen.routeName: (ctx) => editProductScreen(),
// ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
// },
// )
