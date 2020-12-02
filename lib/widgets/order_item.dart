import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../provider/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('₹${widget.order.amount}'),
            subtitle: Text(
              DateFormat('hh:mm  dd/MM').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          // if (_expanded)
          //   Divider(
          //     thickness: 1,
          //   ),
          if (_expanded)
            Container(
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: min(widget.order.products.length * 15.0 + 25, 150),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '${prod.quantity} X ₹${prod.price}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
