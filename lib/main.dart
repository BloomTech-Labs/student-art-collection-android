import 'package:flutter/material.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/presentation/page/starter_screen.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_screen.dart';
import 'package:student_art_collection/features/list_art/presentation/page/login_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/registration_page.dart';

import 'core/presentation/page/login_screen.dart';
import 'service_locator.dart' as locator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locator.init();
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
        SchoolLoginPage.ID: (context) => SchoolLoginPage(),
        GalleryScreen.ID: (context) => GalleryScreen(),
        SchoolRegistrationPage.ID: (context) => SchoolRegistrationPage(),
        StarterScreen.ID: (context) => StarterScreen(),
      },
    );
  }
}
