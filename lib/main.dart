import 'package:flutter/material.dart';
import 'package:student_art_collection/core/presentation/page/login_page.dart';
import 'package:student_art_collection/core/util/route_generator.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localization.dart';
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
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(color: Colors.black, fontSize: 20),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          color: primaryColor,
        ),
        primaryColor: primaryColor,
        accentColor: accentColor,
      ),
      initialRoute: LoginPage.ID,
      onGenerateRoute: RouteGenerator.generateRoute,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'MX'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
