import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    required this.description,
    required this.id,
    required this.imageUrl,
    this.isFavorite = false,
    required this.price,
    required this.title,
  });
  void isFavoriteChanged(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleavouriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    // final url = Uri.parse(
    //   'https://myshp-112d1-default-rtdb.firebaseio.com/products/$id.json?authToken=$token',
    // );
    final url = Uri.parse(
      'https://myshp-112d1-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?authToken=$token',
    );
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavoriteChanged(oldStatus);
      }
    } catch (error) {
      isFavoriteChanged(oldStatus);
    }
  }
}
