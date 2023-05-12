import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  //var _showFavoritiesOnly = false;

  List<Product> get items {
    //using this approach to change the favorite state globally in the
    //app this is the best option
    // if (_showFavoritiesOnly) {
    //   return _items.where((proItem) => proItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items
        .where(
          (prodItem) => prodItem.isFavorite,
        )
        .toList();
  }

  // void showFav() {
  //   _showFavoritiesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritiesOnly = false;
  //   notifyListeners();
  // }

//for product details
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // Future<void> addProvider(Product product) {
  //   final url = Uri.parse(
  //     'https://myshp-112d1-default-rtdb.firebaseio.com/products.json',
  //   );
  //   return http
  //       .post(url,
  //           body: json.encode({
  //             'title': product.title,
  //             'description': product.description,
  //             'imageUrl': product.imageUrl,
  //             'price': product.price,
  //             'isFavourite': product.isFavorite,
  //           }))
  //       .then((value) {
  //     final newProduct = Product(
  //         description: product.description,
  //         id: json.decode(value.body)['name'],
  //         imageUrl: product.imageUrl,
  //         price: product.price,
  //         title: product.title);
  //     _items.add(newProduct);
  //     notifyListeners();
  //   }).catchError((error) {
  //     throw error;
  //   });
  Future<void> addProvider(Product product) async {
    final url = Uri.parse(
      'https://myshp-112d1-default-rtdb.firebaseio.com/products.json?auth=$authToken',
    );
    try {
      final responese = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
            //   'isFavourite': product.isFavorite,
          }));

      final newProduct = Product(
          description: product.description,
          id: json.decode(responese.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // catchError((error) {
    //   throw error;
    // });

    // final newProduct = Product(
    //     description: product.description,
    //     id: DateTime.now().toIso8601String(),
    //     imageUrl: product.imageUrl,
    //     price: product.price,
    //     title: product.title);
    // _items.add(newProduct);
    // notifyListeners();
  }

  Future<void> fetchAndSetProduct() async {
    final url = Uri.parse(
      'https://myshp-112d1-default-rtdb.firebaseio.com/products.json?authToken=$authToken&orderby="creatorId"equalTo="$userId"',
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final url2 = Uri.parse(
        'https://myshp-112d1-default-rtdb.firebaseio.com/userFavorites/$userId.json?authToken=$authToken',
      );
      final favoriteResponse = await http.get(url2);
      final favouriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, productData) {
        loadedProducts.add(Product(
          description: productData['description'],
          id: prodId,
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          title: productData['title'],
          isFavorite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
          // isFavorite: productData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> update(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere(
      (prod) => prod.id == id,
    );
    if (prodIndex >= 0) {
      final url = Uri.parse(
        'https://myshp-112d1-default-rtdb.firebaseio.com/products/$id.json?authToken=$authToken',
      );
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavourite': newProduct.isFavorite,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  // void delete(String id) {
  //   final url = Uri.parse(
  //     'https://myshp-112d1-default-rtdb.firebaseio.com/products.json',
  //   );
  //   final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  //   Product? existingProduct = _items[existingProductIndex];

  //   http.delete(url).then((response) {
  //     if (response.statusCode >= 400) {
  //       throw HttpException('Could not delete product');
  //     }
  //     existingProduct = null;
  //   }).catchError((_) {
  //     _items.insert(existingProductIndex, existingProduct!);
  //   });
  //   //  _items.removeWhere((prod) => prod.id == id);
  //   _items.removeAt(existingProductIndex);
  //   notifyListeners();
  // }
  Future<void> delete(String id) async {
    final url = Uri.parse(
      'https://myshp-112d1-default-rtdb.firebaseio.com/products/$id.json?authToken=$authToken',
    );
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      throw HttpException('Could not delete product');
    } else {}
    existingProduct = null;

    //  _items.removeWhere((prod) => prod.id == id);
  }
}
