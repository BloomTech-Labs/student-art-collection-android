import 'package:flutter/material.dart';
import 'package:student_art_collection/core/presentation/page/starter_screen.dart';
import 'package:student_art_collection/core/util/route_generator.dart';
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
      initialRoute: StarterScreen.ID,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
