import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imaageUrl;
  const UserProductItem({
    super.key,
    required this.id,
    required this.title,
    required this.imaageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imaageUrl,
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id);
            },
            icon: const Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () async {
              try {
                Provider.of<Products>(context, listen: false).delete(id);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Deleting failed'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.delete),
            color: Theme.of(context).colorScheme.error,
          ),
        ]),
      ),
    );
  }
}
