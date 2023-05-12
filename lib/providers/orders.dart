import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];

  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
      'https://myshp-112d1-default-rtdb.firebaseio.com/orders/$userId.json?authToken=$authToken',
    );
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTimee': timeStamp.toIso8601String(),
          'products': cartProducts.map((e) {
            return {
              'id': e.id,
              'title': e.title,
              'price': e.price,
              'quantity': e.quantity,
            };
          }).toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
      'https://myshp-112d1-default-rtdb.firebaseio.com/orders/$userId .json?auth=$authToken',
    );
    final response = await http.get(url);
    final List<OrderItem> loadOrders = [];
    final extractedItems = json.decode(response.body) as Map<String, dynamic>;
    if (extractedItems == null) {
      return;
    }
    extractedItems.forEach((orderId, orderData) {
      loadOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['product'])
              .map(
                (e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price']),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadOrders.reversed.toList();
    notifyListeners();
  }
}
