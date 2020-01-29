import 'package:flutter/material.dart';

class BuyerCartPage extends StatefulWidget {
  @override
  _BuyerCartPageState createState() => _BuyerCartPageState();
}

class _BuyerCartPageState extends State<BuyerCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: Text('Cart Feature Coming Soon in Next Release!'),
      ),
    );
  }
}
