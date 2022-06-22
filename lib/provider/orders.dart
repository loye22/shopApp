import 'package:flutter/cupertino.dart';
import 'package:louie_shop/provider/cart_provider.dart';
import 'package:http/http.dart ' as http;
import 'dart:convert';

class orderItem {
  final String id;
  final double amount;
  final List<CartItem> cart;
  final DateTime dateOrder;

  orderItem(
      {@required this.cart,
      @required this.id,
      @required this.amount,
      @required this.dateOrder});
}

class orderprovider with ChangeNotifier {
  List<orderItem> _orders = [];
  final String _authToken;
  final String userId ;

  orderprovider(this._authToken, this.userId,this._orders );

  List<orderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cart, double totla) async {
    final url =
        'https://flutter-app-9403a-default-rtdb.firebaseio.com/order/$userId.json?auth=$_authToken';
    final timeStamp = DateTime.now();
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': totla,
            'dateOrder': timeStamp.toIso8601String(),
            'cart': cart
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price
                    })
                .toList(),
          }));
    } catch (e) {}
    _orders.insert(
        0,
        orderItem(
            cart: cart,
            id: DateTime.now().toString(),
            amount: totla,
            dateOrder: DateTime.now()));
    notifyListeners();
  }

  Future<void> fitchOrder() async {
    final url =
        'https://flutter-app-9403a-default-rtdb.firebaseio.com/order/$userId.json?auth=$_authToken';

    try {
      final res = await http.get(Uri.parse(url));
      var extraxtedData = json.decode(res.body) as Map<String, dynamic>;
      if (extraxtedData == null) {
        return;
      }
      final List<orderItem> loadedOrder = [];
      extraxtedData.forEach((key, p) {
        loadedOrder.add(orderItem(
            id: key,
            amount: p['amount'],
            dateOrder: DateTime.parse(p['dateOrder']),
            cart: (p['cart'] as List<dynamic>)
                .map((e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price']))
                .toList()));
      });
      _orders = loadedOrder.reversed.toList();
      print('loadedOrder');
      notifyListeners();
    } catch (e) {
      print('error');
      print(e);
      throw e;
    }
  }
}
