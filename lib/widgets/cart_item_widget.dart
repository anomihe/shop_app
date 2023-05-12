import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String prodId;
  final double price;
  final int quantity;
  final String title;
  const CartItemWidget({
    super.key,
    required this.id,
    required this.price,
    required this.prodId,
    required this.quantity,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(prodId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (constext) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content:
                    const Text('Do you want to remove the item from the cart?'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes')),
                ],
              );
            });
      },
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            trailing: Text('$quantity *'),
            subtitle: Text('Total: \$${price * quantity}'),
          ),
        ),
      ),
    );
  }
}
