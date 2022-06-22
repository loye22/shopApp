import 'package:flutter/material.dart';
import 'package:louie_shop/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class cartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String cartId;

  cartItem({this.id, this.price, this.quantity, this.title, this.cartId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (d) {
        Provider.of<cartProvider>(context, listen: false).removeItem(cartId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(child: Text('\$${price.toStringAsFixed(2)}')),
              ),
            ),
            title: Text(title),
            subtitle: Text(' total \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
      confirmDismiss: (d) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure ? '),
            content: Text('This action will delete your product'),
            actions: [
              FlatButton(onPressed: (){
                Navigator.of(context).pop(true);
              }, child: Text('Yes')),
              FlatButton(onPressed: (){
                Navigator.of(context).pop(false);
              }, child: Text('No'))
            ],
          ),
        );
      },
    );
  }
}
