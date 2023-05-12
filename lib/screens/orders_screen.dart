import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const routeName = '/orderscreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;
  late Future _resultsObtained;
  @override
  void initState() {
    //this works before using futurebuilder
    // Future.delayed(Duration.zero).then((value) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    //   setState(() {
    //     _isLoading = true;
    //   });
    // });
    _resultsObtained = _obtainOrdersFture();
    super.initState();
  }

  Future _obtainOrdersFture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
          future: _resultsObtained,
          builder: (context, sna) {
            if (sna.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (sna.hasData) {
                return const Center(child: Text('error eccoured'));
              } else {
                return Consumer<Orders>(
                  builder: (context, ordersData, child) => ListView.builder(
                      itemCount: ordersData.orders.length,
                      itemBuilder: (context, index) {
                        return OrderItemWidget(
                            orderItem: ordersData.orders[index]);
                      }),
                );
              }
            }

            // ordersData.orders.isEmpty || _isLoading
            //     ? const Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     : ListView.builder(
            //         itemCount: ordersData.orders.length,
            //         itemBuilder: (context, index) {
            //           return OrderItemWidget(
            //               orderItem: ordersData.orders[index]);
            //         });
          }),
    );
  }
}
