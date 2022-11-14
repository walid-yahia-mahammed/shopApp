import 'dart:convert';
//packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//providers
import './cart.dart';
import '../secret/config.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future fetchAndSetOrders() async {
    const url = '${Config.base_url}/orders.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedOrderItems =
          json.decode(response.body) as Map<String, dynamic>;
      List<CartItem> Productslist = [];
      List<OrderItem> loadedOrderItems = [];
      extractedOrderItems.forEach((id, values) {
        values['products'].forEach((product) {
          Productslist.add(CartItem(
              id: product['id'],
              title: product['title'],
              qty: product['quantity'],
              price: product['price']));
        });
        loadedOrderItems.add(
          OrderItem(
            id: id,
            amount: values['amount'],
            products: Productslist,
            dateTime: DateTime.parse(values['dateTime']),
          ),
        );
      });
      _orders = loadedOrderItems;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future addOrder(List<CartItem> cartProducts, double total) async {
    const url = '${Config.base_url}/orders.json';
    try {
      final timestamp = DateTime.now();
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.qty,
                    'price': cp.price,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
