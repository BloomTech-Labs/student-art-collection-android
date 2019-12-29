import 'package:flutter/material.dart';

class AppBarLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
      ),
    );
  }
}
