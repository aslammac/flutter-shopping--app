import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './pages/splash_screen.dart';
//pages
import './pages/product_overview_page.dart';
import './pages/product_detail_page.dart';
import './pages/cart_page.dart';
import './pages/order_page.dart';
import './pages/user_products_page.dart';
import './pages/edit_products.dart';
import './pages/auth_page.dart';
//provider
import './provider/products.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import './provider/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (BuildContext context) => Products(null, null, []),
            update: (BuildContext context, auth, prevProduct) => Products(
              auth.token,
              auth.userId,
              prevProduct == null ? [] : prevProduct.items,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(null, null, []),
            update: (ctx, auth, oldOrder) => Orders(auth.token, auth.userId,
                oldOrder == null ? [] : oldOrder.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.cyan,
                fontFamily: 'Roboto',
                primaryTextTheme:
                    TextTheme(headline6: TextStyle(color: Colors.black))),
            home: auth.isAuth
                ? ProductOverviewPage()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthPage()),
            routes: {
              // ProductOverviewPage.routeName: (ctx) => ProductOverviewPage(),
              ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
              CartPage.routeName: (ctx) => CartPage(),
              OrderPage.routeName: (ctx) => OrderPage(),
              UserProductsPage.routeName: (ctx) => UserProductsPage(),
              EditProducts.routeName: (ctx) => EditProducts(),
            },
          ),
        ));
  }
}
