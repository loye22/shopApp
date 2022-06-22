import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id = '',
    @required this.title = '',
    @required this.quantity = 0,
    @required this.price = 0.0,
  });
}

class cartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  void addItems(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
        ),
      );
    }

    notifyListeners();
  }

  int get getItemLenght {
    return _items.length;
  }

  double get getTotlalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  Map<String, CartItem> get items {
    return {..._items};
  }

  void removeItem(String id) {
    _items.removeWhere((key, value) => key == id);
    notifyListeners();
  }

  void cleanCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
          id,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price));
    }
    else {
      this.removeItem(id);
    }
    notifyListeners();
  }


}
