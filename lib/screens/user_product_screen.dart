import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userProduct';
  const UserProductScreen({super.key});
  Future<void> refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: refreshProduct(context),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return refreshProduct(context);
                    },
                    child: Consumer<Products>(
                        builder: (context, productData, child) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  UserProductItem(
                                    id: productData.items[index].id,
                                    title: productData.items[index].title,
                                    imaageUrl:
                                        productData.items[index].imageUrl,
                                  ),
                                  const Divider()
                                ],
                              );
                            }),
                      );
                    }),
                  );
          }),
    );
  }
}
