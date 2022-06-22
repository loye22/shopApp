import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:louie_shop/models/products.dart';

import '../provider/product_provider.dart';

class ProductDetalsScreen extends StatelessWidget {
  static const routeName = '/ProductDetalsScreen';

  @override
  Widget build(BuildContext context) {
    final pId = ModalRoute.of(context)?.settings.arguments as String;
    final productDetals =
        Provider.of<product_provider>(context, listen: false).findById(pId);
    return Scaffold(
      // appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productDetals.title),
              background: Hero(
                tag: productDetals.id,
                child: Image.network(
                  productDetals.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          //listview
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(productDetals.price.toString())
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_border,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_shopping_cart,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 800,
              )
            ]),
          )
        ],
      ),
    );
  }
}
