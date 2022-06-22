import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:louie_shop/models/HttpExeption.dart';
import 'package:louie_shop/provider/product_provider.dart';
import 'package:provider/provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id = '',
    @required this.title = '',
    @required this.description ='',
    @required this.price=0.0,
    @required this.imageUrl='',
    this.isFavorite = false,
  });



  // void toggleFavorite(){
  //   isFavorite = !isFavorite ;
  //   notifyListeners();
  // }

  Future<void>toggleFavorite(String id , String authToken , String userId ) async{
    var oldStatus = isFavorite ;
    isFavorite = !isFavorite ;
    notifyListeners();
    final  url = 'https://flutter-app-9403a-default-rtdb.firebaseio.com/userFavoreit/$userId/$id.json?auth=$authToken';
    try{
    final res =  await http.put(Uri.parse(url) , body:json.encode( isFavorite) );
    if(res.statusCode > 400){
      isFavorite = oldStatus ;

      notifyListeners();
      throw HttpExption(msg: 'dddd') ;
    }
    }
    catch(e){
      throw e ;


    }

    notifyListeners();
  }


}
