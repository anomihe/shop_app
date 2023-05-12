import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  // final String id;
  // final String title;
  // final String imageUrl;
  // const ProductItem({
  //   super.key,
  //   required this.id,
  //   required this.title,
  //   required this.imageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  product.toggleavouriteStatus(
                      authData.token!, authData.userId);
                },
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                cart.addItem(
                  product.id,
                  product.price,
                  product.title,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added to cart'),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ),
                );
              },
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            )),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeProduct,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
