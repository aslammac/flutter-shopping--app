import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/badge.dart';
//models
import '../provider/products.dart';
import '../provider/cart.dart';
//widgests
import '../widgets/products_grid.dart';
//pages
import './cart_page.dart';
//app drawer
import '../widgets/app_drawer.dart';

enum FilterOption {
  Favourites,
  All,
}

class ProductOverviewPage extends StatefulWidget {
  static const routeName = '/product-overview';

  @override
  _ProductOverviewPageState createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  // int _counter = 0;
  // String _name = '';

  // @override
  // void initState() {
  //   super.initState();
  //   _loadCounter();
  // }

  // //Loading counter value on start
  // _loadCounter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _counter = (prefs.getInt('counter') ?? 0);
  //     _name = (prefs.getString('name') ?? '');
  //   });
  // }

  // //Incrementing counter after click
  // _incrementCounter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _counter = (prefs.getInt('counter') ?? 0) + 1;
  //     _name = (prefs.getString('name') ?? 'aslam');
  //     prefs.setInt('counter', _counter);
  //     prefs.setString('name', _name);
  //   });
  // }
  var _isInit = true;
  var _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool _showOnlyFav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favourites) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favourite'),
                value: FilterOption.Favourites,
              ),
              PopupMenuItem(
                child: Text('View all'),
                value: FilterOption.All,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
                IconButton(
                  icon: Icon(Icons.shopping_cart, size: 20),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartPage.routeName);
                  },
                ),
                cart.count),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFav),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: '$_name',
      //   child: Text(
      //     '$_counter',
      //     style: Theme.of(context).textTheme.headline4,
      //   ),
      // ),
    );
  }
}
