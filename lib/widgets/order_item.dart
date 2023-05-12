import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shop_app/providers/orders.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  const OrderItemWidget({super.key, required this.orderItem});

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(
              DateFormat('dd:MM:yyyy hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(
                widget.orderItem.products.length * 20 + 10,
                180,
              ),
              child: ListView(
                children: widget.orderItem.products.map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${e.quantity} x \$${e.price}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      )
                    ],
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
