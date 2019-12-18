import 'package:flutter/material.dart';

class StarterScreen extends StatefulWidget {
  static const ID = "/";

  @override
  _StarterScreenState createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'This is the StarterScreen',
          ),
        ),
      ),
    );
  }
}
