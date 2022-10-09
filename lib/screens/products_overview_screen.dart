import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';

import '../providers/products_provider.dart';
import '../widgets/products_grid.dart';

enum filterOptions {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('myShop'),
        actions: [
          PopupMenuButton(
            onSelected: (filterOptions value) {
              setState(() {
                if (value == filterOptions.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favorite'),
                value: filterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: filterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, value, ch) => Badge(
              value: '${value.itemCount}',
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(_showFavoriteOnly),
    );
  }
}
