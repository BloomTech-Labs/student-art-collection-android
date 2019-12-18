import 'package:flutter/material.dart';
import 'package:student_art_collection/core/presentation/page/starter_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        StarterScreen.ID: (context) => StarterScreen(),
      },
    );
  }
}
