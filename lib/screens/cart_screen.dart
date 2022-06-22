import 'package:flutter/material.dart';
import 'package:louie_shop/provider/orders.dart';
import 'package:provider/provider.dart';
import 'package:louie_shop/widgets/cart_item.dart';
import '../provider/cart_provider.dart';

class cartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<cartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.getTotlalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  orderButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => cartItem(
                id: cart.items.values.toList()[i].id,
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price,
                title: cart.items.values.toList()[i].title,
                cartId: cart.items.keys.toList()[i],
              ),
              itemCount: cart.getItemLenght,
            ),
          )
        ],
      ),
    );
  }
}

class orderButton extends StatefulWidget {
  const orderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final cartProvider cart;

  @override
  State<orderButton> createState() => _orderButtonState();
}

class _orderButtonState extends State<orderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.getTotlalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<orderprovider>(context, listen: false)
                  .addOrders(widget.cart.items.values.toList(),
                      widget.cart.getTotlalAmount);
              widget.cart.cleanCart();
              setState(() {
                _isLoading = false ;
              });
            },
      child: _isLoading ? Center(child: CircularProgressIndicator()) :  Text(
        'Order Now',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
