import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import '../widgets/cart_item_widget.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/CartScreen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        cart.totalAmout.toStringAsFixed(2),
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .titleLarge!
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart)
                  ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (context, index) {
                    return CartItemWidget(
                      id: cart.items.values.toList()[index].id,
                      prodId: cart.items.keys.toList()[index],
                      title: cart.items.values.toList()[index].title,
                      quantity: cart.items.values.toList()[index].quantity,
                      price: cart.items.values.toList()[index].price,
                    );
                  }))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmout <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmout,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: const Text('ORDER NOW'),
    );
  }
}
