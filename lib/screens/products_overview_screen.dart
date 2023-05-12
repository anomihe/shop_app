import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
// import 'package:shop_app/providers/products_provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import 'cart_screen.dart';

enum FilteredOptions {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavrites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    //Provider.of<Products>(context).fetchAndSetProduct();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context).fetchAndSetProduct();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'MyShop',
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilteredOptions selectedValue) {
              setState(() {
                if (selectedValue == FilteredOptions.favorites) {
                  //   productContainer.showFav();
                  _showOnlyFavrites = true;
                } else {
                  // productContainer.showAll();
                  _showOnlyFavrites = false;
                }
              });
            },
            itemBuilder: (_) {
              return [
                const PopupMenuItem(
                  value: FilteredOptions.favorites,
                  child: Text('Only Favourite'),
                ),
                const PopupMenuItem(
                  value: FilteredOptions.all,
                  child: Text('Show All'),
                )
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return CustomBadge(
                value: cart.itemCount.toString(),
                child: child!,
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGrid(
              isFav: _showOnlyFavrites,
            ),
    );
  }
}
