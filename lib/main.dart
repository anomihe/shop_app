import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import './providers/products_provider.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Auth();
          },
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (
            BuildContext context,
            auth,
            previousProvider,
          ) {
            return Products(auth.token!, auth.userId,
                previousProvider == null ? [] : previousProvider.items);
          },
          create: (_) => Products(
            Provider.of<Auth>(context).token!,
            Provider.of<Auth>(context).userId,
            [],
          ),
        ),
        ChangeNotifierProvider(create: (BuildContext context) {
          return Cart();
        }),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (
            BuildContext context,
            auth,
            previousProvider,
          ) {
            return Orders(auth.token!, auth.userId,
                previousProvider == null ? [] : previousProvider.orders);
          },
          create: (_) => Orders(Provider.of<Auth>(context).token!,
              Provider.of<Auth>(context).userId, []),
        ),
        // ChangeNotifierProvider(create: (BuildContext context) {
        //   return Orders();
        // }),
      ],
      child: Consumer<Auth>(builder: (context, auth, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primaryColor: Colors.purple,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
          ),
          home:
              auth.isAuth ? const ProductOverviewScreen() : const AuthScreen(),
          // home: const ProductOverviewScreen(),
          routes: {
            ProductDetailScreen.routeProduct: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductScreen.routeName: (context) => const UserProductScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        );
      }),
    );
  }
}
//i can use changenotifier.value which 