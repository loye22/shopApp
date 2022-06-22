import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../provider/orders.dart';

class orderItemWidget extends StatefulWidget {
  final orderItem order;

  orderItemWidget({this.order});

  @override
  State<orderItemWidget> createState() => _orderItemWidgetState();
}

class _orderItemWidgetState extends State<orderItemWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${(widget.order.amount).toStringAsFixed(2)}'),
            subtitle: Text(
                '${DateFormat('dd/MM/yyy hh:mm').format(
                    widget.order.dateOrder)}'),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          //     if (expanded)
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            height: expanded ? min(
                widget.order.cart.length * 20.0 + 100.0, 180.0) :0,
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              height: min(widget.order.cart.length * 20.0 + 100.0, 180.0),
              // height: 100,
              child: ListView.builder(
                itemBuilder: (ctx, i) =>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.order.cart[i].title,
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.order.cart[i].quantity} x \$${widget.order
                              .cart[i].price}',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )
                      ],
                    ),
                itemCount: widget.order.cart.length,
              ),
            ),
          )
          // Container(
          //   padding: EdgeInsets.all(10),
          //   margin:  EdgeInsets.all(10),
          //   height: min(widget.order.cart.length * 20.0 + 100.0, 180.0),
          //  // height: 100,
          //   child: ListView.builder(
          //     itemBuilder: (ctx, i) => Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           widget.order.cart[i].title,
          //           style:
          //               TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //         ),
          //         Text(
          //           '${widget.order.cart[i].quantity} x \$${widget.order.cart[i].price}',
          //           style: TextStyle(fontSize: 18, color: Colors.grey),
          //         )
          //       ],
          //     ),
          //     itemCount: widget.order.cart.length,
          //   ),
          // )
        ],
      ),
    );
  }
}
