import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:louie_shop/models/HttpExeption.dart';
import 'package:louie_shop/models/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class product_provider with ChangeNotifier {
  final String _authToken;

  final String _userId;

  product_provider(this._authToken, this._userId);

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProduct(Product p) async {
    final url =
        'https://flutter-app-9403a-default-rtdb.firebaseio.com/products.json?auth=$_authToken';
    try {
      final r = await http.post(Uri.parse(url),
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'price': p.price,
            'imageUrl': p.imageUrl,
            'isFavorite': p.isFavorite,
            'userId': _userId
          }));

      p = Product(
          id: json.decode(r.body)['name'],
          title: p.title,
          description: p.description,
          price: p.price,
          imageUrl: p.imageUrl);
      _items.add(p);
      notifyListeners();
    } catch (e) {
      print('error $e');
      throw e;
    } finally {}
  }

  Future<void> fetchData([bool filter = false]) async {
    final filterData = filter  ? 'orderBy="userId"&equalTo="$_userId"' : '';

    final url =
        'https://flutter-app-9403a-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterData';
    final url2 =
        'https://flutter-app-9403a-default-rtdb.firebaseio.com/userFavoreit/$_userId.json?auth=$_authToken';

    try {
      final respond = await http.get(Uri.parse(url));
      final extractedData = json.decode(respond.body) as Map<String, dynamic>;
      final favoreItres = await http.get(Uri.parse(url2));
      final ext2 = json.decode(favoreItres.body);

      if (extractedData == null) {
        return;
      }
      final List<Product> loadedData = [];
      extractedData.forEach((key, value) {
        loadedData.add(Product(
            id: key,
            title: value['title'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            description: value['description'],
            isFavorite: ext2 == null ? false : ext2[key] ?? false));
      });
      _items = loadedData;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((e) => e.id == id);
  }

  List<Product> get favoreitItems {
    return _items.where((e) => e.isFavorite).toList();
  }

  Future<void> editProduct(String id, Product edit) async {
    final index = _items.indexWhere((element) => element.id == id);
    final url =
        'https://flutter-app-9403a-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': edit.title,
          'price': edit.price,
          'description': edit.description,
          'imageUrl': edit.imageUrl,
        }));

    _items[index] = edit;
    notifyListeners();
  }

  Future<void> removeProductById(String id) async {
    final url =
        'https://flutter-app-9403a-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken';
    final indx = _items.indexWhere((element) => element.id == id);
    var exe_product = _items[indx];
    _items.removeWhere((element) => element.id == id);
    final res = await http.delete(Uri.parse(url));
    if (res.statusCode > 400) {
      _items.insert(indx, exe_product);
      notifyListeners();
      throw HttpExption(msg: 'Could not delete the item');
    }
    exe_product = null;
    notifyListeners();
  }
}
