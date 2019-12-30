import 'package:flutter/material.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_screen.dart';

import 'core/presentation/page/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginScreen.ID: (context) => LoginScreen(),
        GalleryScreen.ID: (context) => GalleryScreen(),
      },
    );
  }
}
