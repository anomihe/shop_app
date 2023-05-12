import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.isFav
      // required this.loadedProduct,
      });
  final bool isFav;
  // final List<Product> loadedProduct;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final loadedProduct = isFav ? productData.favoriteItems : productData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProduct.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            // create: (context) => loadedProduct[index],
            //this is the right way to provider on something that is part of a grid or listview

            value: loadedProduct[index],
            child: const ProductItem(
                // id: loadedProduct[index].id,
                // title: loadedProduct[index].title,
                // imageUrl: loadedProduct[index].imageUrl
                ),
          );
        });
  }
}
